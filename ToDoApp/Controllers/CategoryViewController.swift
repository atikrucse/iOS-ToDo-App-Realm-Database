//
//  CategoryViewController.swift
//  ToDoApp
//
//  Created by Mynul Atik on 10/5/22.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadData()

    }
    
    //MARK: - Table view datasource method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    //MARK: - TableView delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - add new category save and retrive/load

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { action in
            
            let newCategory = Category(context: self.contex)
            newCategory.name = textField.text
            
            self.categories.append(newCategory)
            
            self.saveItems()
            
        }
        
        //Show the alert dialog
        present(alert, animated: true, completion: nil)
        
        //add textfield to a alert dialog
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Add new Category"
            textField = alertTextField
        }
        alert.addAction(action)
    }
    
    
    //Function for Encode data ans save it to custom dataFilePath
    func saveItems() {
        
        do {
            try contex.save()
        } catch {
            print("Error saving context \(error)")
        }
       tableView.reloadData()
    }
    
    //Function for Loading data from dataFilePath
    func loadData() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
            do {
                categories = try contex.fetch(request)
            } catch {
                print("Error in retriving data \(error)")
            }
        tableView.reloadData()
    }
    
}

//MARK: - Search bar on Categories

extension CategoryViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            categories = try contex.fetch(request)
        } catch {
            print("Error in search category \(error)")
        }
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
