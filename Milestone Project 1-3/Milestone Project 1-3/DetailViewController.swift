//
//  DetailViewController.swift
//  Milestone Project 1-3
//
//  Created by Loris on 01/04/2019.
//  Copyright © 2019 Loris. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareFlag))
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
            title = "\(imageToLoad.uppercased())"
        }
        
        imageView.layer.borderWidth = 1
        
        imageView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc func shareFlag() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.5) else {
            print("No image found!")
            return
        }
        
        let ac = UIActivityViewController(activityItems: [image, selectedImage!.uppercased()], applicationActivities: [])
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
}
