//
//  ChooseTimeViewController.swift
//  Hokah
//
//  Created by Саша Руцман on 21.01.2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit
import Firebase
class ChooseTimeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
    var ref: DatabaseReference!
    var tastes = Array<TasteDB>()
    var selectedTable: Int?
    var selectedTabacoo: String?
    var selectedFlavour: String?
    var chosenTime: String = ""
    var chosenTea: String = ""
    @IBOutlet weak var ChooseTimeOutlet: UIDatePicker!
    @IBOutlet weak var TeaLabel: UILabel!
    @IBOutlet weak var TeaSwitch: UISwitch!
    
    @IBOutlet weak var readyBut: UIBarButtonItem!
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref = Database.database().reference().child("tea")
        ref.observe(.value, with: { [weak self] (snapshot) in
            var _tastes = Array<TasteDB>()
            for i in snapshot.children{
                let taste = TasteDB(snapshot: i as! DataSnapshot)
                if taste.isAvailable == true{
                    _tastes.append(taste)
                }
            }
            self?.tastes = _tastes
            
            }
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DatePicker
        ChooseTimeOutlet.minimumDate = Date()
        let dateString = "23:59" // change to your date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let date = dateFormatter.date(from: dateString)
        ChooseTimeOutlet.maximumDate = date
        dateFormatter.dateFormat = "HH:mm"
        chosenTime = dateFormatter.string(from: Date())
        // Do any additional setup after loading the view.
        
        //Switch
        TeaSwitch.isOn = false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tastes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tastes[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.chosenTea = tastes[row].name
    }
    
    
    @IBAction func teaSwitch(_ sender: Any) {
        if TeaSwitch.isOn == true {
            let alertController = UIAlertController(title: "Чай", message: "Выберите вкус\n\n\n\n\n\n", preferredStyle: .alert)
            let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140)) // CGRectMake(left, top, width, height) - left and top are like margins
            pickerFrame.tag = 555
            //set the pickers datasource and delegate
            pickerFrame.delegate = self
            pickerFrame.dataSource = self
            
            //Add the picker to the alert controller
            alertController.view.addSubview(pickerFrame)
            let cancel = UIAlertAction(title: "Cancel", style: .default) {
                action in
                self.TeaSwitch.isOn = false
                return
            }
            let save = UIAlertAction(title: "Save", style: .default) {
                action in
                self.chosenTea = self.pickerView(pickerFrame, titleForRow: pickerFrame.selectedRow(inComponent: 0), forComponent: 0)!
            }
            alertController.addAction(cancel)
            alertController.addAction(save)
            present(alertController, animated: true)
        }
       
    }
    
    @IBAction func chooseTime(_ sender: UIDatePicker) {
        
        let currentTime = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "HH:mm"
        let dateString = dateFormatter.string(from: currentTime)
        print("Custom date format Sample 1 =  \(dateString)")
        chosenTime = dateString
        
    }
    
    @IBAction func readyButPressed(_ sender: UIBarButtonItem) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToResult" {
            guard let resultController = segue.destination as? Result else {return}
            resultController.selectedTable = self.selectedTable
            resultController.selectedTabacoo = self.selectedTabacoo
            resultController.selectedFlavour = self.selectedFlavour
            resultController.selectedTime = self.chosenTime
            if TeaSwitch.isOn == true {
                resultController.selectedTea = self.chosenTea
            } else {
                resultController.selectedTea = "Вы не выбрали чай"
            }
            
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
