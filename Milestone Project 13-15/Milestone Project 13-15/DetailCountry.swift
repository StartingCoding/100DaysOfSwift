//
//  DetailCountry.swift
//  Milestone Project 13-15
//
//  Created by Loris on 5/22/19.
//  Copyright © 2019 Loris. All rights reserved.
//

import UIKit

class DetailCountry: UITableViewController {
    var country: Country!
    
    var name = String()
    var capital = String()
    var region = String()
    var population = String()
    var demonym = String()
    var nativeName = String()
    
    var detailCountry = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        name = "Name: " + country.name
        capital = "Capital: " + country.capital
        region = "Region: " + country.region
        population = "Population: \(country.population)"
        demonym = "Demonym: " + country.demonym
        nativeName = "Native Name: " + country.nativeName
        
        detailCountry = [name, region, capital, population, demonym, nativeName]
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailCountry.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Detail", for: indexPath)
        cell.textLabel?.text = detailCountry[indexPath.row]
        return cell
    }
}
