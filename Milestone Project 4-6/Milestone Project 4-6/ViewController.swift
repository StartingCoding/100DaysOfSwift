//
//  ViewController.swift
//  Milestone Project 4-6
//
//  Created by Loris on 4/11/19.
//  Copyright © 2019 Loris. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var productList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addProduct))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startNewList))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let shareFeature = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareList))
        
        toolbarItems = [spacer, shareFeature, spacer]
        navigationController?.isToolbarHidden = false
        
        title = "Shopping List"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Product", for: indexPath)
        cell.textLabel?.text = productList[indexPath.row]
        return cell
    }

    @objc func addProduct() {
        let ac = UIAlertController(title: "Add a Product!", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Ok", style: .default) {
            [weak self, weak ac] _ in
            guard let text = ac?.textFields?[0].text else { return }
            self?.addProductToList(item: text)
        })
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func addProductToList(item : String) {
        productList.insert(item, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @objc func startNewList() {
        productList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc func shareList() {
        let ac = UIActivityViewController(activityItems: [productList.joined(separator: "\n")], applicationActivities: [])
        ac.popoverPresentationController?.barButtonItem = navigationController?.toolbarItems?[1]
        present(ac, animated: true)
    }
}

