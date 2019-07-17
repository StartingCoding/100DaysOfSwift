//
//  ViewController.swift
//  Milestone Project 25-27
//
//  Created by Loris on 7/17/19.
//  Copyright © 2019 Loris. All rights reserved.
//

import UIKit

enum PositionText {
    case top, bottom
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var addImageBtn: UIButton!
    @IBOutlet var addImageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func addImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let img = info[.editedImage] as! UIImage? else { return }
        
        imageView.image = img
        
        addImageBtn.isHidden = true
        addImageLabel.isHidden = true
        
        dismiss(animated: true)
    }
    
    @IBAction func addTopText(_ sender: Any) {
        // If there is an image, let the user type the text
        if imageView.image != nil {
            let ac = UIAlertController(title: "Top Text", message: nil, preferredStyle: .alert)
            ac.addTextField()
            
            ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] action in
                // Check if th euser typed a text
                guard let text = ac.textFields?[0].text else { return }
                
                // Render the text on top of the image
                self?.render(text: text, on: .top)
            })
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            present(ac, animated: true)
        } else {
            // Display an alert to tell the user to select an image first
            let ac = UIAlertController(title: "Add an image first", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(ac, animated: true)
        }
    }
    
    // Render text on the image based on position
    func render(text: String, on: PositionText) {
        let renderer = UIGraphicsImageRenderer(size: imageView.image!.size)
        
        let img = renderer.image { ctx in
            imageView.image?.draw(at: CGPoint(x: 0, y: 0))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let shadowStyle = NSShadow()
            shadowStyle.shadowColor = UIColor.white
            shadowStyle.shadowOffset = CGSize(width: 5, height: 5)
            
            let attr: [NSAttributedString.Key: Any] = [
                //.backgroundColor: UIColor.white,
                .paragraphStyle : paragraphStyle,
                .font : UIFont(name: "Chalkduster", size: 88),
                .shadow : shadowStyle
            ]
            
            let attrText = NSAttributedString(string: text, attributes: attr)
            
            attrText.draw(with: CGRect(x: 0, y: 0, width: imageView.frame.width, height: imageView.frame.height), options: .usesLineFragmentOrigin, context: nil)
        }
        
        imageView.image = img
    }
    
}

