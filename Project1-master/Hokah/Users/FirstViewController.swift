//
//  FirstViewController.swift
//  Hokah
//
//  Created by Саша Руцман on 30.01.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase
class FirstViewController: UIViewController {
    
    var infoDB = Array<InfoDB>()
    var users = Array<UserDB>()
    var users1: Array<UserDB>!
    var tobaccos = Array<TobaccoDB>()
    var tastes = Array<TasteDB>()
    var teaTastes = Array<TeaDB>()
    var ref: DatabaseReference!
    let container: UIView = UIView()
    let loadingView: UIView = UIView()
    var infoPhoto: UIImage?
    var tobaccoPhotos: [String: UIImage] = [:]
    var tastePhotos: [String: UIImage] = [:]
    var hookahs = Array<HookahDB>()
    var curUserOrders = Array<OrderDB>()
    var allOrders = Array<OrderDB>()
    var menuBarIsVisible = false
    var todayOrders: [String: Array<String>] = [:]
    

    @IBOutlet var leadingC: NSLayoutConstraint!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var defaultTobaccoImage: UIImageView!
    @IBOutlet weak var signOutButton: UIView!
    @IBOutlet weak var chooseHookahButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "<Кальянная>"
        //if Auth.auth().currentUser!.uid == "9v3ziIPm9hWZW3IvasRw904xd2d2" {
            loadUsersAndAllOrders()
        //}
        
        activityIndicatorSettings()
        getInfo()
        loadTobaccos()
        loadOrders()
        loadTeaTastes()
        swipesObserves()
        
    }
    
    private func getTodayOrders() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        
        var ordersTime = Array<String>()
        for order in allOrders {
            
            let orderId = order.identifier
            let orderDate = orderId.split(separator: " ")
            if dateString == orderDate[0] && order.tableNumber == 1 { //Получаю число, месяц, год
                ordersTime.append(orderDate[1] + " - " + order.timeTill + ", ")
                todayOrders.updateValue(ordersTime, forKey: "1")
            } else if dateString == orderDate[0] && order.tableNumber == 2 { //Получаю число, месяц, год
                ordersTime.append(orderDate[1] + " - " + order.timeTill + ", ")
                todayOrders.updateValue(ordersTime, forKey: "2")
            } else if dateString == orderDate[0] && order.tableNumber == 3 { //Получаю число, месяц, год
                ordersTime.append(orderDate[1] + " - " + order.timeTill + ", ")
                todayOrders.updateValue(ordersTime, forKey: "3")
            }
        }
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
                        if Auth.auth().currentUser!.uid == "9v3ziIPm9hWZW3IvasRw904xd2d2" {
                            self!.performSegue(withIdentifier: "toSettings", sender: nil)
                        }
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
                    self?.getTodayOrders()
                   
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
                for tobacco in (self?.tobaccos)! {
                    //print(tobacco.name)
                    let reference = Storage.storage().reference(withPath: "tobaccosImage/\(tobacco.imageName).png")
                    reference.getData(maxSize: (1 * 1772 * 2362)) { (data, error) in
                        if let _error = error{
                            //print("ОШИБКА табаки")
                            //print(_error)
                        } else {
                            if let _data  = data {
                                self!.tobaccoPhotos.updateValue(UIImage(data: _data)!, forKey: tobacco.name)
                                print("фото табака загружены")
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
                                        print("Загружено фото вкусов")
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
    
    private func loadTeaTastes() {
        ref = Database.database().reference().child("tea")
        ref.observe(.value, with: { [weak self] (snapshot) in
            var _teaTastes = Array<TeaDB>()
            for i in snapshot.children{
                let teaTaste = TeaDB(snapshot: i as! DataSnapshot)
                if teaTaste.isAvailable == true {
                    _teaTastes.append(teaTaste)
                }
            }
            self?.teaTastes = _teaTastes
            }
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSettings" {
            
            guard let admin = segue.destination as? AdminViewController else {return}
            admin.infoDB = infoDB
            admin.users = users
            admin.infoPhoto = infoPhoto
            admin.tobaccoPhotos = tobaccoPhotos
            admin.tobaccos = tobaccos
            admin.tastePhotos = tastePhotos
            admin.tastes = tastes
            admin.curUserOrders = curUserOrders
            admin.allOrders = allOrders
            admin.teaTastes = teaTastes
            
        } else if segue.identifier == "chooseHookah" {
            guard let hookah = segue.destination as? ViewController else { return }
            hookah.tobaccos = tobaccos
            hookah.tobaccoPhotos = tobaccoPhotos
            hookah.tastePhotos = tastePhotos
            hookah.teaTastes = teaTastes
            hookah.tastes = tastes
            hookah.allOrders = allOrders
            hookah.todayOrders = todayOrders
            
        } else if segue.identifier == "currentUserOrders" {
            guard let orders = segue.destination as? CurUserOrdersTableViewController else {return}
            orders.orders = curUserOrders
        } else if segue.identifier == "getInfo" {
            guard let info = segue.destination as? InformationViewController else { return }
            info.infoDB = infoDB
            info.infoPhoto = infoPhoto
        }
    }
    
    private func activityIndicatorSettings() {
        
        chooseHookahButton.isHidden = true
        defaultTobaccoImage.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "smoke.jpg")!)
        
        container.frame = view.frame
        container.center = view.center
        container.backgroundColor = UIColor(patternImage: UIImage(named: "smoke.jpg")!)
        
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
        chooseHookahButton.isHidden = false
        defaultTobaccoImage.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    

    @IBAction func settingsButtonPressed(_ sender: UIButton) {
    }
    
    
    


    

    @IBAction func signOutPressed(_ sender: UIButton) {
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func swipesObserves() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(sideMenuSwipped(gesture:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(sideMenuSwipped(gesture:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    @objc func sideMenuSwipped(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .right:
            if !menuBarIsVisible {
                leadingC.constant = 250
                menuBarIsVisible = true
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        case .left:
            if menuBarIsVisible {
                leadingC.constant = 0
                menuBarIsVisible = false
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        default:
            return
        }
    }
    
    @IBAction func sideMenuButtonTapped(_ sender: Any) {
        if menuBarIsVisible {
            leadingC.constant = 0
            menuBarIsVisible = false
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    
    @IBAction func sideMenuTapped(_ sender: Any) {
        if !menuBarIsVisible {
            leadingC.constant = 250
            
            menuBarIsVisible = true
        } else {
            leadingC.constant = 0
            
            menuBarIsVisible = false
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    
    
    
    
}





