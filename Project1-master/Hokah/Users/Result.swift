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
    var hookahs = Array<HookahDB>()
    
    var finalPrice = 0

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
        
        guard let selectedTable = selectedTable else { return }
        guard let selectedTabacoo = selectedTabacoo else { return }
        guard let selectedFlavour = selectedFlavour else { return }
        guard let selectedTime = selectedTime else { return }
        
        let hookah = HookahDB(tobacco: selectedTabacoo.name, tastes: selectedFlavour, tea: selectedTea, time: selectedTime, price: selectedTabacoo.price)
        
        hookahs.insert(hookah!, at: 0)
        print(" RESULT = \(hookahs.count)")
        segmentedControlSettings()
        
        for i in 0..<selectedFlavour.count {
            if i == selectedFlavour.count - 1 {
                flavours += selectedFlavour[i]
            } else {
                flavours += selectedFlavour[i] + ", "
            }
        }
        for hookah in hookahs {
            finalPrice += Int(hookah.price)!
        }
        
        flavour.text = "Вкус: \(flavours)"
        tableNumber.text = "Стол: \(String(describing: selectedTable))"
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
        let order = OrderDB(tableNumber: selectedTable, identifier: identifier, price: String(finalPrice), userId: (Auth.auth().currentUser?.uid)!)
        
        ref = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("orders").child(identifier)
        ref.setValue(order?.convertToDictionary())
        for index in 0..<hookahs.count {
            let hookah = hookahs[index]
            let hookahRef = ref.child(identifier).child("hookah" + String(index+1))
            hookahRef.setValue(hookah.convertToDict())
        }
        let ac = UIAlertController(title: "Готово!", message: "Номер вашего заказа: \(identifier)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Хорошо", style: .default) { [weak self] _ in
            self!.performSegue(withIdentifier: "toMainScreen", sender: nil)
        }
        ac.addAction(action)
        present(ac, animated: true)
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        let hookah = hookahs[hookahsSegmented.selectedSegmentIndex]
        
        flavours = ""
        
        for i in 0..<hookah.tastes.count {
            if i == hookah.tastes.count - 1 {
                flavours += hookah.tastes[i]
            } else {
                flavours += hookah.tastes[i] + ", "
            }
        }
        
        flavour.text = "Вкус: \(flavours)"
        //tableNumber.text = "Стол: \(hookah.tableNumber)"
        tabacoo.text = "Табак: \(hookah.tobacco)"
        TimeLabel.text = "Ждем вас в \(String(describing: hookah.time))"
        teaTaste.text = "Чай: \(hookah.tea)"
    }
 
    private func getUniqueIdentifier() -> String {
        let curDate = Date()
        let timeInterval = curDate.timeIntervalSince1970
        let dateString = String(Int(timeInterval))
        print(dateString)
        return dateString
    }
    
    private func segmentedControlSettings() {
        //guard let selectedTable = selectedTable else { return }
        //guard let selectedTabacoo = selectedTabacoo else { return }
        //guard let selectedFlavour = selectedFlavour else { return }
        //guard let selectedTime = selectedTime else { return }
 
        if let selectedTea = selectedTea {
            teaTaste.text = "Чай: \(selectedTea)"
        }
        
        var arraySegmentString = Array<String>()
        
        
        if hookahs.count < 2 {
            hookahsSegmented.isHidden = true
        } else {
            for index in 0..<hookahs.count {
                
                let hookahString = "Кальян \(index + 1)"
                arraySegmentString.append(hookahString)
            }
            hookahsSegmented.replaceSegments(segments: arraySegmentString)
            
        }
        
        hookahsSegmented.selectedSegmentIndex = 0
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
