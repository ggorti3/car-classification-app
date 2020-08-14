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
    
    //MARK: Properties
    let captureSession = AVCaptureSession()
    let cameraButton = UIButton(type: .custom)
    var image: UIImage?
    @IBOutlet weak var videoView: VideoView!
    @IBOutlet weak var photoSelectButton: UIButton!
    
    //MARK: View Cycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        photoSelectButton.tintColor = UIColor.white
        addCameraButton()
        prepareCaptureSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession.stopRunning()
    }
    
    //MARK: Video and Photos
    func prepareCaptureSession() {
        captureSession.beginConfiguration()
        guard
            let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                  for: .video,
                                                  position: .unspecified)
            else { fatalError("Missing expected back camera device") }
        guard
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
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
            self.capturePhoto()
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        self.image = UIImage(data: photo.fileDataRepresentation()!)
        self.goToCropScreen()
    }
    
    @IBAction func selectPhoto(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.modalPresentationStyle = .fullScreen
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")}
        self.image = selectedImage
        dismiss(animated: true, completion: nil)
        goToCropScreen()
    }
    
    //MARK: Navigation
    
    func goToCropScreen() {
        guard
            let cropScreen = self.storyboard?.instantiateViewController(identifier: "CropScreen") as! ViewController3?
            else { print("PictureScreen could not be loaded"); return }
        cropScreen.image = self.image
        cropScreen.modalPresentationStyle = .fullScreen
        cropScreen.rootController = self
        self.present(cropScreen, animated: true, completion: nil)
    }
    
    
}

