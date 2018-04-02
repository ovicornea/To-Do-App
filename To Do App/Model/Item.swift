//
//  Item.swift
//  To Do App
//
//  Created by Ovi Cornea on 02/04/2018.
//  Copyright © 2018 Ovi Cornea. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title = ""
    @objc dynamic var done = false
    @objc dynamic var dateCreated: Date?
    
    //inverse relationship that links each item back to its parent category.
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    
}
