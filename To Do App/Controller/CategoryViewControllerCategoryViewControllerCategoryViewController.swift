//
//  CategoryViewController.swift
//  To Do App
//
//  Created by Ovi Cornea on 01/04/2018.
//  Copyright © 2018 Ovi Cornea. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categoriesArray: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 70                //so the delete-icon can show properly
        
        loadCategories()
        
        tableView.separatorStyle = .none
       // view.backgroundColor = GradientColor(.topToBottom, frame: CGRect(x: 0, y: 100, width: 100, height: 100) , colors: [.black, .blue])

    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        let cell = super.tableView(tableView, cellForRowAt: indexPath)  //super takes it to the superclass
        
        cell.textLabel?.text = categoriesArray?[indexPath.row].name ?? "No Categories Added Yet"
        
        guard let categoryColor = UIColor(hexString: (categoriesArray?[indexPath.row].hexColor)!) else {fatalError()}
        
        cell.backgroundColor = categoryColor
        
        cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if categories is not nil, then return the count. Otherwise, return 1.
//        NIL coelecent operator
        return categoriesArray?.count ?? 1
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListVC
        
        //grab the category that corresponds to the selected cell
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categoriesArray?[indexPath.row]
            
        }
        
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        
        do {
            
            try realm.write {
                realm.add(category)
            }
            
        } catch {
            
            print("error saving categories: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        
        //read in Realm - R from CRUD
        
        categoriesArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        super.updateModel(at: indexPath)    //w/o this, the superclass print statement won't get called, as it will be overridden. 
        
        if let item = self.categoriesArray?[indexPath.row] {

        do {
            
            try self.realm.write {

                self.realm.delete(item)

            }

        } catch {

            print("error saving done status")
        }

        }
        
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var categoryToAdd = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = categoryToAdd.text!
            newCategory.hexColor = UIColor.randomFlat.hexValue()
            
            // there is no need to append, the Results container is auto-updating
            self.save(category: newCategory)
    
        }
        
        alert.addTextField { (alertTextField) in
            
            categoryToAdd.placeholder = "Add New Category"
            categoryToAdd = alertTextField
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
}
