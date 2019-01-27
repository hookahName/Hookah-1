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
    
    @IBOutlet weak var tableNumber: UILabel!
    @IBOutlet weak var tabacoo: UILabel!
    @IBOutlet weak var flavour: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var teaTaste: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    // MARK: View settings
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let selectedTable = selectedTable else { return }
        guard let selectedTabacoo = selectedTabacoo else { return }
        guard let selectedFlavour = selectedFlavour else { return }
        guard let selectedTime = selectedTime else { return }
        
        if let selectedTea = selectedTea {
            teaTaste.text = "Чай: \(selectedTea)"
        }
        
        for i in 0..<selectedFlavour.count {
            if i == selectedFlavour.count - 1 {
                flavours += selectedFlavour[i]
            } else {
                flavours += selectedFlavour[i] + ", "
            }
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
        priceLabel.text = "Цена: \(selectedTabacoo.price)"
        
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
    
    private func getUniqueIdentifier() -> String {
        let curDate = Date()
        let timeInterval = curDate.timeIntervalSince1970
        let dateString = String(Int(timeInterval))
        print(dateString)
        return dateString
    }
}
