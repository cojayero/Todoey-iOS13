//
//  Data.swift
//  Todoey
//
//  Created by Baldomero Fernandez Manzano on 27/4/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Data:Object {
    @objc dynamic var name :String = ""
    @objc dynamic var age : Int = 0
    
}
