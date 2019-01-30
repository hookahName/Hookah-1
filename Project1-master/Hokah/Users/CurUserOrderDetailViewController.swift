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
    
    var ref: DatabaseReference!
    var hookahs = Array<HookahDB>()
    var order: OrderDB?
    var tastes = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("orders").child(order!.identifier).child(order!.identifier)
        ref.observe(.value) { [weak self] (snapshot) in
            var _hookahs = Array<HookahDB>()
            for item in snapshot.children {
                let hookah = HookahDB(snapshot: item as! DataSnapshot)
                _hookahs.append(hookah)
            }
            self?.hookahs = _hookahs
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
        
        guard let order = order else {return}
        
        segmentedControlSettings()
        
        changeHidden()
        print(hookahs.count)
        if !hookahs.isEmpty {
            var finalPrice = 0
            for i in 0..<hookahs[0].tastes.count {
                if i == hookahs[0].tastes.count - 1 {
                    tastes += hookahs[0].tastes[i]
                } else {
                    tastes += hookahs[0].tastes[i] + ", "
                }
            }
            /*
            for hookah in hookahs {
                finalPrice += Int(hookah.price)!
            }
*/
            PriceLabel.text = "Цена: \(hookahs[0].price)"
            tableLabel.text = "Стол: \(order.tableNumber)"
            tobaccoLabel.text = "Табак: \(hookahs[0].tobacco)"
            tobaccoTasteLabel.text = "Вкусы табака: \(tastes)"
            teaTastesLabel.text = "Чай: \(hookahs[0].tea)"
            timeLabel.text = "Время: \(hookahs[0].time)"
            identifierLabel.text = "Номер заказа: \(order.identifier)"
            // Do any additional setup after loading the view.
        }
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        let hookah = hookahs[hookahSegmented.selectedSegmentIndex]
        
        var flavours = ""
        
        for i in 0..<hookah.tastes.count {
            if i == hookah.tastes.count - 1 {
                flavours += hookah.tastes[i]
            } else {
                flavours += hookah.tastes[i] + ", "
            }
        }
        
        PriceLabel.text = "Цена: \(hookah.price)"
        tobaccoTasteLabel.text = "Вкусы табака: \(flavours)"
        tableLabel.text = "Стол: \(order!.tableNumber)"
        tobaccoLabel.text = "Табак: \(hookah.tobacco)"
        timeLabel.text = "Время: \(String(describing: hookah.time))"
        teaTastesLabel.text = "Чай: \(hookah.tea)"
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
        
        if hookahs.count < 2 {
            hookahSegmented.isHidden = true
        } else {
            hookahSegmented.isHidden = false
            for index in 0..<hookahs.count {
                let orderString = "Заказ \(index + 1)"
                arraySegmentString.append(orderString)
        }
        hookahSegmented.replaceSegments(segments: arraySegmentString)
        
        }
        
        hookahSegmented.selectedSegmentIndex = 0
    }
}
