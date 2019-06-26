//
//  ViewController.swift
//  MJ Notes
//
//  Created by maurice on 6/26/19.
//  Copyright © 2019 maurice. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	@IBOutlet weak var table: UITableView!
	var data:[String] = []
	var fileUrl:URL!
	var selectedRow:Int = -1
	var newRowText:String = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		table.dataSource = self
		table.delegate = self
		
		
		self.title = "MJ's Notes App"
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.navigationItem.largeTitleDisplayMode = .always

		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNote))
		
		self.navigationItem.rightBarButtonItem = addButton
		self.navigationItem.leftBarButtonItem = editButtonItem
		
		let baseURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
		
		fileUrl = baseURL.appendingPathComponent("mj_notes.txt")
		
		
		
		loadNotes()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if selectedRow == -1{
			return
		}
		data[selectedRow] = newRowText
		
		if newRowText == "" {
			data.remove(at: selectedRow)
		}
		table.reloadData()
		saveNotes()
	}
	

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
		cell.textLabel?.text = data[indexPath.row]
		
		return cell
	}
	
	// function to add a new note
	@objc func addNewNote(){
		if table.isEditing {
			return
		}
		let name:String = ""
		data.insert(name, at: 0)
		let indexPath:IndexPath = IndexPath(row: 0, section: 0)
		table.insertRows(at: [indexPath], with: .automatic)
		
		table.selectRow(at: indexPath, animated: true, scrollPosition: .none)
		self.performSegue(withIdentifier: "noteDetail", sender: nil)
	}
	
	override func setEditing(_ editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)
		table.setEditing(editing, animated: animated)
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		data.remove(at: indexPath.row)
		table.deleteRows(at: [indexPath], with: .fade)
		
		saveNotes()
	}
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		print("Selected row: \(data[indexPath.row])")
		
		self.performSegue(withIdentifier: "noteDetail", sender: nil)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let detailView:DetailViewController = segue.destination as! DetailViewController
		
		selectedRow = table.indexPathForSelectedRow!.row
		detailView.masterView = self
		
		detailView.setNoteText(t: data[selectedRow])
		
	}
	
	
	func saveNotes() {
//		UserDefaults.standard.set(data, forKey: "mj_notes")
		
		let a = NSArray(array: data)
		
		do {
			try a.write(to: fileUrl)
		} catch {
			print("Error occured while writing to mj_notes.txt")
		}
	}
	
	func loadNotes() {
		if let loadedData:[String] = NSArray(contentsOf: fileUrl) as? [String]{
			data = loadedData
			table.reloadData()
		}
		UserDefaults.standard.set(data, forKey: "mj_notes")
	}
	
	
}

