//
//  ViewController3.swift
//  car-classification-app
//
//  Created by Gautham Gorti on 8/3/20.
//  Copyright © 2020 Gautham Gorti. All rights reserved.
//

import UIKit
import TOCropViewController

class ViewController3: UIViewController, TOCropViewControllerDelegate {
    
    weak var rootController: ViewController1?
    var image: UIImage?
    var croppedImage: UIImage?
    var first: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        let controller = TOCropViewController(image: image!)
        controller.aspectRatioPickerButtonHidden = true
        controller.delegate = self
        addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)

        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            controller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            controller.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])

        controller.didMove(toParent: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if first {
            displayInstructions()
        }
    }
    
    func displayInstructions() {
        first = false
        guard
            let instructionScreen = storyboard?.instantiateViewController(identifier: "InstructionScreen")
            else { return }
        self.present(instructionScreen, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        croppedImage = image
        goToNext()
    }
    
    func goToNext() {
        guard
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "ClassificationScreen") as! ViewController5?
            else { return }
        nextVC.rootController = self.rootController
        nextVC.image = self.image
        nextVC.croppedImage = self.croppedImage
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }

}
