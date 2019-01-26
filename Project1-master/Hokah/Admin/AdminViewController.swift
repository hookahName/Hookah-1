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
    var users = Array<UserDB>()
    var ref: DatabaseReference!
    @IBOutlet weak var changeTobAndTastesButton: UIButton!
    @IBOutlet weak var changeTeaTastesButton: UIButton!
    @IBOutlet weak var allOrdersButton: UIButton!
    @IBOutlet weak var curUserOrdersButton: UIButton!
    
    // MARK: View settings
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUsers()
        
        if Auth.auth().currentUser?.uid != "gHPSmMsKb0PNsLgQHYh35l4tJWj1" {
            changeTeaTastesButton.isHidden = true
            changeTobAndTastesButton.isHidden = true
            allOrdersButton.isHidden = true
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
        } else if segue.identifier == "toOrders" {
            guard let users = segue.destination as? OrdersTableViewController else {return}
            users.users = self.users
        } else if segue.identifier == "CurUserOrders" {
            guard segue.destination is CurUserOrdersTableViewController else { return }
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
    
    @IBAction func ordersButtonPressed(_ sender: Any) {
    }
    
    private func loadUsers() {
        ref = Database.database().reference().child("users")
        ref.observe(.value, with: { [weak self] (snapshot) in
            var _users = Array<UserDB>()
            for item in snapshot.children {
                let user = UserDB(snapshot: item as! DataSnapshot)
                _users.append(user)
            }
            self?.users = _users
        })
    }
    
    @IBAction func curUserOrdersButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "CurUserOrders", sender: nil)
    }
    
}
    


