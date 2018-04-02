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
    
    //forward relationship as in CoreData
    
    let items = List<Item>()
    
    
}
