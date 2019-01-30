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
    var orders = Array<OrderDB>()
    var ref: DatabaseReference!
    
    // MARK: View settings
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //loadDatabase()
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
        loadDatabase()
        self.refreshControl?.endRefreshing()
        ref.removeAllObservers()
    }
    // MARK: Table view settings
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Order", for: indexPath)
        cell.textLabel?.text = "Заказ: \(orders[indexPath.row].identifier)"
        cell.accessoryType = .disclosureIndicator
        /*
        if orders[indexPath.row].isDone == true {
            cell.backgroundColor = .gray
        }*/
        return cell
    }
    
    func loadDatabase() {
        ref = Database.database().reference().child("users")
        var _orders = Array<OrderDB>()
        if let users = users {
            for user in users {
                ref.child(user.userId).child("orders").observe(.value, with: {[weak self] (snapshot) in
                    for item in snapshot.children {
                        let order = OrderDB(snapshot: item as! DataSnapshot)
                        _orders.append(order)
                    }
                    self?.orders = _orders
                    self?.tableView.reloadData()
                })
            }
            //orders = _orders
            //tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderDetails" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let dvc = segue.destination as? OrderDetailsViewController else {return}
                dvc.order = orders[indexPath.row]
            }
        }
    }
    
    @IBAction func unwindToOrders(segue: UIStoryboardSegue) {
        if segue.identifier == "backToOrders" {
            guard segue.source is OrderDetailsViewController else {return}
        }
    }
}
