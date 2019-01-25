//
//  Result.swift
//  Hokah
//
//  Created by Кирилл Иванов on 06/01/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class Result: UIViewController, UINavigationControllerDelegate {

    // MARK: Properties
    
    var selectedTable: Int?
    var selectedTabacoo: TobaccoDB?
    var selectedFlavour: [TasteDB]?
    var selectedTime: String?
    var selectedTea: TasteDB?
    var flavours: String = ""
    
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
            teaTaste.text = "Чай: \(selectedTea.name)"
        }
        
        for i in 0..<selectedFlavour.count {
            if i == selectedFlavour.count - 1 {
                flavours += selectedFlavour[i].name
            } else {
                flavours += selectedFlavour[i].name + ", "
            }
        }
        
        flavour.text = "Вкус: \(flavours)"
        tableNumber.text = "Стол: \(selectedTable+1)"
        tabacoo.text = "Табак: \(selectedTabacoo.name)"
        TimeLabel.text = "Ждем вас в \(String(describing: selectedTime))"
        if let selectedTea = selectedTea {
            teaTaste.text = "Чай: \(selectedTea.name)"
        } else {
            teaTaste.text = "Чай не выбран"
        }
    }
    @IBAction func makeOrderButton(_ sender: Any) {
    }
}
