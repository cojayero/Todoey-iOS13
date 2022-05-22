//
//  Item.swift
//  Todoey
//
//  Created by Baldomero Fernandez Manzano on 27/4/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item2:Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category2.self,
                                        property: "items")
}
