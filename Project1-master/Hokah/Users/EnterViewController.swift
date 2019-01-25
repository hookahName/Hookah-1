//
//  EnterViewController.swift
//  Hokah
//
//  Created by Саша Руцман on 25.01.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase
class EnterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passTextfield: UITextField!
    @IBOutlet weak var enterBut: UIButton!
    @IBOutlet weak var registerBut: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        warningLabel.alpha = 0
        Auth.auth().addIDTokenDidChangeListener { (auth, user) in
            if user != nil {
                self.performSegue(withIdentifier: "Enter", sender: nil)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextfield.text = ""
        passTextfield.text = ""
    }
    
    @IBAction func enterButPressed(_ sender: UIButton) {
        guard let email = emailTextfield.text, let password = passTextfield.text, email != "", password != "" else {
            displayWarningLabel(WithText: "info is incorrect")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if error != nil {
                self?.displayWarningLabel(WithText: "Error occured")
                return
            }
            if user != nil {
                 self?.performSegue(withIdentifier: "Enter", sender: nil)
                return
            }
            self?.displayWarningLabel(WithText: "no such user")
        }
    }
    
    private func displayWarningLabel(WithText text: String) {
        warningLabel.text = text
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
            self?.warningLabel.alpha = 1
        }) { [weak self] complete in
            self?.warningLabel.alpha = 0
        }
    }
    
    @IBAction func registerButPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "Register", sender: nil)
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
