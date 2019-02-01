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
    
    // MARK: View settings

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Выберите столик"
        tableView.tableFooterView = UIView()
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
        
        return cell
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
            
            if let indexPath = tableView.indexPathForSelectedRow {
                tobaco.selectedTable = indexPath.row + 1
            }
        }
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "Admin", sender: self)
    }
}

