//
//  ViewController.swift
//  Hokah
//
//  Created by Кирилл Иванов on 06/01/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UINavigationBarDelegate {
    
    // MARK: Properties
    
    let tables = ["Table 1", "Table 2", "Table 3"]
    var tobaccos = Array<TobaccoDB>()
    //var tobaccos = Array<TobaccoDB>()
    var tobaccoPhotos: [String: UIImage] = [:]
    var tastePhotos: [String: UIImage] = [:]
    var teaTastes = Array<TeaDB>()
    var tastes = Array<TasteDB>()
    var allOrders = Array<OrderDB>()
    var todayOrders: [String: Array<String>] = [:]
    
    // MARK: View settings

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Выберите столик"
        tableView.tableFooterView = UIView()
        print(todayOrders.count)
        
    }
    
    // MARK: Table view settings
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tables.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Table", for: indexPath)
        
        cell.textLabel?.text = tables[indexPath.row]
        cell.detailTextLabel?.numberOfLines = 0
        
        switch cell.textLabel!.text  {
        case "Table 1": cell.detailTextLabel?.text = getBusyTime(tableNumber: "1")
        case "Table 2": cell.detailTextLabel?.text = getBusyTime(tableNumber: "2")
        case "Table 3": cell.detailTextLabel?.text = getBusyTime(tableNumber: "3")
        default : cell.detailTextLabel!.text = "Свободно"
        }
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true;
        //cell.detailTextLabel?.lineBreakMode = NSLineBreakMode.byTruncatingTail
        
        return cell
    }
    
    func getBusyTime(tableNumber: String) -> String {
        var busyTime: String = "Занято: "
        if todayOrders[tableNumber]?.isEmpty == false {
            for time in todayOrders[tableNumber]! {
                busyTime += time
            }
        }
        busyTime.remove(at: busyTime.index(before: busyTime.endIndex))
        busyTime.remove(at: busyTime.index(before: busyTime.endIndex))
        return busyTime
    }
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    // MARK: Private functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tobacco" {
            guard let tobaco = segue.destination as? TobaccoCollectionViewController else {return}
            //tobaco.tobaccos = tobaccos
            //print(tobaco.tobaccos)
            tobaco.tobaccoPhotos = tobaccoPhotos
            tobaco.tobaccos = tobaccos
            tobaco.tastePhotos = tastePhotos
            tobaco.tastes = tastes
            tobaco.teaTastes = teaTastes
            tobaco.todayOrders = todayOrders
            
            if let indexPath = tableView.indexPathForSelectedRow {
                tobaco.selectedTable = indexPath.row + 1
            }
        }
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "Admin", sender: self)
    }
}

