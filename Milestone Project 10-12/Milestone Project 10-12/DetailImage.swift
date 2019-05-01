//
//  DetailImage.swift
//  Milestone Project 10-12
//
//  Created by Loris on 4/29/19.
//  Copyright © 2019 Loris. All rights reserved.
//

import UIKit

class DetailImage: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titlePhoto: UILabel!
    
    var image: UIImage!
    var photoName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageToLoad = image {
            imageView.image = imageToLoad
        }
        
        if let name = photoName {
            titlePhoto.text = name
        }
    }
    
    @IBAction func renamePhoto(_ sender: Any) {
        let ac = UIAlertController(title: "Rename Your Photo", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
            guard let newName = ac.textFields![0].text else { return }
            self?.titlePhoto.text = newName
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
}
