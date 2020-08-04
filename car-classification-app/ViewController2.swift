//
//  ViewController2.swift
//  car-classification-app
//
//  Created by Gautham Gorti on 8/3/20.
//  Copyright © 2020 Gautham Gorti. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    
    //MARK: Properties
    var image: UIImage?
    @IBOutlet weak var imageView: UIImageView!
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    //MARK: View Cycle Functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = self.image
    }
    
    //MARK: Navigation
    @IBAction func cancelButton(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func useButton(_ sender: UIButton) {
        guard
            let nextVC = storyboard?.instantiateViewController(identifier: "CropScreen") as! ViewController3?
            else { print("CropScreen could not be loaded"); return }
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.image = self.image
        nextVC.rootController = presentingViewController as! ViewController1?
        present(nextVC, animated: true, completion: nil)
    }
    
}
