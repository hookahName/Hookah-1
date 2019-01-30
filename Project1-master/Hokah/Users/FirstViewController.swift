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
    var tobaccos = Array<TobaccoDB>()
    var ref: DatabaseReference!
    let container: UIView = UIView()
    let loadingView: UIView = UIView()
    var infoPhoto: UIImage?
    var tobaccoPhotos: [String: UIImage] = [:]

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var chooseHookahButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorSettings()
        getInfo()
        loadUsers()
        loadTobaccos()
        // Do any additional setup after loading the view.
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
            print("инфа загружена")
            let reference = Storage.storage().reference(withPath: "infoImage/\(self!.infoDB[0].imageName).png")
            reference.getData(maxSize: (1 * 1772 * 2362)) { (data, error) in
                if let _error = error{
                    print("ОШИБКА")
                    print(_error)
                } else {
                    if let _data  = data {
                        self!.infoPhoto = UIImage(data: _data)
                        self?.activityIndicatorStopped()
                        print("фото инфы загружено")
                    }
                }
            }
        })
        
        
    }
    
    private func loadUsers() {
        
        ref = Database.database().reference().child("users")
        ref.observe(.value, with: { [weak self] (snapshot) in
            //self!.activityIndicatorSettings()
            var _users = Array<UserDB>()
            for item in snapshot.children {
                let user = UserDB(snapshot: item as! DataSnapshot)
                _users.append(user)
            }
            self?.users = _users
            
            print("Юзеры загружены")
        })
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
                    print(tobacco.name)
                    let reference = Storage.storage().reference(withPath: "tobaccosImage/\(tobacco.imageName).png")
                    reference.getData(maxSize: (1 * 1772 * 2362)) { (data, error) in
                        if let _error = error{
                            print("ОШИБКА")
                            print(_error)
                        } else {
                            print("Загружено")
                            if let _data  = data {
                                self!.tobaccoPhotos.updateValue(UIImage(data: _data)!, forKey: tobacco.name)
                                print("фото табака загружены")
                            }
                        }
                    }
                }
                
                //print(Array((self?.tobaccoPhotos!)!)[0].key)
            } else {
                print("gg")
            }
            
            
            
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSettings" {
            
            guard let admin = segue.destination as? AdminViewController else {return}
            admin.infoDB = infoDB
            admin.users = users
            admin.infoPhoto = infoPhoto
            admin.tobaccoPhotos = tobaccoPhotos
            admin.tobaccos = tobaccos
            
        } else if segue.identifier == "chooseHookah" {
            guard let hookah = segue.destination as? ViewController else { return }
            hookah.tobaccos = tobaccos
            hookah.tobaccoPhotos = tobaccoPhotos
        }
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
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
        loadingView.removeFromSuperview()
    }
    
    
    

    @IBAction func settingsButtonPressed(_ sender: UIButton) {
    }
    
    
    

    @IBAction func signOutPressed(_ sender: Any) {
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
    
    
}





