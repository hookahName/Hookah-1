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

    var orders = Array<OrderDB>()
    var currentUser = Auth.auth().currentUser?.uid
    var ref: DatabaseReference!
    
    // MARK: View settings
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //loadDatabase()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Ваши заказы"
        self.tableView.tableFooterView = UIView()
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    // MARK: Table view settings
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserOrder", for: indexPath)
        
        cell.textLabel?.text = "Заказ: \(orders[indexPath.row].identifier)"
        cell.accessoryType = .disclosureIndicator/*
        if orders[indexPath.row].isDone == true {
            cell.backgroundColor = .gray
        }*/
        return cell
    }
    
    func loadDatabase() {
        ref = Database.database().reference().child("users").child(currentUser!).child("orders")
        ref.observe(.value) { [weak self] (snapshot) in
            var _orders = Array<OrderDB>()
            for item in snapshot.children {
                let order = OrderDB(snapshot: item as! DataSnapshot)
                _orders.append(order)
            }
            self?.orders = _orders
            self?.tableView.reloadData()
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        loadDatabase()
        self.refreshControl?.endRefreshing()
        ref.removeAllObservers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            if segue.identifier == "toCurUserOrder" {
                guard let dvc = segue.destination as? CurUserOrderDetailViewController else {return}
                dvc.order = orders[indexPath.row]
            }
        }
    }

}
