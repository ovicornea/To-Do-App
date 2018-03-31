//
//  ViewController.swift
//  To Do App
//
//  Created by Ovi Cornea on 30/03/2018.
//  Copyright © 2018 Ovi Cornea. All rights reserved.
//

import UIKit

//by simply inheriting the UITableViewController and adding a TableViewController to the storyboard (after we started as a regular UIViewController app), Xcode adds all the IBOutles, delegate and datasource automatically.

class ToDoListVC: UITableViewController {
    
    let itemArray = ["Ovi", "Lita", "Jessica", "Aimee", "Ethan"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
        } else {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }

}
