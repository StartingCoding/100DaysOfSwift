//
//  SelectionViewController.swift
//  Project30
//
//  Created by TwoStraws on 20/08/2016.
//  Copyright (c) 2016 TwoStraws. All rights reserved.
//

import UIKit

class SelectionViewController: UITableViewController {
	//var images = [String]() // this is the array that will store the filenames to load
    var thumbnails = [String]()
	var dirty = false

    override func viewDidLoad() {
        super.viewDidLoad()

		title = "Reactionist"

		tableView.rowHeight = 90
		tableView.separatorStyle = .none
        // Register a new class for tableViewCell so we can dequeue it later on.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

		// load all the JPEGs into our array
		let fm = FileManager.default

        
        if let tempItems = try? fm.contentsOfDirectory(atPath: Bundle.main.resourcePath!) {
            for item in tempItems {
                if item.contains("Thumb.jpg") {
                    thumbnails.append(item)
                }
            }
        }
        //self.images.sort()
        thumbnails.sort()
        
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if dirty {
			// we've been marked as needing a counter reload, so reload the whole table
			tableView.reloadData()
		}
	}

    // MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return thumbnails.count * 10
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

		// find the image for this cell, and load its thumbnail
		let currentImage = thumbnails[indexPath.row % thumbnails.count]
        
        guard let path = Bundle.main.path(forResource: currentImage, ofType: nil) else { fatalError("Couldn't load path") }
        guard let original = UIImage(contentsOfFile: path) else { fatalError("Couldn't load image from path: \(path)") }

        // Make a CGRect of the correct size of the table row height
        let rendererRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
		let renderer = UIGraphicsImageRenderer(size: rendererRect.size)

		let rounded = renderer.image { ctx in
            // Make an ellipse in order to clip the original image so it is a circle
            ctx.cgContext.addEllipse(in: rendererRect)
            ctx.cgContext.clip()

			original.draw(in: rendererRect)
		}

		cell.imageView?.image = rounded

        // give the images a nice shadow to make them look a bit more dramatic
        cell.imageView?.layer.shadowColor = UIColor.black.cgColor
        cell.imageView?.layer.shadowOpacity = 1
        cell.imageView?.layer.shadowRadius = 10
        cell.imageView?.layer.shadowOffset = CGSize.zero
        // Tell iOS that the shadow is a based on a fixed circle so it doesn't need to calculate every single pixel everytime.
        cell.imageView?.layer.shadowPath = UIBezierPath(ovalIn: rendererRect).cgPath

		// each image stores how often it's been tapped
		let defaults = UserDefaults.standard
		cell.textLabel?.text = "\(defaults.integer(forKey: currentImage))"

		return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = ImageViewController()
		vc.image = thumbnails[indexPath.row % thumbnails.count]
		vc.owner = self

		// mark us as not needing a counter reload when we return
		dirty = false

		navigationController?.pushViewController(vc, animated: true)
	}
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
