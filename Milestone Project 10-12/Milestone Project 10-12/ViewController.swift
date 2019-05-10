//
//  ViewController.swift
//  Milestone Project 10-12
//
//  Created by Loris on 4/29/19.
//  Copyright © 2019 Loris. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var pictures = [Picture]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Photos"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(takePic))
        
        let defaults = UserDefaults.standard
        
        if let savedPic = defaults.object(forKey: "pictures") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                pictures = try jsonDecoder.decode([Picture].self, from: savedPic)
            } catch {
                print("Failed to save Pics.")
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Caption", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row].caption
        cell.imageView?.image = UIImage(contentsOfFile: pictures[indexPath.row].imageName)
        return cell
    }
    
    @objc func takePic() {
        let picker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        picker.allowsEditing = true
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        dismiss(animated: true) {
            let ac = UIAlertController(title: "Caption", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak ac] _ in
                guard let caption = ac?.textFields?[0].text else { return }
                
                let picture = Picture(imageName: imagePath.path, caption: caption)
                self?.pictures.append(picture)
                self?.savePic()
                self?.tableView.reloadData()
            }))
            self.present(ac, animated: true)
        }
    }
    
    func savePic() {
        let jsonEncoder = JSONEncoder()
        
        if let savedPic = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedPic, forKey: "pictures")
        } else {
            print("Failed to save Pics.")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailImage") as? DetailImage {
            
            vc.image = UIImage(contentsOfFile: pictures[indexPath.row].imageName)
            vc.photoName = pictures[indexPath.row].caption
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

