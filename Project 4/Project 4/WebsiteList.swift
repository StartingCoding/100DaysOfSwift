//
//  WebsiteList.swift
//  Project 4
//
//  Created by Loris on 4/4/19.
//  Copyright © 2019 Loris. All rights reserved.
//

import UIKit

class WebsiteList: UITableViewController {
    var websites = ["apple.com", "hackingwithswift.com", "startingcoding.github.io/blog"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Easy Browser"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "website", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "webView") as? ViewController {
            vc.websites = websites
            vc.selectedWebsite = indexPath.row
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
