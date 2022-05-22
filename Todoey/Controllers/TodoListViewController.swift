//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class TodoListViewController: SwipeTableViewController{
    let realm = try! Realm()
    var retorno = ""
    var  itemArray = [Item]()
    var todoItems : Results<Item2>?
    var selectedCategory : Category2? {
        didSet {
            debugPrint(#function)
            loadItems()
        }
    }
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory,
                                                in: .userDomainMask)
        .first?
        .appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer
        .viewContext
    /// Salva el estado de la lista
    ///
    func saveItems() {
        //
        do  {
            try   context.save()
        } catch {
            print("Error saving cod \(error)")
        }
        self.tableView.reloadData()
    }
    
    func save(item:Item2){
        do {
            try realm.write({
                realm.add(item)
                debugPrint("Saved item \(item)")
            })
        } catch  {
            print("Error saving item \(error)")
        }
        tableView.reloadData()
    }
    ///
    ///
    /*
     func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(),
     predicate : NSPredicate? = nil){
     let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
     if let additionalPredicate = predicate {
     request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate,
     categoryPredicate])
     } else {
     request.predicate = categoryPredicate
     }
     
     debugPrint(request)
     do {
     itemArray = try context.fetch(request)
     } catch {
     print("Error fetching data from context \(error)")
     }
     tableView.reloadData()
     }
     */
    func loadItems(){
        debugPrint(#function)
        todoItems = selectedCategory?
            .items
            .sorted(byKeyPath: "title",
                    ascending: true)
        tableView.reloadData()
    }
    /*
     override func loadView() {
     debugPrint(#function)
     itemsArray = selectedCategory?.items.sorted(byKeyPath: "title",
     ascending: true)
     tableView.reloadData()
     }
     */
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a new TODO item",
                                      message: "",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item",
                                   style: .default) { (action) in
            // what wil happen onc the user click alerts
            if(!(textField.text?.isEmpty ?? false) ){
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write({
                            let newItem = Item2()
                            newItem.title = textField.text ?? ""
                            newItem.done = false
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        })
                    } catch {
                        print("Errror saving new item")
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                // newItem.parentCategory = self.selectedCategory
                // self.itemArray.append(newItem)
                //self.save(item: newItem)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder  = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        debugPrint( FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask))
        tableView.rowHeight = 80.0
        //  loadItems()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell",for: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
            debugPrint(item)
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //debugPrint(indexPath.row)
        let isDone = todoItems?[indexPath.row].done
        //itemsArray?[indexPath.row].done = !(isDone ?? false)
        //saveItems()
        if let item = todoItems?[indexPath.row]{
            do {
                try realm.write({
                    item.done = !item.done
                })
            } catch  {
                print("Error saving donestatus \(error)")
            }
        }
        tableView.reloadData()
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let todo2delete = todoItems?[indexPath.row]{
            do {
                try self.realm.write({
                    self.realm.delete(todo2delete)
                })
            } catch  {
                print("Error borrando el todo " + error.localizedDescription)
            }
        }
    }
    
}
//MARK: - Search bar methods
extension TodoListViewController:UISearchBarDelegate {
    fileprivate func performSearchWithCoreData(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@",searchBar.text!)
        let sortDescriptor = NSSortDescriptor(key:"title",ascending: true)
        request.sortDescriptors = [sortDescriptor]
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        debugPrint(#function)
        debugPrint("\(searchBar.text)")
        //performSearchWithCoreData(searchBar)
        //  loadItems(with: request, predicate:  predicate)
        todoItems = todoItems?
            .filter("title CONTAINS[cd] %@",searchBar.text!)
            .sorted(byKeyPath: "title",
                    ascending: true)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
