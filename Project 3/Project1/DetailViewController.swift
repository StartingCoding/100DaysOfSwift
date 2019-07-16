//
//  DetailViewController.swift
//  Project1
//
//  Created by Loris on 26/03/2019.
//  Copyright © 2019 Loris. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var totalImages = 0
    var imageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Picture \(imageIndex) of \(totalImages)"
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped() {
        guard let image = imageView.image else {
            print("No image found")
            return
        }
        
        guard let sizeImage = imageView.image?.size else { return }
        
        // Creating the object for rendering
        let renderer = UIGraphicsImageRenderer(size: sizeImage)
        
        // Making a render image to send
        let img = renderer.image { ctx in
            // Draw the image on the canvas
            ctx.cgContext.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: sizeImage.width, height: sizeImage.height))
            
            // Set up the attributedString to be on the top left corner of the image
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 55)
            ]
            
            let watermark = "From Storm Viewer"
            let attributedString = NSAttributedString(string: watermark, attributes: attrs)
            
            // Draw the watermark on the image
            attributedString.draw(with: CGRect(x: 10, y: 10, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
        }
        
        let vc = UIActivityViewController(activityItems: [img, selectedImage!], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
