//
//  CurUserOrdersTableViewController.swift
//  Hokah
//
//  Created by Саша Руцман on 27.01.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase
class CurUserOrdersTableViewController: UITableViewController {

    var users = Array<UserDB>()
    var orders = Array<OrderDB>()
    var ordersID = NSDictionary()
    var keyValues = [String]()
    var currentUser = Auth.auth().currentUser?.uid
    var ref: DatabaseReference!
    
    // MARK: View settings
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadDatabase()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Ваши заказы"
        self.tableView.tableFooterView = UIView()
        self.refreshControl = UIRefreshControl()
        //self.refreshControl?.attributedTitle = NSAttributedString(string: "Updating...")
        self.refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        //self.tableView.addSubview(refreshControl)
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
        return keyValues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserOrder", for: indexPath)
        
        cell.textLabel?.text = "Заказ: \(keyValues[indexPath.row])"
        cell.accessoryType = .disclosureIndicator/*
        if orders[indexPath.row].isDone == true {
            cell.backgroundColor = .gray
        }*/
        return cell
    }
    
    func loadDatabase() {
        ref = Database.database().reference().child("users").child(currentUser!)
        ref.observeSingleEvent(of: .value) { [weak self] (snapshot) in
            let value = snapshot.value as? NSDictionary
            let _ordersID = value?["orders"] as? NSDictionary
            
            self?.ordersID = _ordersID!
            let enumer = _ordersID?.keyEnumerator()
            var _keyVal = Array<String>()
            while let key = enumer?.nextObject() {
                let keyStr = key as! String
                print(keyStr)
                _keyVal.append(keyStr)
            }
            self?.keyValues = _keyVal
            self?.tableView.reloadData()
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        loadDatabase()
        self.refreshControl?.endRefreshing()
    }
    
    func loadOrders(orderID: String) {
        ref = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("orders").child(orderID)
        ref.observe(.value) { [weak self] (snapshot) in
            var _orders = Array<OrderDB>()
            for item in snapshot.children {
                let order = OrderDB(snapshot: item as! DataSnapshot)
                _orders.append(order)
            }
            self?.orders = _orders
            self?.tableView.reloadData()
            print(self?.orders)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCurUserOrder" {
            if let indexPath = tableView.indexPathForSelectedRow {
                print(loadOrders(orderID: keyValues[indexPath.row]))
                guard let dvc = segue.destination as? CurUserOrderDetailViewController else {return}
                print(orders)
                dvc.orders = orders
            }
        }
    }

}
