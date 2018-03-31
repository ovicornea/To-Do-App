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
    
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadItems()
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as UITableViewCell
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //ternary operator. set value of cell.accesoryType based on a condition (item.done = true).
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //if the checkmark property is associated with the cell itself, then when the cell gets reused, the property will "stick".
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var itemToAdd = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //what will happen once the user clicks the Add Item button
            
            let newItem = Item()
            
            newItem.title = itemToAdd.text!
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            //at this point the app WILL crash because we have reached the limits of UserDefaults. We're trying to save to persistence an array of "Item" objects which is not accepted by UserDefaults. Error is "Attempt to insert non-property list object". UserDefaults only takes standard datatypes, not custom ones like the one created here.
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Add New Item"
            itemToAdd = alertTextField
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do {
            
            let data = try encoder.encode(itemArray)
            
            try data.write(to:dataFilePath!)
            
        } catch {
            
            print("error encoding itemArray: \(error)")
            
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
            
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("error decoding items")
            }
        }
    }
    
}
