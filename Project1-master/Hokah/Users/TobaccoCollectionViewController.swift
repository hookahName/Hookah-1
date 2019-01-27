//
//  TobaccoCollectionViewController.swift
//  Hokah
//
//  Created by Кирилл Иванов on 27/01/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Tobacco"

class TobaccoCollectionViewController: UICollectionViewController, UINavigationControllerDelegate {

    var ref: DatabaseReference!
    var tobaccos = Array<TobaccoDB>()
    var selectedTable: Int?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //loadDatabase()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Choose tobacco"
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //ref.removeAllObservers()
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tobaccos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TobaccoCellClass
        
        cell.tobaccoNameLabel.text = tobaccos[indexPath.row].name
        cell.tobaccoPriceLabel.text = tobaccos[indexPath.row].price
        cell.tobaccoViewImage.image = UIImage(named: "defaultImage")
        
        cell.layer.borderWidth = CGFloat(1)
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.cornerRadius = 8
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTobaccoTastes" {
            guard let indexPath = collectionView.indexPath(for: sender as! UICollectionViewCell) else {return}
            guard let dvc = segue.destination as? ThirdViewController else {return}
            dvc.table = selectedTable
            dvc.selectedTabacoo = tobaccos[indexPath.row]
        }
    }
 
    /*
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toTobaccoTastes", sender: self)
    }
 */
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    /*
    private func loadDatabase() {
        ref = Database.database().reference().child("tobaccos")
        ref.observe(.value, with: {[weak self] (snapshot) in
            var _tobaccos = Array<TobaccoDB>()
            for item in snapshot.children {
                let tobacco = TobaccoDB(snapshot: item as! DataSnapshot)
                _tobaccos.append(tobacco)
            }
            self?.tobaccos = _tobaccos
            self?.collectionView.reloadData()
        })
    }
 */
}
