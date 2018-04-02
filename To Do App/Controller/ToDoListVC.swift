//
//  ViewController.swift
//  To Do App
//
//  Created by Ovi Cornea on 30/03/2018.
//  Copyright © 2018 Ovi Cornea. All rights reserved.
//

import UIKit
import RealmSwift

//by simply inheriting the UITableViewController and adding a TableViewController to the storyboard (after we started as a regular UIViewController app), Xcode adds all the IBOutles, delegate and datasource automatically.

class ToDoListVC: UITableViewController {
    
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        
        didSet {
            
            loadItems()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as UITableViewCell
        
        if let item = toDoItems?[indexPath.row] {
        
        cell.textLabel?.text = item.title
        
        //ternary operator. set value of cell.accesoryType based on a condition (item.done = true).
        cell.accessoryType = item.done ? .checkmark : .none
       
        } else {
            
            cell.textLabel?.text = "no items added"
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        update in Realm U from CRUD and delete D from CRUD
        if let item = toDoItems?[indexPath.row] {
            
            do{
                try realm.write {
                    
                   // realm.delete(item) - delete when select row
                    
                  item.done = !item.done
            }
                
            }catch {
                
                print("error saving done status")
            }
            
        }
        
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoItems?.count ?? 1
        
    }
    
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
        if editingStyle == .delete {
            
            if let item = toDoItems?[indexPath.row] {
                
                do{
                    try realm.write {
                        
                        realm.delete(item)
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    
                    }
                    
                } catch {
                    
                    print("error saving done status")
                }

            
    
        }
    }
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var itemToAdd = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = itemToAdd.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                
            }
                } catch {
                    
                    print("Error saving new items")
                    
                }
            }
                
                self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Add New Item"
            itemToAdd = alertTextField
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func loadItems() {
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
   
}


//MARK: - Searchbar Methods

extension ToDoListVC: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()

    }

//    this method gets trigger ONLY after the text changes.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {

            loadItems()

//      user interface elements should be updated in the main thread.

            DispatchQueue.main.async {

                searchBar.resignFirstResponder()
            }

        }

    }

}

