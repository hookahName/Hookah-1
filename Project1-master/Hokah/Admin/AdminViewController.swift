//
//  AdminViewController.swift
//  Hokah
//
//  Created by Саша Руцман on 21.01.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class AdminViewController: UIViewController {

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
            guard let admin = segue.destination as? ChangeTeaTasteTableViewController else {return}
        }
    }

}
