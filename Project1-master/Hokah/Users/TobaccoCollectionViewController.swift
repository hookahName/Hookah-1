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
        loadDatabase()
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
        cell.tobaccoViewImage.image = UIImage(named: "defaultTobacco")
        
        cell.layer.borderWidth = CGFloat(1)
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.cornerRadius = 8
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTobaccoTastes" {
            guard let indexPath = collectionView.indexPath(for: sender as! UICollectionViewCell) else {return}
            guard let dvc = segue.destination as? TastesCollectionViewController else {return}
            dvc.table = selectedTable
            dvc.selectedTobacco = tobaccos[indexPath.row]
        }
    }

    
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
}