//
//  AdminTableViewController.swift
//  Hokah
//
//  Created by Кирилл Иванов on 20/01/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase

class AdminTableViewController: UITableViewController {

    // MARK: Properties
    
    var ref: DatabaseReference!
    var tobaccos: Array<TobaccoDB>!
    
    // MARK: View settings
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Available"
        tableView.tableFooterView = UIView()
    }
    
    // MARK: Table view settings
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tobaccos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminCell", for: indexPath)
        cell.textLabel?.text = tobaccos[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let tabaco = tobaccos[indexPath.row]
            ref = Database.database().reference().child("tobaccos").child(tabaco.name)
            ref.setValue(nil)
            self.tobaccos.remove(at: indexPath.row)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
        }
    }
   
    // MARK: Private functions
    
    @IBAction func add(_ sender: Any) {
        ref = Database.database().reference()
        let alertController = UIAlertController(title: "New tabacoo", message: "Add new tabacoo", preferredStyle: .alert)
        alertController.addTextField()
        let save = UIAlertAction(title: "Save", style: .default) { [ weak self] _ in
            
            guard let textField = alertController.textFields?.first, textField.text != "" else {return}
            let tabaco = TobaccoDB(name: textField.text!)
            let tabacoRef = self?.ref.child("tobaccos").child(tabaco!.name.lowercased())
            tabacoRef?.setValue(tabaco?.convertToDictionary())
            self?.tobaccos.append(tabaco!)
            self?.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        
        alertController.addAction(save)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddTastes" {
            guard let taste = segue.destination as? AddTastesTableViewController else {return}
            if let indexPath = tableView.indexPathForSelectedRow {
                taste.chosenTobacco = tobaccos[indexPath.row]
            }
        }
    }
}
