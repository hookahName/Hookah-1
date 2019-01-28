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
        imagePicker.allowsEditing = false
        
        if Auth.auth().currentUser?.uid == "gHPSmMsKb0PNsLgQHYh35l4tJWj1" {
            changeInfoButton.isEnabled = true
            changeInfoButton.title = "Изменить"
        }
        
        let reference = Storage.storage().reference(withPath: "infoImage/\(infoDB[0].imageName).png")
        
        reference.getData(maxSize: (1 * 1772 * 2362)) { (data, error) in
            if let _error = error{
                print("ОШИБКА")
                print(_error)
            } else {
                print("Загружено")
                if let _data  = data {
                    self.hookahImageView.image = UIImage(data: _data)
                }
            }
        }
        
        
        
        
        // Do any additional setup after loading the view.
        
    }
    
    

    @IBAction func changeInfoButtonPressed(_ sender: UIBarButtonItem) {
        if changeInfoButton.title == "Изменить" {
            changeInfoButton.title = "Сохранить"
            locationTextView.isEditable = true
            hookahImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentImagePicker)))
            hookahImageView.isUserInteractionEnabled = true
            contactsTextView.isEditable = true
            
            
        } else {
            let deleteImageName = self.infoDB[0].imageName
            let deleteRef = Storage.storage().reference().child("infoImage").child("\(deleteImageName).png")
            deleteRef.delete { (error) in
                if let error = error {
                    print("Error")
                } else {
                    print("deleted succesfully")
                }
            }
            guard let contactsText = contactsTextView.text, let locationText = locationTextView.text, contactsText != "", locationText != "" else { return }
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("infoImage").child("\(imageName).png")
            if let uploadData = self.hookahImageView.image!.pngData() {
                storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    storageRef.downloadURL { (url, error) in
                        if let downloadURL = url?.absoluteString {
                            self.ref = Database.database().reference().child("info").child("information")
                            self.ref.updateChildValues(["Contacts" : self.contactsTextView.text, "Location": self.locationTextView.text, "Url": downloadURL, "imageName": imageName])
                        }
                        
                        
                    }
                }
            }
            
            
            
            changeInfoButton.title = "Изменить"
            locationTextView.isEditable = false
            
            contactsTextView.isEditable = false
            
            
        }
        
        
    }
    
    @objc func presentImagePicker() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.hookahImageView.image = originalImage
        } else if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.hookahImageView.image = editedImage
            
        }
    }
    
    
}
