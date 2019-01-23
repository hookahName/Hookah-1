//
//  ChangeTeaTasteTableViewController.swift
//  Hokah
//
//  Created by Саша Руцман on 21.01.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase
class ChangeTeaTasteTableViewController: UITableViewController {

    // MARK: Properties
    
    var ref: DatabaseReference!
    var tastes = Array<TasteDB>()
    
    // MARK: View settings
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref = Database.database().reference().child("tea")
        ref.observe(.value, with: { [weak self] (snapshot) in
            var _tastes = Array<TasteDB>()
            for i in snapshot.children{
                let taste = TasteDB(snapshot: i as! DataSnapshot)
                _tastes.append(taste)
                print(taste)
                
            }
            self?.tastes = _tastes
            self?.tableView.reloadData()
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        title = "Change tea tastes"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ref.removeAllObservers()
    }
    
    // MARK: Table view settings
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tastes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeaTasteCell", for: indexPath)
        cell.textLabel?.text = tastes[indexPath.row].name
        
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(tastes[indexPath.row].isAvailable, animated: false)
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        cell.accessoryView = switchView
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let tea = tastes[indexPath.row]
            ref = Database.database().reference().child("tea").child(tea.name)
            ref.setValue(nil)
            self.tastes.remove(at: indexPath.row)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
    // MARK: Private functions
    
    @objc func switchChanged(_ sender: UISwitch!) {
        tastes[sender.tag].isAvailable = !tastes[sender.tag].isAvailable
        updateDatabase(tastes[sender.tag])
    }
    
    private func updateDatabase(_ taste: TasteDB) {
        ref = Database.database().reference()
        ref.child("tea").child(taste.name.lowercased()).updateChildValues(["name": taste.name, "isAvailable": taste.isAvailable])
    }
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        ref = Database.database().reference()
        let alertController = UIAlertController(title: "New taste", message: "Add new taste", preferredStyle: .alert)
        alertController.addTextField()
        let save = UIAlertAction(title: "Save", style: .default) { [ weak self] _ in
            
            guard let textField = alertController.textFields?.first, textField.text != "" else {return}
            let taste = TasteDB(name: textField.text!)
            let tasteRef = self?.ref.child("tea").child((taste?.name.lowercased())!)
            tasteRef?.setValue(taste!.convertToDictionary())
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        
        alertController.addAction(save)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
}
