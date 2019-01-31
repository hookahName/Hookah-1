//
//  AdminViewController.swift
//  Hokah
//
//  Created by Саша Руцман on 21.01.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase

class AdminViewController: UIViewController {
    
    // MARK: Properties
    var infoDB = Array<InfoDB>()
    var users = Array<UserDB>()
    var tobaccos = Array<TobaccoDB>()
    var tastes = Array<TasteDB>()
    var curUserOrders = Array<OrderDB>()
    var teaTastes = Array<TeaDB>()
    var allOrders = Array<OrderDB>()
    var ref: DatabaseReference!
    var infoPhoto: UIImage?
    var tobaccoPhotos: [String: UIImage]?
    var tastePhotos: [String: UIImage] = [:]
    let container: UIView = UIView()
    let loadingView: UIView = UIView()
    @IBOutlet weak var changeTobAndTastesButton: UIButton!
    @IBOutlet weak var changeTeaTastesButton: UIButton!
    @IBOutlet weak var allOrdersButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: View settings
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backBtn = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backBtn
        title = "Админ"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    // MARK: Private functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChangeTobacco" {
            guard let changeTobacco = segue.destination as? AdminTableViewController else {return}
            changeTobacco.tobaccos = tobaccos
            changeTobacco.tobaccoPhotos = tobaccoPhotos
            changeTobacco.tastePhotos = tastePhotos
            changeTobacco.tastes = tastes
        } else if segue.identifier == "TeaTaste" {
            guard let tea = segue.destination as? ChangeTeaTasteTableViewController else {return}
            tea.teaTastes = teaTastes
        } else if segue.identifier == "toOrders" {
            guard let orders = segue.destination as? OrdersTableViewController else {return}
            
            orders.users = self.users
            orders.orders = allOrders
        } else if segue.identifier == "CurUserOrders" {
            guard let curUserOrd = segue.destination as? CurUserOrdersTableViewController else { return }
            curUserOrd.orders = curUserOrders
        } else if segue.identifier == "toInfo" {
            guard let infoVC = segue.destination as? InformationViewController else { return }
            infoVC.infoDB = infoDB
            infoVC.infoPhoto = infoPhoto
            infoVC.users = users
        } else if segue.identifier == "toClient" {
            guard let client = segue.destination as? ViewController else { return }
            client.tobaccos = tobaccos
            client.tobaccoPhotos = tobaccoPhotos!
            client.tastePhotos = tastePhotos
            client.teaTastes = teaTastes
            client.tastes = tastes
        }
    }
    
    
    @IBAction func ordersButtonPressed(_ sender: Any) {
    }
    
    
    @IBAction func curUserOrdersButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "CurUserOrders", sender: nil)
    }
    
    
    @IBAction func infoButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toInfo", sender: nil)
    }
    
    
    @IBAction func signOut(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        if let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "login") as! EnterViewController
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    @IBAction func clientViewPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        activityIndicatorSettings()
        loadOrders()
        loadTobaccos()
        loadUsersAndAllOrders()
        getInfo()
    }
    
    private func getInfo() {
        
        ref = Database.database().reference().child("info")
        ref.observe(.value, with: { [weak self] (snapshot) in
            //self!.activityIndicatorSettings()
            var _infoDB = Array<InfoDB>()
            for item in snapshot.children {
                let information = InfoDB(snapshot: item as! DataSnapshot)
                _infoDB.append(information)
            }
            self?.infoDB = _infoDB
            //print("инфа загружена")
            let reference = Storage.storage().reference(withPath: "infoImage/\(self!.infoDB[0].imageName).png")
            reference.getData(maxSize: (1 * 1772 * 2362)) { (data, error) in
                if let _error = error{
                    //print("ОШИБКА")
                    //print(_error)
                } else {
                    if let _data  = data {
                        self!.infoPhoto = UIImage(data: _data)
                        self?.activityIndicatorStopped()
                        //print("фото инфы загружено")
                    }
                }
            }
        })
        
        
    }
    
    private func loadUsersAndAllOrders() {
        
        ref = Database.database().reference().child("users")
        ref.observe(.value, with: { [weak self] (snapshot) in
            //self!.activityIndicatorSettings()
            var _users = Array<UserDB>()
            for item in snapshot.children {
                let user = UserDB(snapshot: item as! DataSnapshot)
                _users.append(user)
            }
            self?.users = _users
            //print("Юзеры загружены")
            self!.ref = Database.database().reference().child("users")
            var _orders = Array<OrderDB>()
            for user in self!.users {
                self!.ref.child(user.userId).child("orders").observe(.value, with: {[weak self] (snapshot) in
                    for item in snapshot.children {
                        let order = OrderDB(snapshot: item as! DataSnapshot)
                        _orders.append(order)
                    }
                    self?.allOrders = _orders
                })
                
                //orders = _orders
                //tableView.reloadData()
            }
            
        })
    }
    
    private func loadOrders() {
        ref = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("orders")
        ref.observe(.value) { [weak self] (snapshot) in
            var _orders = Array<OrderDB>()
            for item in snapshot.children {
                let order = OrderDB(snapshot: item as! DataSnapshot)
                _orders.append(order)
            }
            self?.curUserOrders = _orders
            //print("Заказы загружены")
        }
    }
    
    
    
    private func loadTobaccos() {
        ref = Database.database().reference().child("tobaccos")
        ref.observe(.value, with: { [weak self] (snapshot) in
            var _tobaccos = Array<TobaccoDB>()
            for item in snapshot.children {
                let tobacco = TobaccoDB(snapshot: item as! DataSnapshot)
                _tobaccos.append(tobacco)
            }
            
            self?.tobaccos = _tobaccos
            if (self?.tobaccos.count)! > 0 {
                var _tobaccoPhotos: [String: UIImage] = [:]
                for tobacco in (self?.tobaccos)! {
                    //print(tobacco.name)
                    let reference = Storage.storage().reference(withPath: "tobaccosImage/\(tobacco.imageName).png")
                    reference.getData(maxSize: (1 * 1772 * 2362)) { (data, error) in
                        if let _error = error{
                            //print("ОШИБКА табаки")
                            //print(_error)
                        } else {
                            if let _data  = data {
                                
                                
                                
                                self?.tobaccoPhotos?.updateValue(UIImage(data: _data)!, forKey: tobacco.name)
                                //print("фото табака загружены")
                            }
                        }
                    }
                    self!.ref = Database.database().reference().child("tobaccos").child((tobacco.name.lowercased())).child("tastes")
                    self!.ref.observe(.value, with: { [weak self] (snapshot) in
                        var _tastes = Array<TasteDB>()
                        for i in snapshot.children{
                            let taste = TasteDB(snapshot: i as! DataSnapshot)
                            _tastes.append(taste)
                            //print(taste)
                            
                        }
                        self?.tastes = _tastes
                        for taste in (self?.tastes)! {
                            let reference = Storage.storage().reference(withPath: "tastesImage/\(taste.imageName).png")
                            reference.getData(maxSize: (1 * 1772 * 2362)) { (data, error) in
                                if let _error = error{
                                    //print("ОШИБКА вкусы")
                                    //print(_error)
                                } else {
                                    
                                    if let _data  = data {
                                        self!.tastePhotos.updateValue(UIImage(data: _data)!, forKey: "\(tobacco.name)+\(taste.name)")
                                        //print(Array((self?.tastePhotos)!)[0].key)
                                        //print("Загружено фото вкусов")
                                    }
                                }
                            }
                        }
                        
                    })
                }
                
                
                //print(Array((self?.tobaccoPhotos!)!)[0].key)
            } else {
                print("gg")
            }
            
            
            
        })
    }
    

    
    private func activityIndicatorSettings() {
        
        
        container.frame = view.frame
        container.center = view.center
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = view.center
        loadingView.layer.cornerRadius = 10
        loadingView.backgroundColor =  #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style =
            UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        view.addSubview(container)
        
        activityIndicator.isHidden = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        activityIndicator.startAnimating()
        
    }
    
    private func activityIndicatorStopped() {
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
        loadingView.removeFromSuperview()

    }
}
    


