//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Baldomero Fernandez Manzano on 27/4/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer
        .viewContext
    
    let realm = try! Realm()
    var categories2 : Results<Category2>? // [Category2]()
    //MARK: - IBAction
    //MARK: - Add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category",
                                      message: "",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Add",
                                   style: .default) { (action) in
            /*
             // el código para CoreData
            let newCategory = Category(context: self.context)
             */
            let newCategory = Category2()
            newCategory.name = textField.text!  // Se añade automágicamnte al realm categories2
            // self.categories.append(newCategory)
            debugPrint(self.categories)
            //self.saveCategories() -> El metodo para CoreData
            self.save(category: newCategory)
        }
        alert.addAction(action)
        alert.addTextField { (field) in
             textField = field
            textField.placeholder = "Add a new category"
        }
        present(alert,animated: true,completion: nil)
    }
    //MARK: - Code
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK: - Data manipulation methods
    ///  Esta funcion salva las catgegorias para CoreData
    func saveCategories(){
        do {
            
            try context.save()
            print("saved category")
        } catch {
            print("Error saving category \(error)")
           
        }
        tableView.reloadData()
        
    }
    
    /// Salva una categoria en el realm store
    /// - Parameter category: categoria
    func save(category:Category2){
        do {
            try realm.write({
                realm.add(category)
                debugPrint("Saved category \(category)")
            })
        } catch  {
            print("Error saving catgory \(error)")
        }
        tableView.reloadData()
    }
   /*
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
        
    }
    */
    func loadCategories(){
        categories2 = realm.objects(Category2.self)
        tableView.reloadData()
    }
    


    //MARK: - Table View Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories2?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories2?[indexPath.row].name ?? "No categoris aded yet"
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint(#function)
        let destinationVC = segue.destination as! TodoListViewController
        if  let indexPath = tableView.indexPathForSelectedRow {
            debugPrint("IndexPath \(indexPath)")
            debugPrint("selected Catgory \(categories2?[indexPath.row])")
            destinationVC.selectedCategory = categories2?[indexPath.row]
        }
    }
    //MARK: - Data Manipultion Methods
    

}
