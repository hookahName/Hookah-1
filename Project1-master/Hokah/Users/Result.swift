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
    var selectedTabacoo: String!
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
        tabacoo.text = "Табак: \(selectedTabacoo)"
        TimeLabel.text = "Ждем вас в \(String(describing: selectedTime))"
        if let selectedTea = selectedTea {
            teaTaste.text = "Чай: \(selectedTea)"
        } else {
            teaTaste.text = "Чай не выбран"
        }
    }
    @IBAction func makeOrderButton(_ sender: Any) {
        ref = Database.database().reference()
        let order = OrderDB(tableNumber: selectedTable, tobacco: selectedTabacoo, tastes: selectedFlavour, tea: selectedTea, time: selectedTime)
        let orderRef = self.ref.child("orders").child((order?.tobacco)!)
        orderRef.setValue(order?.convertToDictionary())
        let ac = UIAlertController(title: "Готово!", message: "Ваш заказ уже делается", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Хорошо", style: .default))
        present(ac, animated: true)
    }
}
