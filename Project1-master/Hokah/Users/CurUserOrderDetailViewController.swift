//
//  CurUserOrderDetailViewController.swift
//  Hokah
//
//  Created by Саша Руцман on 27.01.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase

class CurUserOrderDetailViewController: UIViewController {
    
    @IBOutlet weak var PriceLabel: UILabel!
    @IBOutlet weak var tableLabel: UILabel!
    @IBOutlet weak var tobaccoLabel: UILabel!
    @IBOutlet weak var tobaccoTasteLabel: UILabel!
    @IBOutlet weak var teaTastesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var identifierLabel: UILabel!
    @IBOutlet weak var hookahSegmented: UISegmentedControl!
    
    var orderID: String?
    var ref: DatabaseReference!
    var orders = Array<OrderDB>()
    var tastes = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("orders").child(orderID!)
        ref.observe(.value) { [weak self] (snapshot) in
            var _orders = Array<OrderDB>()
            for item in snapshot.children {
                let order = OrderDB(snapshot: item as! DataSnapshot)
                _orders.append(order)
            }
            self?.orders = _orders
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        identifierLabel.isHidden = true
        changeHidden()
        hookahSegmented.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        segmentedControlSettings()
        
        changeHidden()
        
        if !orders.isEmpty {
            var finalPrice = 0
            for i in 0..<orders[0].tastes.count {
                if i == orders[0].tastes.count - 1 {
                    tastes += orders[0].tastes[i]
                } else {
                    tastes += orders[0].tastes[i] + ", "
                }
            }
            
            for order in orders {
                finalPrice += Int(order.price)!
            }
            
            PriceLabel.text = "Цена: \(finalPrice)"
            tableLabel.text = "Стол: \(orders[0].tableNumber)"
            tobaccoLabel.text = "Табак: \(orders[0].tobacco)"
            tobaccoTasteLabel.text = "Вкусы табака: \(tastes)"
            teaTastesLabel.text = "Чай: \(orders[0].tea)"
            timeLabel.text = "Время: \(orders[0].time)"
            //identifierLabel.text = "Номер заказа: \(orders[0].identifier)"
            // Do any additional setup after loading the view.*/
        }
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        let order = orders[hookahSegmented.selectedSegmentIndex]
        
        var flavours = ""
        
        for i in 0..<order.tastes.count {
            if i == order.tastes.count - 1 {
                flavours += order.tastes[i]
            } else {
                flavours += order.tastes[i] + ", "
            }
        }
        
        tobaccoTasteLabel.text = "Вкусы табака: \(flavours)"
        tableLabel.text = "Стол: \(order.tableNumber)"
        tobaccoLabel.text = "Табак: \(order.tobacco)"
        timeLabel.text = "Время: \(String(describing: order.time))"
        teaTastesLabel.text = "Чай: \(order.tea)"
    }
    
    func changeHidden() {
        PriceLabel.isHidden = !PriceLabel.isHidden
        tableLabel.isHidden = !tableLabel.isHidden
        tobaccoLabel.isHidden = !tobaccoLabel.isHidden
        tobaccoTasteLabel.isHidden = !tobaccoTasteLabel.isHidden
        teaTastesLabel.isHidden = !teaTastesLabel.isHidden
        timeLabel.isHidden = !timeLabel.isHidden
    }
    
    private func segmentedControlSettings() {
        
        var arraySegmentString = Array<String>()
        
        if orders.count < 2 {
            hookahSegmented.isHidden = true
        } else {
            hookahSegmented.isHidden = false
            for index in 0..<orders.count {
                let orderString = "Заказ \(index + 1)"
                arraySegmentString.append(orderString)
        }
        hookahSegmented.replaceSegments(segments: arraySegmentString)
        
        }
        
        hookahSegmented.selectedSegmentIndex = 0
    }
}
