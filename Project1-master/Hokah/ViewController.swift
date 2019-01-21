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
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Choose table"
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
            guard let admin = segue.destination as? AdminTableViewController else {return}
            admin.tobaccos = tobaccos
        } else if segue.identifier == "ToTabaco" {
            guard let tobaco = segue.destination as? SeconViewController else {return}
            tobaco.tobaccos = tobaccos
            if let indexPath = tableView.indexPathForSelectedRow {
                tobaco.selectedTable = indexPath.row
            }

            
        }
    }
    
    @IBAction func unwindToMainScreen(segue: UIStoryboardSegue) {
        if segue.identifier == "unwindSegue" {
            guard let controller = segue.source as? AdminTableViewController else {return}
            self.tobaccos = controller.tobaccos
        }
    }
}

