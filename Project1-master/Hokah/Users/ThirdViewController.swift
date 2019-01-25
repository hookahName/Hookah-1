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

    // MARK: Properties
    
    var selectedTabacoo: TobaccoDB?
    var table: Int?
    var tastes = Array<TasteDB>()
    var teaTastes = Array<TasteDB>()
    var ref: DatabaseReference!
    var selectedTastes = [TasteDB]()
    
    @IBOutlet weak var readyBut: UIBarButtonItem!
    
    // MARK: View settings
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let selectedTabacoo = selectedTabacoo else { return }
        title = "\(String(describing: selectedTabacoo))"
        tableView.tableFooterView = UIView()
        
        self.refreshControl = UIRefreshControl()
        //self.refreshControl?.bounds = CGRect(x: 0, y: 50, width: (refreshControl?.bounds.size.width)!, height: (refreshControl?.bounds.size.height)!)
        self.refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        
        ref = Database.database().reference().child("tea")
        ref.observe(.value, with: { [weak self] (snapshot) in
            var _teaTastes = Array<TasteDB>()
            for i in snapshot.children{
                let teaTaste = TasteDB(snapshot: i as! DataSnapshot)
                if teaTaste.isAvailable == true{
                    _teaTastes.append(teaTaste)
                }
            }
            self?.teaTastes = _teaTastes
            
            }
        )
        self.readyBut.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDatabase()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ref.removeAllObservers()
    }
    
    // MARK: Table view settings
    
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
                if let index = selectedTastes.firstIndex(where: {$0.name == cell.textLabel?.text}) {
                    selectedTastes.remove(at: index)
                }
            } else {
                cell.accessoryType = .checkmark
                selectedTastes.append(tastes[indexPath.row])
            }
        }
        if selectedTastes.count > 0 {
            self.readyBut.isEnabled = true
        } else {
            self.readyBut.isEnabled = false
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let cell = tableView.cellForRow(at: indexPath) else {return nil}
        if cell.selectionStyle == .none {
            return nil
        }
        return indexPath
    }
    
    // MARK: Private functions
    
    @IBAction func readyButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToTime" {
            guard let timeController = segue.destination as? ChooseTimeViewController else {return}
            timeController.selectedTable = table
            timeController.selectedTabacoo = selectedTabacoo
            timeController.selectedFlavour = selectedTastes
            timeController.teaTastes = teaTastes
        }
    }
    
    private func loadDatabase() {
        ref = Database.database().reference().child("tobaccos").child((self.selectedTabacoo!.name)).child("tastes")
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
    
    @objc func refresh(_ sender: AnyObject) {
        loadDatabase()
        self.refreshControl?.endRefreshing()
    }
}
