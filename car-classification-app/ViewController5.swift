//
//  ViewController5.swift
//  car-classification-app
//
//  Created by Gautham Gorti on 8/3/20.
//  Copyright © 2020 Gautham Gorti. All rights reserved.
//

import UIKit

class ViewController5: UIViewController {
    
    weak var rootController: ViewController1?
    var image: UIImage?
    var croppedImage: UIImage?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var fifthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = croppedImage
        DispatchQueue.global(qos: .default).async {
            self.makePrediction()
        }
    }
    
    func makePrediction() {
        let model = honda_resnet34_1().model
        let scaledImage = croppedImage?.scaleImage(toSize: CGSize(width: 128, height: 128))
        let cvImage = buffer(from: scaledImage!)
        do {
            let out = try model.prediction(from: honda_resnet34_1Input(input_1: cvImage!))
            let resultFV = out.featureValue(for: "1139")
            let resultDict = resultFV?.dictionaryValue
            var confArray = [Double]()
            var labelArray = [String]()
            for (label, confidence) in resultDict! {
                labelArray.append(label as! String)
                confArray.append(Double(truncating: confidence))
            }
            let sortedElementsAndIndices = confArray.enumerated().sorted(by: {
                $0.element > $1.element
            })
            var sortedLabels = [String]()
            var sortedConfs = [Double]()
            for item in sortedElementsAndIndices {
                sortedConfs.append(item.element)
                sortedLabels.append(labelArray[item.offset])
            }
            DispatchQueue.main.async {
                self.firstLabel.text = "\(sortedLabels[0]), \(sortedConfs[0])"
                self.secondLabel.text = "\(sortedLabels[1]), \(sortedConfs[1])"
                self.thirdLabel.text = "\(sortedLabels[2]), \(sortedConfs[2])"
                self.fourthLabel.text = "\(sortedLabels[3]), \(sortedConfs[3])"
                self.fifthLabel.text = "\(sortedLabels[4]), \(sortedConfs[4])"
            }
        } catch {
            print("something went wrong during prediction")
        }
        
    }
    @IBAction func doneButton(_ sender: UIButton) {
        rootController?.dismiss(animated: true, completion: nil)
    }
    
}

func buffer(from image: UIImage) -> CVPixelBuffer? {
  let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
  var pixelBuffer : CVPixelBuffer?
  let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
  guard (status == kCVReturnSuccess) else {
    return nil
  }

  CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
  let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

  let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
  let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

  context?.translateBy(x: 0, y: image.size.height)
  context?.scaleBy(x: 1.0, y: -1.0)

  UIGraphicsPushContext(context!)
  image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
  UIGraphicsPopContext()
  CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

  return pixelBuffer
}

extension UIImage {
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            UIGraphicsEndImageContext()
        }
        return newImage
    }
}
