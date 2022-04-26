//
//  ViewController.swift
//  ToDoApp
//
//  Created by Mynul Atik on 25/4/22.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = ["Milk", "Bread", "Apple"]
    var textField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //MARK: - Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        
        
        let alert = UIAlertController(title: "Add new ToDo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            //what happens when user click on "Add Item"

            self.itemArray.append(self.textField.text!)
            
            self.tableView.reloadData()
        }
        //Show the alert dialog
        present(alert, animated: true, completion: nil)
        
        //add action to a alert dialog
        alert.addAction(action)
        
        //add textfield to a alert dialog
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Add new Task"
            self.textField = alertTextField
            
        }
    }
    
    //MARK: - Tableview datasource method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    
    //MARK: - UITableViewDelegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }

}

