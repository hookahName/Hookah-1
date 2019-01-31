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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var imagePicker = UIImagePickerController()
    var chosenTobacco: TobaccoDB?
    var chosenTaste: TasteDB?
    var ref: DatabaseReference!
    let container: UIView = UIView()
    let loadingView: UIView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        saveButton.isEnabled = false
        tasteImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentImagePicker)))
        imagePicker.delegate = self
        //imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        tasteImage.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
        tasteTextfield.placeholder = "Вкус"
        
        if chosenTaste != nil {
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
        if chosenTaste != nil {
            
        } else {
            activityIndicatorSettings()
            guard let newTaste = tasteTextfield.text, newTaste != "" else {return}
            let imageName = NSUUID().uuidString
            print("имя картинки создано")
            let storageRef = Storage.storage().reference().child("tastesImage").child("\(imageName).png")
            if let uploadData = self.tasteImage.image!.pngData() {
                storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    if error != nil {
                        print(error!)
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
                    self.activityIndicatorStopped()
                    self.performSegue(withIdentifier: "unwindSegueToTastes", sender: nil)
                }
            }
            
            
        }
        
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
    
    private func activityIndicatorSettings() {
        
        container.frame = view.frame
        container.center = view.center
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = view.center
        loadingView.layer.cornerRadius = 10
        loadingView.backgroundColor =  #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        activityIndicator.isHidden = false
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
        activityIndicator.isHidden = true
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
