//
//  ThirdViewController.swift
//  Hokah
//
//  Created by Кирилл Иванов on 06/01/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import os.log
import Firebase
class ThirdViewController: UITableViewController, UINavigationControllerDelegate {

    var selectedTabacoo: String?
    var table: Int?
    var tastes = Array<TasteDB>()
    var ref: DatabaseReference!
    var selectedTastes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let selectedTabacoo = selectedTabacoo else { return }
        title = "\(String(describing: selectedTabacoo))"
        tableView.tableFooterView = UIView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref = Database.database().reference().child("tobaccos").child((self.selectedTabacoo!.lowercased())).child("tastes")
        ref.observe(.value, with: { [weak self] (snapshot) in
            var _tastes = Array<TasteDB>()
            for i in snapshot.children{
                let taste = TasteDB(snapshot: i as! DataSnapshot)
                if taste.isAvailable == true{
                    _tastes.append(taste)
                    print(taste)
                }
            }
            self?.tastes = _tastes
            self?.tableView.reloadData()
        }
        )
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tastes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Flavour", for: indexPath)
        cell.textLabel?.text = tastes[indexPath.row].name
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                if let index = selectedTastes.firstIndex(of: tastes[indexPath.row].name) {
                    selectedTastes.remove(at: index)
                }
            } else {
                cell.accessoryType = .checkmark
                selectedTastes.append(tastes[indexPath.row].name)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let cell = tableView.cellForRow(at: indexPath) else {return nil}
        if cell.selectionStyle == .none {
            return nil
        }
        return indexPath
    }
    
    @IBAction func ReadyButtonPressed(_ sender: UIBarButtonItem) {
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToTime" {
            guard let timeController = segue.destination as? ChooseTimeViewController else {return}
            timeController.selectedTable = table
            timeController.selectedTabacoo = selectedTabacoo
            timeController.selectedFlavour = selectedTastes
        }
    }
}