//
//  DetailTobaccoInfo.swift
//  Hokah
//
//  Created by Кирилл Иванов on 27/01/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase
class DetailTobaccoInfo: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var tobacco: TobaccoDB?
    var ref: DatabaseReference!
    var imagePicker = UIImagePickerController()
    var choosenImage : UIImage?

    @IBOutlet weak var tobaccoImageView: UIImageView!
    @IBOutlet weak var tobaccoNameText: UITextField!
    @IBOutlet weak var tobaccoPriceText: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tobaccoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentImagePicker)))
        
        imagePicker.delegate = self
        //imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
    
        if let tobacco = tobacco {
            tobaccoNameText.text = tobacco.name.capitalized
            tobaccoNameText.isEnabled = false
            tobaccoImageView.image = UIImage(named: "defaultTobacco")
            
            tobaccoPriceText.text = tobacco.price
        } else {
            tobaccoNameText.placeholder = "Name"
            tobaccoPriceText.placeholder = "Price"
            tobaccoImageView.image = UIImage(named: "addPhoto")
        }
        
        
        title = "Tobacco Detail"
        saveButton.isEnabled = false
    }

    
    @objc func presentImagePicker() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if let tobacco = tobacco {
            guard let newPrice = tobaccoPriceText.text, newPrice != "" else {return}
            ref = Database.database().reference()
            ref.child("tobaccos").child(tobacco.name.lowercased()).updateChildValues(["name": tobacco.name.lowercased(), "price": newPrice, "isAvailable": tobacco.isAvailable])
        } else {
            guard let newPrice = tobaccoPriceText.text, let newTobacco = tobaccoNameText.text, newPrice != "", newTobacco != "" else {return}
            let tobaccoDB = TobaccoDB(name: newTobacco, price: newPrice)
            ref = Database.database().reference()
            ref.child("tobaccos").child(tobaccoDB!.name.lowercased()).setValue(tobaccoDB?.convertToDictionary())
            
        }
        performSegue(withIdentifier: "unwindSegueToAdmin", sender: self)
    }

    
    @IBAction func textFieldDidChanged(_ sender: UITextField) {
        saveButton.isEnabled = true
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            
            return
        }
        self.tobaccoImageView.image = image
    }
}

