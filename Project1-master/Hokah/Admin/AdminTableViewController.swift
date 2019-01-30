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
    var tastes = Array<TasteDB>()
    var tobaccoPhotos: [String: UIImage]?
    var tastePhotos: [String: UIImage] = [:]
    
    // MARK: View settings
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Available"
        tableView.tableFooterView = UIView()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
        loadTobaccos()
        self.refreshControl?.endRefreshing()
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
    /*
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
   */
    // MARK: Private functions
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .default, title: "Изменить") { (action, indexPath) in
            self.performSegue(withIdentifier: "toDetails", sender: indexPath)
        }
        
        let delete = UITableViewRowAction(style: .default, title: "Удалить") { (action, indexPath) in
            let tobacco = self.tobaccos[indexPath.row]
            self.ref = Database.database().reference().child("tobaccos").child(tobacco.name.lowercased())
            self.ref.setValue(nil)
            self.tobaccos.remove(at: indexPath.row)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.endUpdates()
            
            let deleteImageName = tobacco.imageName
            let deleteRef = Storage.storage().reference().child("tobaccosImage").child("\(deleteImageName).png")
            deleteRef.delete { (error) in
                if let error = error {
                    print("Error")
                } else {
                    print("deleted succesfully")
                }
            }
        }
        
        edit.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        delete.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return [delete, edit]
    }
    
    
    
    @IBAction func add(_ sender: Any) {
        /*
        ref = Database.database().reference()
        let alertController = UIAlertController(title: "New tabacoo", message: "Add new tabacoo", preferredStyle: .alert)
        alertController.addTextField() { (textField) in
            textField.placeholder = "Название"
            textField.borderStyle = UITextField.BorderStyle.roundedRect
        }
        alertController.addTextField() { (textFieldPrice) in
            textFieldPrice.placeholder = "Цена"
            textFieldPrice.borderStyle = UITextField.BorderStyle.roundedRect
        }
        let save = UIAlertAction(title: "Save", style: .default) { [ weak self] _ in
            
            guard let textField = alertController.textFields?[0], textField.text != "" else {return}
            guard let textFieldPrice = alertController.textFields?[1], textFieldPrice.text != "" else {return}
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
        
        for textField in alertController
            .textFields! {
            let container = textField.superview
            let effectView = container?.superview?.subviews[0]
            if (effectView != nil) {
                container?.backgroundColor = UIColor.clear
                effectView?.removeFromSuperview()
            }
        }
 */
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
            guard let detail = segue.destination as? DetailTobaccoInfo else {return}
            if let indexPath = sender as? IndexPath {
                detail.tobacco = tobaccos[indexPath.row]
                print("имя табака: \(tobaccos[indexPath.row].name)")
                detail.tobaccoImage = tobaccoPhotos![tobaccos[indexPath.row].name]
            }
        } else if segue.identifier == "AddTastes" {
            guard let taste = segue.destination as? AddTastesTableViewController else {return}
            taste.tastePhotos = tastePhotos
            if let indexPath = tableView.indexPathForSelectedRow {
                taste.chosenTobacco = tobaccos[indexPath.row]
                
                
            }
        } else if segue.identifier == "addTobacco" {
            guard segue.destination is DetailTobaccoInfo else {return}
        }
    }
    
    private func loadTobaccos() {
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
    
    @IBAction func unwindSegueToAdmin(_ sender: UIStoryboardSegue) {
        
    }
}
