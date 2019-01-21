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
    var ref: DatabaseReference!
    var tobaccos: Array<TobaccoDB>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Admin"
        print(tobaccos.count)
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChangeTobacco" {
            guard let admin = segue.destination as? AdminTableViewController else {return}
            admin.tobaccos = self.tobaccos
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
            let pass = passDB(password: textField.text!)
            _ = self?.ref.child("password").child("password").updateChildValues(["password": pass?.password as Any])
            //self?.tobaccos.append(tabaco!)
            //self?.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        
        alertController.addAction(save)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    }
    


