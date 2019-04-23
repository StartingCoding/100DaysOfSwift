//
//  ViewController.swift
//  Project1
//
//  Created by Loris on 25/03/2019.
//  Copyright © 2019 Loris. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(recommendedTapped))
        
        performSelector(inBackground: #selector(loadPics), with: nil)
    }
    
    @objc func loadPics() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                // This is a picture to load
                pictures.append(item)
            }
        }
        pictures.sort()
        collectionView.performSelector(onMainThread: #selector(UICollectionView.reloadData), with: nil, waitUntilDone: false)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? PicCell else {
            fatalError("Unable to dequeue PicCell")
        }
        cell.imageView.image = UIImage(named: pictures[indexPath.row])
        cell.name.text = pictures[indexPath.row]
        cell.imageView.layer.cornerRadius = 120
        cell.layer.cornerRadius = 5
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            vc.totalImages = pictures.count
            vc.imageIndex = indexPath.row + 1
        }
    }
    
    @objc func recommendedTapped() {
        let message = "This is a great app!\n\nhttps://github.com/StartingCoding/100DaysOfSwift/tree/master/Project%201"
        
        let vc = UIActivityViewController(activityItems: [message], applicationActivities: [])
        navigationController?.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}

