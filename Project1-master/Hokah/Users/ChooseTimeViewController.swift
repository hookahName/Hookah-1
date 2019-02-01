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
    var ref: DatabaseReference!
    var teaTastes = Array<TeaDB>()
    var selectedTable: Int?
    var selectedTabacoo: TobaccoDB?
    var selectedFlavour: [String]?
    var chosenTime: String = ""
    var chosenTea: TeaDB?
    var hookahs = Array<HookahDB>()
    var selectedFortress: String = "5"
    

    @IBOutlet weak var TeaSwitch: UISwitch!
    @IBOutlet weak var teaTastesPicker: UIPickerView!
    @IBOutlet weak var chooseTimeOutlet: UIDatePicker!
    @IBOutlet weak var TeaLabel: UILabel!
    @IBOutlet weak var readyBut: UIBarButtonItem!
    @IBOutlet weak var fortressSlider: UISlider!
    @IBOutlet weak var fortressLabel: UILabel!
    @IBOutlet weak var chooseTeaLabel: UILabel!
    
    // MARK: View settings

    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        //DatePicker
        chooseTimeOutlet.minimumDate = Date()
        
        let dateString = "23:59" // change to your date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        let date = dateFormatter.date(from: dateString)
        chooseTimeOutlet.maximumDate = date
        dateFormatter.dateFormat = "HH:mm"
        chosenTime = dateFormatter.string(from: Date())
        
        //Switch
        TeaSwitch.isOn = false
        self.TeaSwitch.setOn(false, animated: true)
        self.TeaSwitch.addTarget(self, action: #selector(switchChange(paramTarget:)), for: .valueChanged)
        
        //Picker
        self.teaTastesPicker.tag = 555
        //set the pickers datasource and delegate
        self.teaTastesPicker.delegate = self
        self.teaTastesPicker.dataSource = self
        self.teaTastesPicker.isUserInteractionEnabled = false
        self.teaTastesPicker.alpha = 0.6
    }
    
    // MARK: Picker view settings
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return teaTastes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return teaTastes[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.chosenTea = teaTastes[row]
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
            self.teaTastesPicker.alpha = 1
            self.teaTastesPicker.isUserInteractionEnabled = true
            let chosenTeaString = self.pickerView(teaTastesPicker, titleForRow: teaTastesPicker.selectedRow(inComponent: 0), forComponent: 0)!
            self.chosenTea = self.teaTastes.first(where: {$0.name == chosenTeaString})
        } else {
            self.teaTastesPicker.isUserInteractionEnabled = false
            self.teaTastesPicker.alpha = 0.6
            
        }
    }
    
    private func getUniqueIdentifier() -> String {
        let curDate = Date()
        let timeInterval = curDate.timeIntervalSince1970
        let dateString = String(Int(timeInterval))
        print(dateString)
        return dateString
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
            resultController.selectedFortress = self.selectedFortress
            if TeaSwitch.isOn == true {
                resultController.selectedTea = self.chosenTea?.name
            } else {
                resultController.selectedTea = "Не выбран"
            }
            resultController.hookahs = hookahs
        }
    }
    
    
    @IBAction func sliderAction(_ sender: UISlider) {
        fortressLabel.text = "Выбранная крепость: \(String(Int(fortressSlider.value)))"
        self.selectedFortress = String(Int(fortressSlider.value))
    }
}
