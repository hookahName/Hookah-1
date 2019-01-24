//
//  AdminViewController.swift
//  Hokah
//
//  Created by Саша Руцман on 21.01.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase
class AdminViewController: UIViewController {
    
    // MARK: Properties
    
    var ref: DatabaseReference!
    
    // MARK: View settings
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Admin"
        // Do any additional setup after loading the view.
    }
    
    // MARK: Private functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChangeTobacco" {
            guard segue.destination is AdminTableViewController else {return}
        } else if segue.identifier == "TeaTaste" {
            guard segue.destination is ChangeTeaTasteTableViewController else {return}
        }
    }
    
    @IBAction func changePassButtonPressed(_ sender: Any) {
        ref = Database.database().reference()
        let alertController = UIAlertController(title: "Изменить пароль", message: "Новый пароль", preferredStyle: .alert)
        alertController.addTextField()
        let save = UIAlertAction(title: "Save", style: .default) { [ weak self] _ in
            
            guard let textField = alertController.textFields?.first, textField.text != "" else {return}
            let pass = PasswordDB(password: textField.text!)
            _ = self?.ref.child("password").child("password").updateChildValues(["password": pass?.password as Any]) // Почему _ ?
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        
        alertController.addAction(save)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
}
    


