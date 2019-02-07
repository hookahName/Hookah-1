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
    var chosenTimeTill: String = ""
    var chosenTea: TeaDB?
    var hookahs = Array<HookahDB>()
    var selectedFortress: String = "5"
    var todayOrders: [String: Array<String>] = [:]
    

    @IBOutlet weak var TeaSwitch: UISwitch!
    @IBOutlet weak var teaTastesPicker: UIPickerView!
    @IBOutlet weak var chooseTimeOutlet: UIDatePicker!
    @IBOutlet weak var TeaLabel: UILabel!
    @IBOutlet weak var readyBut: UIBarButtonItem!
    @IBOutlet weak var fortressSlider: UISlider!
    @IBOutlet weak var fortressLabel: UILabel!
    @IBOutlet weak var chooseTeaLabel: UILabel!
    @IBOutlet weak var chooseTimeTillDatePicker: UIDatePicker!
    
    // MARK: View settings

    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        //DatePicker since
        chooseTimeOutlet.minimumDate = Date()
        
        let dateString = "23:59" // change to your date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        let date = dateFormatter.date(from: dateString)
        chooseTimeOutlet.maximumDate = date
        dateFormatter.dateFormat = "HH:mm"
        chosenTime = dateFormatter.string(from: Date())
        chooseTimeTillDatePicker.maximumDate = date
        chosenTimeTill = dateFormatter.string(from: Date())
        
        //Date Picker till
        
        chooseTimeTillDatePicker.isEnabled = false
        
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
        
        if hookahs.count != 0 {
            chooseTimeOutlet.isEnabled = false
            
        }
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
        chooseTimeTillDatePicker.minimumDate = sender.date
        
        chooseTimeTillDatePicker.isEnabled = true
        if hookahs.count != 0 {
            chooseTimeTillDatePicker.isEnabled = false
            
        }
    }
    
    @IBAction func chooseTimeTill(_ sender: UIDatePicker) {
        if self.chosenTime != "" {
            let dateFormatter = DateFormatter()
            let currentTime = sender.date
            dateFormatter.locale = Locale(identifier: "ru_RU")
            dateFormatter.dateFormat = "HH:mm"
            let dateStringTill = dateFormatter.string(from: currentTime)
            print("Время ДО \(dateStringTill)")
            chosenTimeTill = dateStringTill
        }
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
        let selectedTableString = String(describing: selectedTable!)
        print(selectedTableString, "выбранный столик")
        var isFree = true
        if hookahs.count == 0 {
            if todayOrders[selectedTableString] == nil {
                performSegue(withIdentifier: "ToResult", sender: nil)
            } else {
                
                let times = todayOrders[selectedTableString]
                for time in times! {
                    let timeString = String(describing: time)
                    var hoursAndMinutes = timeString.components(separatedBy: [" ", ",", "-"])
                    hoursAndMinutes = hoursAndMinutes.filter(){$0 != ""}
                    var hoursAndMinutesStart = hoursAndMinutes[0].components(separatedBy: ":")
                    let hoursStart = Int(hoursAndMinutesStart[0])!
                    let minutesStart = Int(hoursAndMinutesStart[1])!
                    hoursAndMinutes = hoursAndMinutes[1].components(separatedBy: ":")
                    let hoursEnd = Int(hoursAndMinutes[0])!
                    let minutesEnd = Int(hoursAndMinutes[1])!
                    
                    let startTimeInSeconds = hoursStart * 3600 + minutesStart * 60
                    //print("\(hoursStart) * 3600 + \(minutesStart) * 60 = \(hoursStart * 3600 + minutesStart * 60)")
                    let endTimeInSeconds = hoursEnd * 3600 + minutesEnd * 60
                    //print("\(hoursEnd) * 3600 + \(minutesEnd) * 60= \(hoursEnd * 3600 + minutesEnd * 60)")
                    
                    let chosenHour = Int(getHourFronChosenTime(fromWord: chosenTime))
                    let chosenMinutes = Int(getMinutesFromChosenTime(fromWord: chosenTime))
                    
                    let chosenTimeInSeconds = chosenHour! * 3600 + chosenMinutes! * 60
                    //print("\(chosenHour) * 3600 + \(chosenMinutes) * 60 = \(chosenHour! * 3600 + chosenMinutes! * 60)")
                    let chosenHourEnd = Int(getHourFronChosenTime(fromWord: chosenTimeTill))
                    let chosenMinutesEnd = Int(getMinutesFromChosenTime(fromWord: chosenTimeTill))
                    
                    let chosenTimeInSecondsEnd = chosenHourEnd! * 3600 + chosenMinutesEnd! * 60
                    //                print(chosenTimeInSeconds, chosenTimeInSecondsEnd, startTimeInSeconds, endTimeInSeconds)
                    //                print((startTimeInSeconds < chosenTimeInSeconds && chosenTimeInSecondsEnd > endTimeInSeconds && endTimeInSeconds > chosenTimeInSeconds))
                    //                print((startTimeInSeconds < chosenTimeInSeconds && endTimeInSeconds > chosenTimeInSecondsEnd))
                    //                print((startTimeInSeconds > chosenTimeInSeconds && endTimeInSeconds < chosenTimeInSecondsEnd))
                    print((chosenTimeInSeconds, "<", startTimeInSeconds, "&&", chosenTimeInSecondsEnd, ">", startTimeInSeconds, "&&", chosenTimeInSecondsEnd, "<" ,endTimeInSeconds))
                    if (startTimeInSeconds < chosenTimeInSeconds && chosenTimeInSecondsEnd > endTimeInSeconds && endTimeInSeconds > chosenTimeInSeconds) || (startTimeInSeconds < chosenTimeInSeconds && endTimeInSeconds > chosenTimeInSecondsEnd) || (startTimeInSeconds > chosenTimeInSeconds && endTimeInSeconds < chosenTimeInSecondsEnd) || (chosenTimeInSeconds < startTimeInSeconds && chosenTimeInSecondsEnd > startTimeInSeconds && chosenTimeInSecondsEnd < endTimeInSeconds)
                    {
                        
                        isFree = false
                        let ac = UIAlertController(title: "Выберите другое время", message: "Выбранное время занято", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Хорошо", style: .cancel)
                        ac.addAction(action)
                        present(ac, animated: true)
                        
                    }
                }
                if isFree == true {
                    performSegue(withIdentifier: "ToResult", sender: nil)
                }
            }
        } else {
            performSegue(withIdentifier: "ToResult", sender: nil)
        }
       
    }
    
    func getHourFronChosenTime(fromWord word:String) -> String {
        var word = word
        word.removeLast()
        word.removeLast()
        word.removeLast()
        return word
    }
    
    func getMinutesFromChosenTime(fromWord word: String) -> String {
        var word = word
        word.removeFirst()
        word.removeFirst()
        word.removeFirst()
        return word
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToResult" {
            guard let resultController = segue.destination as? Result else {return}
            resultController.selectedTable = self.selectedTable
            resultController.selectedTabacoo = self.selectedTabacoo
            resultController.selectedFlavour = self.selectedFlavour
            if hookahs.count == 0 {
                resultController.selectedTime = self.chosenTime
                resultController.chosenTimeTill = self.chosenTimeTill
            } else {
                resultController.selectedTime = hookahs[hookahs.count - 1].time
                resultController.chosenTimeTill = hookahs[hookahs.count - 1].timeTill
            }
            
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
