//
//  ViewController.swift
//  Hokah
//
//  Created by Кирилл Иванов on 06/01/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase
class ViewController: UITableViewController {
    var ref: DatabaseReference!
    let tables = ["Table 1", "Table 2", "Table 3"]
    var tobaccos = Array<TobaccoDB>()
    var password = Array<passDB>()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref = Database.database().reference().child("tobaccos")
        ref.observe(.value, with: { [weak self] (snapshot) in
            var _tobaccos = Array<TobaccoDB>()
            for i in snapshot.children{
                let tobacco = TobaccoDB(snapshot: i as! DataSnapshot)
                _tobaccos.append(tobacco)
                
            }
            self?.tobaccos = _tobaccos
            self?.tableView.reloadData()
        })
        
        ref = Database.database().reference().child("password")
        ref.observe(.value, with: { [weak self] (snapshot) in
            var _password = Array<passDB>()
            for i in snapshot.children{
                let password = passDB(snapshot: i as! DataSnapshot)
                _password.append(password)
                print(password.password)
            }
            self?.password = _password
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Choose table"
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ref.removeAllObservers()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tables.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Table", for: indexPath)
        
        cell.textLabel?.text = tables[indexPath.row]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Admin" {
            
            guard let admin = segue.destination as? AdminViewController else {return}
            admin.tobaccos = self.tobaccos
        } else if segue.identifier == "ToTabaco" {
            guard let tobaco = segue.destination as? SeconViewController else {return}
            tobaco.tobaccos = tobaccos
            if let indexPath = tableView.indexPathForSelectedRow {
                tobaco.selectedTable = indexPath.row
            }
        }
    }
    
    @IBAction func EditButtonPressed(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Password", message: "Enter password", preferredStyle: .alert)
        alertController.addTextField()
        let ok = UIAlertAction(title: "Ok", style: .default) {
            action in
            let text = alertController.textFields?.first?.text
            if text == self.password[0].password {
                self.performSegue(withIdentifier: "Admin", sender: self)
            }
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        alertController.addAction(ok)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
}

