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
    
    // MARK: Properties
    let TeaSwitch = UISwitch()
    var ref: DatabaseReference!
    var tastes = Array<TasteDB>()
    var selectedTable: Int?
    var selectedTabacoo: String?
    var selectedFlavour: [String]?
    var chosenTime: String = ""
    var chosenTea: String = ""
    let TeaTastesPicker = UIPickerView()
    
    @IBOutlet weak var ChooseTimeOutlet: UIDatePicker!
    @IBOutlet weak var TeaLabel: UILabel!
    @IBOutlet weak var readyBut: UIBarButtonItem!
    
    // MARK: View settings
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        //Switch
        TeaSwitch.isOn = false
        self.TeaSwitch.frame = CGRect(x: 196, y: 318, width: 0, height: 0)
        self.TeaSwitch.setOn(false, animated: true)
        self.TeaSwitch.addTarget(self, action: #selector(switchChange(paramTarget:)), for: .valueChanged)
        view.addSubview(self.TeaSwitch)
        
        //Picker
        self.TeaTastesPicker.frame = CGRect(x: 0, y: 426, width: 375, height: 216)
        self.TeaTastesPicker.tag = 555
        //set the pickers datasource and delegate
        self.TeaTastesPicker.delegate = self
        self.TeaTastesPicker.dataSource = self
        TeaTastesPicker.isHidden = true
        view.addSubview(self.TeaTastesPicker)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    // MARK: Picker view settings
    
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
    
    // MARR: Private functions
    

    
    @IBAction func chooseTime(_ sender: UIDatePicker) {
        
        let currentTime = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "HH:mm"
        let dateString = dateFormatter.string(from: currentTime)
        print("Custom date format Sample 1 =  \(dateString)")
        chosenTime = dateString
    }
    
    
    @objc func switchChange(paramTarget: UISwitch) {
        if paramTarget.isOn {
            self.TeaTastesPicker.isHidden = false
            self.chosenTea = self.pickerView(TeaTastesPicker, titleForRow: TeaTastesPicker.selectedRow(inComponent: 0), forComponent: 0)!
        } else {
            self.TeaTastesPicker.isHidden = true
            
        }
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
                resultController.selectedTea = "Чай: \(self.chosenTea)"
            } else {
                resultController.selectedTea = "Чай: не выбран"
            }
        }
    }
}
