//
//  ViewController.swift
//  Milestone Project 19-21
//
//  Created by Loris on 6/13/19.
//  Copyright © 2019 Loris. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var notes = ["Test-1", "Test-2", "Test-3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Apple Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Use an instance property of ViewController to create an edit/done button that change based on editing the cell
        navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Set up the toolbar with a new button on the right for creating a new note
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let newNote = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNewNote))
        toolbarItems = [spacer, newNote]
        navigationController?.isToolbarHidden = false
        
        // If the cell is empty (table view without content) make it a clear view
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "note", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row]
        return cell
    }
    
    // Editing cells
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // If the editing style of the cell is on delete mode, remove it from the array of notes and delete the row with fadeOut
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            navigationController?.pushViewController(vc, animated: true)
            vc.note = notes[indexPath.row]
        }
    }
    
    @objc func createNewNote() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

