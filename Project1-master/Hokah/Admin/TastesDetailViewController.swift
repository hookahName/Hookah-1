//
//  TastesDetailViewController.swift
//  Hokah
//
//  Created by Саша Руцман on 29.01.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase
class TastesDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tasteImage: UIImageView!
    @IBOutlet weak var tasteTextfield: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var imagePicker = UIImagePickerController()
    var chosenTobacco: TobaccoDB?
    var chosenTaste: TasteDB?
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        tasteImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentImagePicker)))
        imagePicker.delegate = self
        //imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        tasteImage.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
        print("Название табака: \(chosenTobacco?.name)")
        tasteTextfield.placeholder = "Вкус"
        
        if let taste = chosenTaste {
            tasteTextfield.text = chosenTaste?.name
        } else {
            
            tasteImage.image = UIImage(named: "addPhoto")
        }
    }
    
 
    @IBAction func tastesTextfieldWasChanged(_ sender: UITextField) {
        saveButton.isEnabled = true
    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        //guard let chosenTobacco = chosenTobacco else { return }
        if let chosenTaste = chosenTaste {
            
        } else {
            guard let newTaste = tasteTextfield.text, newTaste != "" else {return}
            let imageName = NSUUID().uuidString
            print("имя картинки создано")
            let storageRef = Storage.storage().reference().child("tastesImage").child("\(imageName).png")
            if let uploadData = self.tasteImage.image!.pngData() {
                storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    if error != nil {
                        print(error)
                        return
                    }
                    storageRef.downloadURL { (url, error) in
                        if (url?.absoluteString) != nil {
                            
                            self.ref = Database.database().reference()
                            print("Начинается занесение в бд")
                            let tasteDB = TasteDB(name: newTaste, imageName: imageName)
                            self.ref.child("tobaccos").child(self.chosenTobacco!.name.lowercased()).child("tastes").child((tasteDB?.name.lowercased())!).setValue(tasteDB?.convertToDictionary())
                        }
                    }
                }
            }
            
            
        }
        //performSegue(withIdentifier: "toTastes", sender: nil)
    }
    
    @objc func presentImagePicker() {
        print("11")
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            
            return
        }
        self.tasteImage.image = image
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTastes" {
            guard segue.destination is AddTastesTableViewController else { return }
        }
    }
            
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
