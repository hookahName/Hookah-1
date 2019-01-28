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
    var infoDB = Array<InfoDB>()
    var users = Array<UserDB>()
    var ref: DatabaseReference!
    @IBOutlet weak var changeTobAndTastesButton: UIButton!
    @IBOutlet weak var changeTeaTastesButton: UIButton!
    @IBOutlet weak var allOrdersButton: UIButton!
    @IBOutlet weak var curUserOrdersButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
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
        
        ref = Database.database().reference().child("info")
        ref.observe(.value, with: { [weak self] (snapshot) in
            var _infoDB = Array<InfoDB>()
            print("ee")
            for item in snapshot.children {
                print("qq")
                let information = InfoDB(snapshot: item as! DataSnapshot)
                _infoDB.append(information)
            }
            self?.infoDB = _infoDB
        })
        
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
        } else if segue.identifier == "toInfo" {
            if infoDB.count == 0 {
                print("=0")
                
            } else {
                print("SUKA")
            }
            guard let infoVC = segue.destination as? InformationViewController else { return }
            infoVC.infoDB = infoDB
        }
    }
    
    @IBAction func changePassButtonPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "login") as! EnterViewController
            self.present(vc, animated: false, completion: nil)
        }
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
    
    
    @IBAction func infoButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toInfo", sender: nil)
    }
    
}
    


