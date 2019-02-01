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
    var hookahs = Array<HookahDB>()
    var ref: DatabaseReference!
    var tastes = ""
    var finalPrice = 0
    
    @IBOutlet var hookahsSegmented: UISegmentedControl!
    @IBOutlet var tableNumberLabel: UILabel!
    @IBOutlet var tobaccoNameLabel: UILabel!
    @IBOutlet var tastesLabel: UILabel!
    @IBOutlet var teaTasteLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet weak var identifierLabel: UILabel!
    @IBOutlet weak var orderIsDoneButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var fortressLabel: UILabel!
    @IBOutlet weak var thisHookahPriceLabel: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref = Database.database().reference().child("users").child(order!.userId).child("orders").child(order!.identifier).child(order!.identifier)
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
        title = order?.identifier
        hookahsSegmented.isHidden = true
        changeHidden()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let order = order else {
            return
        }
        segmentedControlSettings()

        changeHidden()
        for i in 0..<hookahs[0].tastes.count {
            if i == hookahs[0].tastes.count - 1 {
                tastes += hookahs[0].tastes[i]
            } else {
                tastes += hookahs[0].tastes[i] + ", "
            }
        }
        for hookah in hookahs {
            finalPrice += Int(hookah.price)!
        }
        
        tableNumberLabel.text = "Стол: Номер \(order.tableNumber)"
        tobaccoNameLabel.text = "Табак: \(hookahs[0].tobacco)"
        tastesLabel.text = "Вкусы: \(tastes)"
        teaTasteLabel.text = "Чай: \(hookahs[0].tea)"
        timeLabel.text = "Время: \(String(describing: hookahs[0].time))"
        identifierLabel.text = "Номер заказа: \(String(describing: order.identifier))"
        thisHookahPriceLabel.text = "Цена: \(hookahs[0].price)"
        fortressLabel.text = "Крепость: \(hookahs[0].fortress)"
        if order.isDone == true {
            orderIsDoneButton.isEnabled = false
        }
        priceLabel.text = "Итого: \(finalPrice) Руб."
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ref.removeAllObservers()
    }
    
    func changeHidden() {
        tableNumberLabel.isHidden = !tableNumberLabel.isHidden
        tobaccoNameLabel.isHidden = !tobaccoNameLabel.isHidden
        tastesLabel.isHidden = !tastesLabel.isHidden
        teaTasteLabel.isHidden = !teaTasteLabel.isHidden
        timeLabel.isHidden = !timeLabel.isHidden
        identifierLabel.isHidden = !identifierLabel.isHidden
        priceLabel.isHidden = !priceLabel.isHidden
        thisHookahPriceLabel.isHidden = !thisHookahPriceLabel.isHidden
        fortressLabel.isHidden = !fortressLabel.isHidden
    }
 
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        let hookah = hookahs[hookahsSegmented.selectedSegmentIndex]
        var flavours = ""
        for i in 0..<hookah.tastes.count {
            if i == hookah.tastes.count - 1 {
                flavours += hookah.tastes[i]
            } else {
                flavours += hookah.tastes[i] + ", "
            }
        }
        
        tobaccoNameLabel.text = "Табак: \(hookah.tobacco)"
        tastesLabel.text = "Вкусы: \(flavours)"
        teaTasteLabel.text = "Чай: \(hookah.tea)"
        timeLabel.text = "Время: \(hookah.time)"
        thisHookahPriceLabel.text = "Цена: \(hookah.price)"
        fortressLabel.text = "Крепость: \(hookah.fortress)"
    }
    
    private func segmentedControlSettings() {
        
        var arraySegmentString = Array<String>()
        
        if hookahs.count < 2 {
            hookahsSegmented.isHidden = true
        } else {
            hookahsSegmented.isHidden = false
            for index in 0..<hookahs.count {
                let orderString = "Кальян \(index + 1)"
                arraySegmentString.append(orderString)
            }
            hookahsSegmented.replaceSegments(segments: arraySegmentString)
            
        }
        
        hookahsSegmented.selectedSegmentIndex = 0
    }
    
    @IBAction func orderIsDoneButton(_ sender: Any) {
        if let order = order {
            order.isDone = !order.isDone
            ref = Database.database().reference().child("users").child(order.userId).child("orders")
            ref.child(order.identifier).updateChildValues(["isDone": order.isDone])
        }
    }
}
