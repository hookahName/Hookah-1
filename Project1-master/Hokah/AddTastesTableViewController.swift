//
//  AddTastesTableViewController.swift
//  Hokah
//
//  Created by Саша Руцман on 20.01.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase
class AddTastesTableViewController: UITableViewController {
    
    var chosenTobacco: TobaccoDB?
    var ref: DatabaseReference!
    var tastes = Array<TasteDB>()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let chosenTobacco = chosenTobacco {
            title = chosenTobacco.name
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let chosenTobacco = chosenTobacco else {return}
        ref = Database.database().reference().child("tobaccos").child((chosenTobacco.name.lowercased())).child("tastes")
        ref.observe(.value, with: { [weak self] (snapshot) in
            var _tastes = Array<TasteDB>()
            for i in snapshot.children{
                let taste = TasteDB(snapshot: i as! DataSnapshot)
                _tastes.append(taste)
                print(taste)
                
            }
            self?.tastes = _tastes
            self?.tableView.reloadData()
        })
        
    }
    // MARK: - Table view data source
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        getAvailabilityOfTobacco()
        ref.removeAllObservers()
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasteCell", for: indexPath)
        cell.textLabel?.text = tastes[indexPath.row].name
        
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(tastes[indexPath.row].isAvailable, animated: true)
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        cell.accessoryView = switchView
        
        return cell
    }
    
    @objc func switchChanged(_ sender: UISwitch!) {
        tastes[sender.tag].isAvailable = !tastes[sender.tag].isAvailable
        updateDatabase(tastes[sender.tag])
    }
    
    func updateDatabase(_ taste: TasteDB) {
        ref = Database.database().reference()
        ref.child("tobaccos").child(chosenTobacco!.name).child("tastes").child(taste.name).updateChildValues(["name": taste.name, "isAvailable": taste.isAvailable])
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tastes.count
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        ref = Database.database().reference()
        let alertController = UIAlertController(title: "New taste", message: "Add new taste", preferredStyle: .alert)
        alertController.addTextField()
        let save = UIAlertAction(title: "Save", style: .default) { [ weak self] _ in
            
            guard let textField = alertController.textFields?.first, textField.text != "" else {return}
            let taste = TasteDB(name: textField.text!)
            let tasteRef = self?.ref.child("tobaccos").child(((self?.chosenTobacco!.name.lowercased())!)).child("tastes").child((taste?.name.lowercased())!)
            tasteRef?.setValue(taste!.convertToDictionary())
            //self?.tobaccos.append(tabaco!)
            //self?.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        
        alertController.addAction(save)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
    private func getAvailabilityOfTobacco() {
        ref = Database.database().reference()
        var isAvailable: Bool = false
        
        if tastes.count > 0 {
            for taste in tastes {
                if taste.isAvailable {
                    isAvailable = true
                    break
                }
            }
            chosenTobacco?.isAvailable = isAvailable
            ref.child("tobaccos").child(chosenTobacco!.name).updateChildValues(["name":chosenTobacco!.name, "isAvailable": chosenTobacco!.isAvailable])
        } else {
            chosenTobacco?.isAvailable = isAvailable
            ref.child("tobaccos").child(chosenTobacco!.name).updateChildValues(["name":chosenTobacco!.name, "isAvailable": chosenTobacco!.isAvailable])
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
