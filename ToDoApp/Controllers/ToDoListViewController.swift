//
//  ViewController.swift
//  ToDoApp
//
//  Created by Mynul Atik on 25/4/22.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //Retriving data from dataFilePath
        loadData()
        
    }

    //MARK: - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new ToDo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            //what happens when user click on "Add Item"
            
            let newItem = Item(context: self.contex)
            newItem.title = textField.text!
            newItem.done = false
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        //Show the alert dialog
        present(alert, animated: true, completion: nil)
        
        //add textfield to a alert dialog
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Add new Task"
            textField = alertTextField
        }
        
        //add action to a alert dialog
        alert.addAction(action)
        
        
    }
    
    //MARK: - Tableview datasource method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    
    //MARK: - UITableViewDelegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Deleting Items
        contex.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        
        
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Model manipulation method
    
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
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()

            do {
                itemArray = try contex.fetch(request)
            } catch {
                print("Error in retriving data \(error)")
            }
    }
}

