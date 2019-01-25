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
    @IBOutlet weak var changeTobAndTastesButton: UIButton!
    @IBOutlet weak var changeTeaTastesButton: UIButton!
    
    // MARK: View settings
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser?.uid != "KosoGzwcysXHrye6pAVXDGJO0yD2" {
            changeTeaTastesButton.isHidden = true
            changeTobAndTastesButton.isHidden = true
        } else {
            title = "Админ"
        }
        
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
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        dismiss(animated: true, completion: nil)
    }
}
    


