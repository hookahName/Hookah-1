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
    var tobaccos = Array<TobaccoDB>()
    var ref: DatabaseReference!
    var infoPhoto: UIImage?
    var tobaccoPhotos: [String: UIImage]?
    var tastePhotos: [String: UIImage] = [:]
    @IBOutlet weak var changeTobAndTastesButton: UIButton!
    @IBOutlet weak var changeTeaTastesButton: UIButton!
    @IBOutlet weak var allOrdersButton: UIButton!
    @IBOutlet weak var curUserOrdersButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    // MARK: View settings
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if Auth.auth().currentUser?.uid != "9v3ziIPm9hWZW3IvasRw904xd2d2" {
            changeTeaTastesButton.isHidden = true
            changeTobAndTastesButton.isHidden = true
            allOrdersButton.isHidden = true
        } else {
            title = "Админ"
        }
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    // MARK: Private functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChangeTobacco" {
            guard let changeTobacco = segue.destination as? AdminTableViewController else {return}
            changeTobacco.tobaccos = tobaccos
            changeTobacco.tobaccoPhotos = tobaccoPhotos
            changeTobacco.tastePhotos = tastePhotos
        } else if segue.identifier == "TeaTaste" {
            guard segue.destination is ChangeTeaTasteTableViewController else {return}
        } else if segue.identifier == "toOrders" {
            guard let users = segue.destination as? OrdersTableViewController else {return}
            users.users = self.users
        } else if segue.identifier == "CurUserOrders" {
            guard segue.destination is CurUserOrdersTableViewController else { return }
        } else if segue.identifier == "toInfo" {
            guard let infoVC = segue.destination as? InformationViewController else { return }
            infoVC.infoDB = infoDB
            infoVC.infoPhoto = infoPhoto
            infoVC.users = users
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
    
    
    @IBAction func curUserOrdersButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "CurUserOrders", sender: nil)
    }
    
    
    @IBAction func infoButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toInfo", sender: nil)
    }
    
}
    


