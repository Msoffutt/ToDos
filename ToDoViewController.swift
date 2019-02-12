//
//  ViewController.swift
//  ToDos
//
//  Created by Monte Offutt on 2/9/19.
//  Copyright © 2019 Monte Offutt. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {
	
	var iteamArray = [Item]()
	let defaults = UserDefaults.standard
	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

	override func viewDidLoad() {
		super.viewDidLoad()
		

		loadItem()
		
	}
	override var prefersStatusBarHidden: Bool {
		return true
	}

	//MARK - Tableview Datasource Methods
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return iteamArray.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
		
		let item = iteamArray[indexPath.row]
		
		cell.textLabel?.text = item.title
		
		//Using Ternary Operatoer to shorten function instead of if/else statement.
		cell.accessoryType = item.done ? .checkmark : .none
		
		return cell
	}
	
	//MARK - TableView Delegate Methods
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		//print(iteamArray[indexPath.row])
		
		//One line of code to check with the user selected a row in the table view
		//or not. If try then reload the view with a checkmark other wise do nothing
		//Shorten the using if/else statment.
		iteamArray[indexPath.row].done = !iteamArray[indexPath.row].done
		
		saveItems()
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	//MARK - Add New Item
	
	@IBAction func AddItem(_ sender: UIBarButtonItem) {
		
		var alertText = UITextField()
		
		let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
			//When User selects added Item Button
			let newItem = Item()
			newItem.title = alertText.text!
			self.iteamArray.append(newItem)
			
			self.saveItems()
		}
		
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Add new item"
			alertText = alertTextField
		}
		
		alert.addAction(action)
		
		present(alert, animated: true, completion: nil)
		
	}
	
	//MARK - Model Manupulation Methods
	
	func saveItems(){
		
		let encoder = PropertyListEncoder()
		
		do{
			let data = try encoder.encode(iteamArray)
			try data.write(to: dataFilePath!)
		}catch {
			
			print("Error encoding item array, \(error)")
			
		}
		
		self.tableView.reloadData()
		
	}
	
	func loadItem(){
		
		if let data = try? Data(contentsOf: dataFilePath!){
			let decoder = PropertyListDecoder()
			do{
				iteamArray = try decoder.decode([Item].self, from: data)
			}catch{
				print("Error decoding item array, \(error)")
			}
		}
		
	}
	
}

