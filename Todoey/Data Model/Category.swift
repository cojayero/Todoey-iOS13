//
//  Category.swift
//  Todoey
//
//  Created by Baldomero Fernandez Manzano on 27/4/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category2: Object {
    @objc dynamic var name: String = ""
    let items = List<Item2>()
}
