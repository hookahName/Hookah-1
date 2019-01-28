//
//  AddTastesTableViewController.swift
//  Hokah
//
//  Created by Саша Руцман on 20.01.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase

class AddTastesTableViewController: UITableViewController {
    
    // MARK: Properies
    
    var chosenTobacco: TobaccoDB?
    var ref: DatabaseReference!
    var tastes = Array<TasteDB>()
    
    // MARK: View settings
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let chosenTobacco = chosenTobacco {
            title = chosenTobacco.name
        }
        tableView.tableFooterView = UIView()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let chosenTobacco = chosenTobacco else {return}
        ref = Database.database().reference().child("tobaccos").child((chosenTobacco.name.lowercased())).child("tastes")
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        getAvailabilityOfTobacco()
        ref.removeAllObservers()
    }
    
    // MARK: - Table view data source
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasteCell", for: indexPath)
        cell.textLabel?.text = tastes[indexPath.row].name
        
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(tastes[indexPath.row].isAvailable, animated: false)
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        cell.accessoryView = switchView
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tastes.count
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taste = tastes[indexPath.row]
            ref = Database.database().reference().child("tobaccos").child((chosenTobacco?.name)!).child("tastes").child(taste.name)
            ref.setValue(nil)
            self.tastes.remove(at: indexPath.row)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
    // MARK: Private functions
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        ref = Database.database().reference()
        let alertController = UIAlertController(title: "New taste", message: "Add new taste", preferredStyle: .alert)
        alertController.addTextField() { (textField) in
            textField.placeholder = "Вкус"
            textField.borderStyle = UITextField.BorderStyle.roundedRect
            
        }
        let save = UIAlertAction(title: "Save", style: .default) { [ weak self ] _ in
            
            guard let textField = alertController.textFields?.first, textField.text != "" else {return}
            let taste = TasteDB(name: textField.text!)
            let tasteRef = self?.ref.child("tobaccos").child(((self?.chosenTobacco!.name.lowercased())!)).child("tastes").child((taste?.name.lowercased())!)
            tasteRef?.setValue(taste!.convertToDictionary())
            //self?.tobaccos.append(tabaco!)
            //self?.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        
        alertController.addAction(save)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
    private func getAvailabilityOfTobacco() {
        ref = Database.database().reference()
        var isAvailable: Bool = false
        guard let chosenTobacco = chosenTobacco else { return }
        if tastes.count > 0 {
            for taste in tastes {
                if taste.isAvailable {
                    isAvailable = true
                    break
                }
            }
            chosenTobacco.isAvailable = isAvailable
            ref.child("tobaccos").child(chosenTobacco.name.lowercased()).updateChildValues(["name":chosenTobacco.name, "isAvailable": chosenTobacco.isAvailable, "price": chosenTobacco.price])
        } else {
            chosenTobacco.isAvailable = isAvailable
            ref.child("tobaccos").child(chosenTobacco.name).updateChildValues(["name":chosenTobacco.name, "isAvailable": chosenTobacco.isAvailable, "price": chosenTobacco.price])
        }
    }
    
    @objc func switchChanged(_ sender: UISwitch!) {
        tastes[sender.tag].isAvailable = !tastes[sender.tag].isAvailable
        updateDatabase(tastes[sender.tag])
        getAvailabilityOfTobacco()
    }
    
    private func updateDatabase(_ taste: TasteDB) {
        ref = Database.database().reference()
        ref.child("tobaccos").child(chosenTobacco!.name.lowercased()).child("tastes").child(taste.name.lowercased()).updateChildValues(["name": taste.name, "isAvailable": taste.isAvailable])
    }
}
