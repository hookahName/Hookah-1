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
    var tobaccoImage: UIImage?
    let container: UIView = UIView()
    let loadingView: UIView = UIView()


    @IBOutlet weak var tobaccoImageView: UIImageView!
    @IBOutlet weak var tobaccoNameText: UITextField!
    @IBOutlet weak var tobaccoPriceText: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        tobaccoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentImagePicker)))
        
        imagePicker.delegate = self
        //imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
    
        if let tobacco = tobacco {
            tobaccoNameText.text = tobacco.name.capitalized
            tobaccoNameText.isEnabled = false
            tobaccoPriceText.text = tobacco.price
            tobaccoImageView.image = tobaccoImage
//            let reference = Storage.storage().reference(withPath: "tobaccosImage/\(tobacco.imageName).png")
//            reference.getData(maxSize: (1 * 1772 * 2362)) { (data, error) in
//                if let _error = error{
//                    print("ОШИБКА")
//                    print(_error)
//                } else {
//                    print("Загружено")
//                    if let _data  = data {
//
//                    }
//                }
//            }
        } else {
            tobaccoNameText.placeholder = "Name"
            tobaccoPriceText.placeholder = "Price"
            tobaccoImageView.image = UIImage(named: "addPhoto")
        }
        
        
        
        title = "Tobacco Detail"
        saveButton.isEnabled = false
    }

    
    

    
            
    
    @objc func presentImagePicker() {
        print("222")
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if let tobacco = tobacco {
            activityIndicatorSettings()
            if let deleteImageName = self.tobacco?.imageName {
                let deleteRef = Storage.storage().reference().child("infoImage").child("\(deleteImageName).png")
                deleteRef.delete { (error) in
                    if error != nil {
                        print("Error")
                    } else {
                        print("deleted succesfully")
                    }
                }
            }
            guard let newPrice = tobaccoPriceText.text, newPrice != "" else {return}
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("tobaccosImage").child("\(imageName).png")
            if let uploadData = self.tobaccoImageView.image!.pngData() {
                storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    storageRef.downloadURL { (url, error) in
                        if (url?.absoluteString) != nil {
                            
                            self.ref = Database.database().reference()
                            self.ref.child("tobaccos").child(tobacco.name.lowercased()).updateChildValues(["name": tobacco.name.lowercased(), "price": newPrice, "isAvailable": tobacco.isAvailable, "imageName": imageName])
                        }
                    }
                    self.activityIndicatorStopped()
                    self.performSegue(withIdentifier: "unwindSegueToAdmin", sender: self)
                }
            }
            
        }
        else {
            activityIndicatorSettings()
            guard let newPrice = tobaccoPriceText.text, let newTobacco = tobaccoNameText.text, newPrice != "", newTobacco != "" else {return}
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("tobaccosImage").child("\(imageName).png")
            if let uploadData = self.tobaccoImageView.image!.pngData() {
                storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    storageRef.downloadURL { (url, error) in
                        if (url?.absoluteString) != nil {
                            
                            self.ref = Database.database().reference()
                            let tobaccoDB = TobaccoDB(name: newTobacco, price: newPrice, imageName: imageName)
                            self.ref.child("tobaccos").child(tobaccoDB!.name.lowercased()).setValue(tobaccoDB?.convertToDictionary())
                        }
                    }
                    self.activityIndicatorStopped()
                    self.performSegue(withIdentifier: "unwindSegueToAdmin", sender: self)
                }
            }
            
            
        }
        
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
    
    private func activityIndicatorSettings() {
        
        container.frame = view.frame
        container.center = view.center
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = view.center
        loadingView.layer.cornerRadius = 10
        loadingView.backgroundColor =  #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style =
            UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        view.addSubview(container)
        
        activityIndicator.isHidden = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        activityIndicator.startAnimating()
        
    }
    
    private func activityIndicatorStopped() {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
        loadingView.removeFromSuperview()
    }
}


