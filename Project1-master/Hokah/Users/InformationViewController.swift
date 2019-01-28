//
//  InformationViewController.swift
//  Hokah
//
//  Created by Саша Руцман on 28.01.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase
class InformationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var hookahImageView: UIImageView!
    @IBOutlet weak var changeInfoButton: UIBarButtonItem!
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var contactsTextView: UITextView!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hookahImageView.image = UIImage(named: "aboutus")
        
        locationTextView.isEditable = false
        locationTextView.text = "Вы можете найти нас по адресу: ул. Ботаническая, д. 6"
        
        contactsTextView.isEditable = false
        contactsTextView.text = "<Кальянная>: 8-(921)-123-321-12"
        
        changeInfoButton.isEnabled = false
        changeInfoButton.title = nil
        if Auth.auth().currentUser?.uid == "gHPSmMsKb0PNsLgQHYh35l4tJWj1" {
            changeInfoButton.isEnabled = true
            changeInfoButton.title = "Изменить"
        }
        // Do any additional setup after loading the view.
        //var gestureRecognizer = UITapGestureRecognizer(target: hookahImageView, action: #selector(presentImagePicker))
    }
    
    

    @IBAction func changeInfoButtonPressed(_ sender: UIBarButtonItem) {
        if changeInfoButton.title == "Изменить" {
            changeInfoButton.title = "Сохранить"
            locationTextView.isEditable = true
            
            contactsTextView.isEditable = true
            
            imagePicker.delegate = self
            //imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            
            //hookahImageView.addGestureRecognizer
        } else {
            changeInfoButton.title = "Изменить"
            locationTextView.isEditable = false
            
            contactsTextView.isEditable = false
            //hookahImageView.removeGestureRecognizer(gestureRecognizer)
        }
        
        
    }
    
    @objc func presentImagePicker() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            
            return
        }
        self.hookahImageView.image = image
    }
    
}
