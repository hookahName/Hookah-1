//
//  OrdersTableViewController.swift
//  Hokah
//
//  Created by Кирилл Иванов on 26/01/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase

class OrdersTableViewController: UITableViewController {
    
    // MARK: Properties
    var users: Array<UserDB>!
    var keyValues = Array<String>()
    
    var ref: DatabaseReference!
    
    // MARK: View settings
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref = Database.database().reference()
        var _keyValues = Array<String>()
        for user in users{
            ref.child("users").child(user.userId).observeSingleEvent(of: .value) { [weak self] (snapshot) in
                let value = snapshot.value as? NSDictionary
                let ordersID = value?["orders"] as? NSDictionary
                let enumerated = ordersID?.keyEnumerator()
                while let key = enumerated?.nextObject() {
                    let keyStr = key as! String
                    _keyValues.append(keyStr)
                }
                self?.keyValues = _keyValues
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ref.removeAllObservers()
    }
    
    // MARK: Table view settings
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyValues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Order", for: indexPath)
        cell.textLabel?.text = "Заказ: \(keyValues[indexPath.row])"
        cell.accessoryType = .disclosureIndicator
        /*
        if orders[indexPath.row].isDone == true {
            cell.backgroundColor = .gray
        }*/
        return cell
    }
    /*
    func loadDatabase() {
        ref = Database.database().reference()
        if let users = users {
            for user in users {
                ref.child("users").child(user.userId).observe(.value, with: {[weak self] (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let ordersID = value?["orders"] as? NSDictionary
                    let enumer = ordersID?.keyEnumerator()
                    var _keyValues = Array<String>()
                    while let key = enumer?.nextObject() {
                        let keyStr = key as! String
                        _keyValues.append(keyStr)
                    }
                    self?.keyValues += _keyValues
                    self?.tableView.reloadData()
                })
            }
        } else {
            print("Something wrong")
        }
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderDetails" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let dvc = segue.destination as? OrderDetailsViewController else {return}
                dvc.orderID = keyValues[indexPath.row]
                for user in users {
                     print()
                }
            }
        }
    }
    
    @IBAction func unwindToOrders(segue: UIStoryboardSegue) {
        if segue.identifier == "backToOrders" {
            guard segue.source is OrderDetailsViewController else {return}
        }
    }
}
