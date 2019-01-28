//
//  Result.swift
//  Hokah
//
//  Created by Кирилл Иванов on 06/01/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase

class Result: UIViewController, UINavigationControllerDelegate {

    // MARK: Properties
    
    var selectedTable: Int!
    var selectedTabacoo: TobaccoDB?
    var selectedFlavour: [String]!
    var selectedTime: String!
    var selectedTea: String!
    var flavours: String = ""
    var ref: DatabaseReference!
    var orders = Array<OrderDB>()
    
    var order: OrderDB?
    
    @IBOutlet weak var orderDetailsView: UIStackView!
    @IBOutlet var hookahsSegmented: UISegmentedControl!
    @IBOutlet weak var tableNumber: UILabel!
    @IBOutlet weak var tabacoo: UILabel!
    @IBOutlet weak var flavour: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var teaTaste: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // MARK: View settings
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        order = OrderDB(tableNumber: selectedTable, tobacco: (selectedTabacoo?.name)!, tastes: selectedFlavour, tea: selectedTea, time: selectedTime, price: (selectedTabacoo?.price)!, userId: (Auth.auth().currentUser?.uid)!)
        self.orders.insert(order!, at: 0)
        
        print(orders.count)
        guard let selectedTable = selectedTable else { return }
        guard let selectedTabacoo = selectedTabacoo else { return }
        guard let selectedFlavour = selectedFlavour else { return }
        guard let selectedTime = selectedTime else { return }
        
        if let selectedTea = selectedTea {
            teaTaste.text = "Чай: \(selectedTea)"
        }
        
        var arraySegmentString = Array<String>()
        
        if orders.count < 2 {
            hookahsSegmented.isHidden = true
        } else {
            for index in 0..<orders.count {
                let orderString = "Заказ \(index + 1)"
                arraySegmentString.append(orderString)
            }
            hookahsSegmented.replaceSegments(segments: arraySegmentString)
        }
        
        for i in 0..<selectedFlavour.count {
            if i == selectedFlavour.count - 1 {
                flavours += selectedFlavour[i]
            } else {
                flavours += selectedFlavour[i] + ", "
            }
        }
        var finalPrice = 0
        for order in orders {
            finalPrice += Int(order.price)!
        }
        
        flavour.text = "Вкус: \(flavours)"
        tableNumber.text = "Стол: \(selectedTable)"
        tabacoo.text = "Табак: \(selectedTabacoo.name)"
        TimeLabel.text = "Ждем вас в \(String(describing: selectedTime))"
        if let selectedTea = selectedTea {
            teaTaste.text = "Чай: \(selectedTea)"
        } else {
            teaTaste.text = "Чай не выбран"
        }
        priceLabel.text = "Цена: \(finalPrice) Руб."
        
    }
    @IBAction func oneMoreHookah(_ sender: Any) {
    }
    
    @IBAction func makeOrderButton(_ sender: Any) {
        let identifier = getUniqueIdentifier()
        ref = Database.database().reference()
        let order = OrderDB(tableNumber: selectedTable, tobacco: (selectedTabacoo?.name)!, tastes: selectedFlavour, tea: selectedTea, time: selectedTime, identifier: identifier, price: (selectedTabacoo?.price)!, userId: (Auth.auth().currentUser?.uid)!)
        let orderRef = self.ref.child("users").child((Auth.auth().currentUser?.uid)!).child("orders").child(identifier)
        orderRef.setValue(order?.convertToDictionary())
        let ac = UIAlertController(title: "Готово!", message: "Номер вашего заказа: \(identifier)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Хорошо", style: .default) { [weak self] _ in
            self!.performSegue(withIdentifier: "toMainScreen", sender: nil)
        }
        ac.addAction(action)
        present(ac, animated: true)
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        let order = orders[hookahsSegmented.selectedSegmentIndex]
        
        flavours = ""
        
        for i in 0..<order.tastes.count {
            if i == order.tastes.count - 1 {
                flavours += order.tastes[i]
            } else {
                flavours += order.tastes[i] + ", "
            }
        }
        
        flavour.text = "Вкус: \(flavours)"
        tableNumber.text = "Стол: \(order.tableNumber)"
        tabacoo.text = "Табак: \(order.tobacco)"
        TimeLabel.text = "Ждем вас в \(String(describing: order.time))"
        teaTaste.text = "Чай: \(order.tea)"
        //priceLabel.text = "Цена: \(order.price) Руб."
    }
 
    private func getUniqueIdentifier() -> String {
        let curDate = Date()
        let timeInterval = curDate.timeIntervalSince1970
        let dateString = String(Int(timeInterval))
        print(dateString)
        return dateString
    }
}

extension UISegmentedControl {
    func replaceSegments(segments: Array<String>) {
        self.removeAllSegments()
        for segment in segments {
            insertSegment(withTitle: segment, at: self.numberOfSegments, animated: false)
        }
    }
}
