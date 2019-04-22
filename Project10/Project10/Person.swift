//
//  Person.swift
//  Project10
//
//  Created by Loris on 4/22/19.
//  Copyright © 2019 Loris. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
