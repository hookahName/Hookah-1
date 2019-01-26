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
    
    var orders = Array<OrderDB>()
    var ref: DatabaseReference!

    // MARK: View settings
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDatabase()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Orders"
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
        return orders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Order", for: indexPath)
        cell.textLabel?.text = "Заказ: \(orders[indexPath.row].tobacco)"
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    private func loadDatabase() {
        ref = Database.database().reference().child("orders")
        ref.observe(.value, with: { [weak self] (snapshot) in
            var _orders = Array<OrderDB>()
            for item in snapshot.children {
                let order = OrderDB(snapshot: item as! DataSnapshot)
                _orders.append(order)
            }
            self?.orders = _orders
            self?.tableView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderDetails" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let dvc = segue.destination as? OrderDetailsViewController else {return}
                dvc.order = self.orders[indexPath.row]
            }
        }
    }
    
    @IBAction func unwindToOrders(segue: UIStoryboardSegue) {
        if segue.identifier == "backToOrders" {
            guard segue.source is OrderDetailsViewController else {return}
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        loadDatabase()
        self.refreshControl?.endRefreshing()
    }
}
