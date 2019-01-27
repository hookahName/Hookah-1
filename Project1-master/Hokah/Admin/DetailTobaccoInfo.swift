//
//  DetailTobaccoInfo.swift
//  Hokah
//
//  Created by Кирилл Иванов on 27/01/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase

class DetailTobaccoInfo: UIViewController {

    var tobacco: TobaccoDB?
    var ref: DatabaseReference!
    
    @IBOutlet weak var tobaccoImageView: UIImageView!
    @IBOutlet weak var tobaccoNameText: UITextField!
    @IBOutlet weak var tobaccoPriceText: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tobacco = tobacco {
            tobaccoNameText.text = tobacco.name
            
            tobaccoPriceText.text = tobacco.price
        } else {
            tobaccoNameText.placeholder = "Name"
            tobaccoPriceText.placeholder = "Price"
        }
        
        tobaccoImageView.image = UIImage(named: "defaultTobacco")
        
        title = "Tobacco Detail"
        saveButton.isEnabled = false
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if let tobacco = tobacco {
            ref = Database.database().reference()
            
        }
    }
    
    @IBAction func textFieldDidChanged(_ sender: UITextField) {
        saveButton.isEnabled = true
    }
    
    
}
