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
    let tap = UITapGestureRecognizer(target: self, action: #selector(presentImagePicker))
    var ref: DatabaseReference!
    var infoDB = Array<InfoDB>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hookahImageView.image = UIImage(named: "aboutus")
        if infoDB.count > 0 {
            contactsTextView.text = infoDB[0].contacts
            locationTextView.text = infoDB[0].location
        } else {
            locationTextView.text = "Мы находимся по адресу: ..."
            contactsTextView.text = "Кальянная: ..."
        }
        locationTextView.isEditable = false
        
        contactsTextView.isEditable = false
        
        changeInfoButton.isEnabled = false
        changeInfoButton.title = nil
        
        imagePicker.delegate = self
        //imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        if Auth.auth().currentUser?.uid == "gHPSmMsKb0PNsLgQHYh35l4tJWj1" {
            changeInfoButton.isEnabled = true
            changeInfoButton.title = "Изменить"
        }
        // Do any additional setup after loading the view.
        
    }
    
    

    @IBAction func changeInfoButtonPressed(_ sender: UIBarButtonItem) {
        if changeInfoButton.title == "Изменить" {
            changeInfoButton.title = "Сохранить"
            locationTextView.isEditable = true
            
            contactsTextView.isEditable = true
            
            hookahImageView.addGestureRecognizer(tap)
        } else {
            guard let contactsText = contactsTextView.text, let locationText = locationTextView.text, contactsText != "", locationText != "" else { return }
            ref = Database.database().reference().child("info").child("information")
            ref.updateChildValues(["Contacts" : contactsTextView.text, "Location": locationTextView.text])
            changeInfoButton.title = "Изменить"
            locationTextView.isEditable = false
            
            contactsTextView.isEditable = false
            hookahImageView.removeGestureRecognizer(tap)
            
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
