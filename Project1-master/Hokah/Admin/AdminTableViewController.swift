//
//  AdminTableViewController.swift
//  Hokah
//
//  Created by Кирилл Иванов on 20/01/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase

class AdminTableViewController: UITableViewController, UINavigationControllerDelegate {

    // MARK: Properties
    
    var ref: DatabaseReference!
    var tobaccos = Array<TobaccoDB>()
    
    // MARK: View settings
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref = Database.database().reference().child("tobaccos")
        ref.observe(.value, with: { [weak self] (snapshot) in
            var _tobaccos = Array<TobaccoDB>()
            for item in snapshot.children {
                let tobacco = TobaccoDB(snapshot: item as! DataSnapshot)
                _tobaccos.append(tobacco)
            }
            
            self?.tobaccos = _tobaccos
            self?.tableView.reloadData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Available"
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ref.removeAllObservers()
    }
    
    // MARK: Table view settings
    
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
        alertController.addTextField()
        let save = UIAlertAction(title: "Save", style: .default) { [ weak self] _ in
            
            guard let textField = alertController.textFields?[0], textField.text != "" else {return}
            textField.placeholder = "Название"
            guard let textFieldPrice = alertController.textFields?[1], textFieldPrice.text != "" else {return}
            textFieldPrice.placeholder = "Цена"
            let tabaco = TobaccoDB(name: textField.text!, price: textFieldPrice.text!)
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
