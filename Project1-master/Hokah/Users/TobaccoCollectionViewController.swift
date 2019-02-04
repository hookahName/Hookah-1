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
    var hookahs = Array<HookahDB>()
    var teaTastes = Array<TeaDB>()
    var tastes = Array<TasteDB>()
    var tobaccoPhotos: [String: UIImage] = [:]
    var tastePhotos: [String: UIImage] = [:]
    var todayOrders: [String: Array<String>] = [:]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDatabase()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Выберите табак"
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

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.layer.borderColor = UIColor.blue.cgColor
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TobaccoCellClass
        
//        let reference = Storage.storage().reference(withPath: "tobaccosImage/\(tobaccos[indexPath.row].imageName).png")
//        reference.getData(maxSize: (1 * 1772 * 2362)) { (data, error) in
//            if let _error = error{
//                print("ОШИБКА")
//                print(_error)
//            } else {
//                print("Загружено")
//                if let _data  = data {
//                    cell.tobaccoViewImage.image = UIImage(data: _data)
//                }
//            }
//        }
        
        cell.tobaccoNameLabel.text = tobaccos[indexPath.row].name
        cell.tobaccoPriceLabel.text = tobaccos[indexPath.row].price  + "Руб."
        cell.tobaccoViewImage.image = tobaccoPhotos[tobaccos[indexPath.row].name]
        cell.layer.borderWidth = CGFloat(1)
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.cornerRadius = 8
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTobaccoTastes" {
            guard let indexPath = collectionView.indexPath(for: sender as! UICollectionViewCell) else {return}
            guard let dvc = segue.destination as? TastesCollectionViewController else {return}
            dvc.table = selectedTable
            dvc.selectedTobacco = tobaccos[indexPath.row]
            dvc.hookahs = hookahs
            dvc.tastePhotos = tastePhotos
            dvc.teaTastes = teaTastes
            dvc.tastes = tastes
            dvc.todayOrders = todayOrders
            print(" TOBACCO = \(hookahs.count)")

        }
    }

    
    private func loadDatabase() {
        ref = Database.database().reference().child("tobaccos")
        ref.observe(.value, with: {[weak self] (snapshot) in
            var _tobaccos = Array<TobaccoDB>()
            for item in snapshot.children {
                let tobacco = TobaccoDB(snapshot: item as! DataSnapshot)
                if tobacco.isAvailable {
                    _tobaccos.append(tobacco)
                }
                
            }
            self?.tobaccos = _tobaccos
            self?.collectionView.reloadData()
        })
    }
    
    @IBAction func unwindSegueToExtraHookah(_ segue: UIStoryboardSegue) {
        guard let svc = segue.source as? Result else {return}
        hookahs = svc.hookahs
    }
}
