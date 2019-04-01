//
//  ViewController.swift
//  Milestone Project 1-3
//
//  Created by Loris on 01/04/2019.
//  Copyright © 2019 Loris. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var countries = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "World Flags"
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        
        let contents = try! fm.contentsOfDirectory(atPath: path)
        
        for content in contents {
            if content.hasSuffix(".png") {
                countries.append(content)
            }
        }
        print(fm)
        print(path)
        print(contents)
        print(countries)
     }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Flag", for: indexPath)
        cell.textLabel?.text = countries[indexPath.row]
        return cell
    }
}

