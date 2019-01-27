//
//  TastesCollectionViewController.swift
//  Hokah
//
//  Created by Кирилл Иванов on 27/01/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "TasteCell"

class TastesCollectionViewController: UICollectionViewController {

    var ref: DatabaseReference!
    var tastes = Array<TasteDB>()
    var selectedTastes = Array<String>()
    var table: Int?
    var selectedTobacco: TobaccoDB?
    var teaTastes = Array<TeaDB>()
    var readyButton = UIBarButtonItem()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref = Database.database().reference().child("tobaccos").child((selectedTobacco?.name)!).child("tastes")
        ref.observe(.value, with: {[weak self] (snapshot) in
            var _tastes = Array<TasteDB>()
            for item in snapshot.children{
                let taste = TasteDB(snapshot: item as! DataSnapshot)
                _tastes.append(taste)
            }
            self?.tastes = _tastes
            self?.collectionView.reloadData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readyButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(readyButtonPressed))
        readyButton.title = "Готово"
        readyButton.isEnabled = false
        self.navigationItem.rightBarButtonItem = readyButton
        
        title = selectedTobacco?.name
        ref = Database.database().reference().child("tea")
        ref.observe(.value, with: { [weak self] (snapshot) in
            var _teaTastes = Array<TeaDB>()
            for i in snapshot.children{
                let teaTaste = TeaDB(snapshot: i as! DataSnapshot)
                if teaTaste.isAvailable == true{
                    _teaTastes.append(teaTaste)
                }
            }
            self?.teaTastes = _teaTastes
            }
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ref.removeAllObservers()
    }
   
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tastes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TasteCellClass
        cell.layer.borderWidth = CGFloat(1)
        cell.layer.cornerRadius = 8
        //cell.tasteImageView.image = UIImage(named: "defaultTaste")
        cell.tasteNameLabel.text = tastes[indexPath.row].name
        
        if selectedTastes.contains(tastes[indexPath.row].name) {
            cell.layer.borderColor = UIColor.blue.cgColor
        } else {
            cell.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {return}
        let taste = tastes[indexPath.row]
        if selectedTastes.contains(taste.name) {
            guard let index = selectedTastes.firstIndex(where: {$0 == taste.name}) else {return}
            selectedTastes.remove(at: index)
            cell.layer.borderColor = UIColor.lightGray.cgColor
        } else {
            selectedTastes.append(taste.name)
            cell.layer.borderColor = UIColor.blue.cgColor
        }
        if selectedTastes.isEmpty {
            readyButton.isEnabled = false
        } else {
            readyButton.isEnabled = true
        }
    }
    
    @objc func readyButtonPressed() {
        performSegue(withIdentifier: "toTime", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTime" {
            guard let dvc = segue.destination as? ChooseTimeViewController else {return}
            dvc.selectedTable = table
            dvc.selectedTabacoo = selectedTobacco
            dvc.selectedFlavour = selectedTastes
            dvc.teaTastes = teaTastes
        }
    }
}
