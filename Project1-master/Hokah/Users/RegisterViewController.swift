//
//  RegisterViewController.swift
//  Hokah
//
//  Created by Саша Руцман on 25.01.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var lastnameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var regButton: UIButton!
    var ref: DatabaseReference!
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextfield.text = ""
        emailTextfield.text = ""
        passwordTextfield.text = ""
    }
    
    @IBAction func regButtonPressed(_ sender: Any) {
        ref = Database.database().reference()
        guard let email = emailTextfield.text, let password = passwordTextfield.text, let name = nameTextfield.text, name != "", email != "", password != "" else {
            
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            if error == nil {
                if user != nil {
                    let user = UserDB(name: name, email: email, password: password, userId: (Auth.auth().currentUser?.uid)!)
                    let userRef = self?.ref.child("users").child((Auth.auth().currentUser?.uid)!)
                    userRef?.setValue(user?.convertToDictionary())
                    self?.performSegue(withIdentifier: "fromReg", sender: nil)
                }
                else{
                  print("no such user")
                }
            }
            else{
                print(error!.localizedDescription)
            }
        }
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
