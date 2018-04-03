//
//  Category.swift
//  To Do App
//
//  Created by Ovi Cornea on 02/04/2018.
//  Copyright © 2018 Ovi Cornea. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var hexColor = ""
    
    //forward relationship as in CoreData. It specifies that each category can have a number of items.
    
    let items = List<Item>()
    
    
}
