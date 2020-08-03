//
//  ViewController.swift
//  car-classification-app
//
//  Created by Gautham Gorti on 8/3/20.
//  Copyright © 2020 Gautham Gorti. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController1: UIViewController, AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    let captureSession = AVCaptureSession()
    let cameraButton = UIButton(type: .custom)
    var image: UIImage?
    @IBOutlet weak var videoView: videoView!
    @IBOutlet weak var photoSelectButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        photoSelectButton.backgroundColor = UIColor.white
    }
    
    func prepareCaptureSession() {
        captureSession.beginConfiguration()
        guard
            let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                  for: .video,
                                                  position: .unspecified)
            else { fatalError("Missing expected back camera device") }
        guard
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!),
            captureSession.canAddInput(videoDeviceInput)
            else { print("Something went wrong configuring AVCaptureDeviceInput"); return }
        captureSession.addInput(videoDeviceInput)
        videoView.videoPreviewLayer.session = captureSession
        videoView.videoPreviewLayer.videoGravity = .resizeAspectFill
        
        let photoOutput = AVCapturePhotoOutput()
        guard captureSession.canAddOutput(photoOutput) else { print("Something went wrong configuring AVCaptureDeviceOutput") ; return }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)

        captureSession.commitConfiguration()
    }
    
    func addCameraButton() {
        self.view.addSubview(cameraButton)

        //button.backgroundColor = UIColor.white
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.widthAnchor.constraint(equalToConstant: 72).isActive = true
        cameraButton.heightAnchor.constraint(equalToConstant: 72).isActive = true
        cameraButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        cameraButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -32).isActive = true
        cameraButton.layer.cornerRadius = 36
        cameraButton.layer.borderWidth = 6
        cameraButton.layer.borderColor = UIColor.white.cgColor
        cameraButton.layer.backgroundColor = UIColor.clear.cgColor
        cameraButton.showsTouchWhenHighlighted = true
        
        cameraButton.addTarget(self, action: #selector(pressCameraButton), for: .touchUpInside)
    }
    
    func capturePhoto() {
        let photoOutput = captureSession.outputs[0] as! AVCapturePhotoOutput
        let settingsDict = [kCVPixelBufferPixelFormatTypeKey as String  :photoOutput.availablePhotoPixelFormatTypes[0]]
        let photoSettings = AVCapturePhotoSettings(format: settingsDict)
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    @objc func pressCameraButton() {
        // this will take a photo, then navigate to another view controller
        let serialQueue = DispatchQueue(label: "photoQueue")
        serialQueue.async {
            self.capturePhoto()
        }
        serialQueue.async {
            self.goToPictureScreen()
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        image = UIImage(data: photo.fileDataRepresentation()!)
    }
    
    func goToPictureScreen() {
        DispatchQueue.main.async {
            guard
                let pictureScreen = storyboard?.instantiateViewController(identifier: "PictureScreen") as! ViewController2?
                else { return }
            pictureScreen.image = self.image
            pictureScreen.modalPresentationStyle = .fullScreen
            present(pictureScreen, animated: true, completion: nil)
        }
    }


}

