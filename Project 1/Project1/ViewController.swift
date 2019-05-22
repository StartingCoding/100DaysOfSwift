//
//  ViewController.swift
//  Project1
//
//  Created by Loris on 25/03/2019.
//  Copyright © 2019 Loris. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    var views = [Int]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(recommendedTapped))
        
        performSelector(inBackground: #selector(loadPics), with: nil)
        
        views = defaults.object(forKey: "views") as? [Int] ?? Array(repeating: 0, count: pictures.count)
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
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        cell.detailTextLabel?.text = "Views: \(views[indexPath.row])"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        views[indexPath.row] += 1
        save()
        tableView.reloadData()
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
    
    func save() {
        defaults.set(views, forKey: "views")
    }
}

