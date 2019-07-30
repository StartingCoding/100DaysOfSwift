//
//  ViewController.swift
//  Project10
//
//  Created by Loris on 4/21/19.
//  Copyright © 2019 Loris. All rights reserved.
//

// LocationAuthentication is the framework you can use for FaceID or TouchID
import LocalAuthentication
import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Authenticate", style: .plain, target: self, action: #selector(authenticate))
        
        // Set up notification when the app goes to background or the user go to the multitasking (aka the app is not in the foreground anymore)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(lockScreen), name: UIApplication.willResignActiveNotification, object: nil)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell")
        }
        
        let person = people[indexPath.item]
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }

    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
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
        
        let person = Person(name: "Unkown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        func renameAlert(action: UIAlertAction) {
            let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
            ac.addTextField()
            
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
                guard let newName = ac?.textFields?[0].text else { return }
                person.name = newName
                
                self?.collectionView.reloadData()
            })
            
            present(ac, animated: true)
        }
        
        let acd = UIAlertController(title: "Do you want to delete this item or rename it?", message: nil, preferredStyle: .alert)
        acd.addAction(UIAlertAction(title: "DELETE", style: .destructive) { [weak self] _ in
            self?.people.remove(at: indexPath.row)
            self?.collectionView.reloadData()
        })
        acd.addAction(UIAlertAction(title: "Rename", style: .default, handler: renameAlert))
        acd.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(acd, animated: true)
    }
    
    @objc func authenticate() {
        // Create the (Objective-C) object in order to work with authentication
        let context = LAContext()
        // Create a (Objective-C) error
        var error: NSError?
        
        // If the user can use a valid biometric authentication
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify Yourself!"
            
            // Let the user use biometric authentification mechanism (FaceID or TouchID)
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] (success, authenticationError) in
                
                // Make changes in the UI always on the main thread
                DispatchQueue.main.async {
                    if success {
                        self?.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self?.addNewPerson))
                        self?.collectionView.isHidden = false
                    } else {
                        let ac = UIAlertController(title: "Authentication Error!", message: "You could not be verified; please try again.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            // Let the user know that FaceID or TouchID is not enabled.
            let ac = UIAlertController(title: "Authentication Error!", message: "You don't have FaceID or TouchID enabled.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(ac, animated: true)
        }
    }
    
    @objc func lockScreen() {
        navigationItem.leftBarButtonItem = .none
        collectionView.isHidden = true
    }
    
}

