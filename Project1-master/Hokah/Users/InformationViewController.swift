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
    @IBOutlet weak var activityIindicator: UIActivityIndicatorView!
    
    var imagePicker = UIImagePickerController()
    let tap = UITapGestureRecognizer(target: self, action: #selector(presentImagePicker))
    var ref: DatabaseReference!
    var infoDB = Array<InfoDB>()
    var users = Array<UserDB>()
    var infoPhoto: UIImage?
    let container: UIView = UIView()
    let loadingView: UIView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if infoDB.count > 0 {
            contactsTextView.text = infoDB[0].contacts
            locationTextView.text = infoDB[0].location
            hookahImageView.image = infoPhoto
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
        
        if Auth.auth().currentUser?.uid == "9v3ziIPm9hWZW3IvasRw904xd2d2" {
            changeInfoButton.isEnabled = true
            changeInfoButton.title = "Изменить"
        }
        
        activityIindicator.isHidden = true
        
        
        
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
            activityIndicatorSettings()
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
                    self.activityIndicatorStopped()
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
    
    private func activityIndicatorSettings() {
        
        container.frame = view.frame
        container.center = view.center
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = view.center
        loadingView.layer.cornerRadius = 10
        loadingView.backgroundColor =  #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        activityIindicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIindicator.style =
            UIActivityIndicatorView.Style.whiteLarge
        activityIindicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        loadingView.addSubview(activityIindicator)
        container.addSubview(loadingView)
        view.addSubview(container)
        
        activityIindicator.isHidden = false
        activityIindicator.hidesWhenStopped = true
        activityIindicator.color =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        activityIindicator.startAnimating()
        
    }
    
    private func activityIndicatorStopped() {
        activityIindicator.stopAnimating()
        container.removeFromSuperview()
        loadingView.removeFromSuperview()
    }
}
