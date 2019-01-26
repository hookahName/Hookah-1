//
//  CurUserOrderDetailViewController.swift
//  Hokah
//
//  Created by Саша Руцман on 27.01.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class CurUserOrderDetailViewController: UIViewController {
    
    @IBOutlet weak var PriceLabel: UILabel!
    @IBOutlet weak var tableLabel: UILabel!
    @IBOutlet weak var tobaccoLabel: UILabel!
    @IBOutlet weak var tobaccoTasteLabel: UILabel!
    @IBOutlet weak var teaTastesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var identifierLabel: UILabel!
    var order: OrderDB?
    var tastes = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let order = order else { return }
        
        for i in 0..<order.tastes.count {
            if i == order.tastes.count - 1 {
                tastes += order.tastes[i]
            } else {
                tastes += order.tastes[i] + ", "
            }
        }
        
        PriceLabel.text = "Цена: \(order.price)"
        tableLabel.text = "Стол: Номер \(order.tableNumber)"
        tobaccoLabel.text = "Табак: \(order.tobacco)"
        tobaccoTasteLabel.text = "Вкусы табака: \(tastes)"
        teaTastesLabel.text = "Вкусы чая: \(order.tea)"
        timeLabel.text = "Время: \(order.time)"
        identifierLabel.text = "Номер заказа: \(order.identifier)"
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
