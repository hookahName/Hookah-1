//
//  OrderDetailsViewController.swift
//  Hokah
//
//  Created by Кирилл Иванов on 26/01/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase

class OrderDetailsViewController: UIViewController {

    //  MARK: Properties
    
    var order: OrderDB?
    var ref: DatabaseReference!
    var tastes = ""
    
    @IBOutlet var tableNumberLabel: UILabel!
    @IBOutlet var tobaccoNameLabel: UILabel!
    @IBOutlet var tastesLabel: UILabel!
    @IBOutlet var teaTasteLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet weak var identifierLabel: UILabel!
    @IBOutlet weak var orderIsDoneButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let order = order else {
            return
        }

        for i in 0..<order.tastes.count {
            if i == order.tastes.count - 1 {
                tastes += order.tastes[i]
            } else {
                tastes += order.tastes[i] + ", "
            }
        }
        
        tableNumberLabel.text = "Стол: Номер \(order.tableNumber)"
        tobaccoNameLabel.text = "Табак: \(order.tobacco)"
        tastesLabel.text = "Вкусы: \(tastes)"
        teaTasteLabel.text = "Чай: \(order.tea)"
        timeLabel.text = "Время: \(String(describing: order.time))"
        identifierLabel.text = "Номер заказа: \(order.identifier)"
        
        if order.isDone == true {
            orderIsDoneButton.isEnabled = false
        }
        priceLabel.text = "Цена: \(order.price)"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func orderIsDoneButton(_ sender: Any) {
        if let order = order {
            order.isDone = !order.isDone
            ref = Database.database().reference().child("users").child(order.userId).child("orders")
            ref.child(order.identifier).updateChildValues(["table": order.tableNumber, "tobacco": order.tobacco, "tastes": order.tastes, "tea": order.tea, "time": order.time, "isDone": order.isDone, "identifier": order.identifier])
        }
    }
    
}
