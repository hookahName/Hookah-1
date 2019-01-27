//
//  ViewController.swift
//  Hokah
//
//  Created by Кирилл Иванов on 06/01/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController, UINavigationBarDelegate {
    
    // MARK: Properties
    
    var ref: DatabaseReference!
    let tables = ["Table 1", "Table 2", "Table 3"]
    var tobaccos = Array<TobaccoDB>()
    //var tobaccos = Array<TobaccoDB>()
    
    // MARK: View settings
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref = Database.database().reference().child("tobaccos")
        ref.observe(.value, with: {[weak self] (snapshot) in
            var _tobaccos = Array<TobaccoDB>()
            for item in snapshot.children {
                let tobacco = TobaccoDB(snapshot: item as! DataSnapshot)
                _tobaccos.append(tobacco)
            }
            self?.tobaccos = _tobaccos
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
    
    // MARK: Table view settings
    
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
    
    // MARK: Private functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Admin" {
            
            guard segue.destination is AdminViewController else {return}
            //admin.tobaccos = self.tobaccos
        } else if segue.identifier == "tobacco" {
            guard let tobaco = segue.destination as? TobaccoCollectionViewController else {return}
            //tobaco.tobaccos = tobaccos
            //print(tobaco.tobaccos)
            tobaco.tobaccos = tobaccos
            if let indexPath = tableView.indexPathForSelectedRow {
                tobaco.selectedTable = indexPath.row + 1
            }
        }
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "Admin", sender: self)
    }
}

