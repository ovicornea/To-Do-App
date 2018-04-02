//
//  AppDelegate.swift
//  To Do App
//
//  Created by Ovi Cornea on 30/03/2018.
//  Copyright © 2018 Ovi Cornea. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        //create the current state C from CRUD
        
        do {
             _ = try Realm()
            
        } catch {
            
            print("Error, cannot initialize realm, error: \(error)")
        }
        
        
        return true
    }


}

