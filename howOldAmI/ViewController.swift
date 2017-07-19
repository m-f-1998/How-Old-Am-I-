//
//  ViewController.swift
//  howOldAmI
//
//  Created by Matthew Frankland on 04/07/2017.
//  Copyright © 2017 Matthew Frankland. All rights reserved.
//

import UIKit

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        return ""
    }
}

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageBackground: UIImageView!
    @IBOutlet var datePick: UIDatePicker!
    @IBOutlet var hourPick: UIDatePicker!
    @IBOutlet var textDateField: UITextField!
    @IBOutlet var hourDateField: UITextField!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var outputLabelOne: UILabel!
    @IBOutlet var outputLabelTwo: UILabel!
    @IBOutlet var outputLabelThree: UILabel!
    @IBOutlet var outputLabelFour: UILabel!
    var date: String!
    var hour: String!
    var dateObj: Date!
    var finalDate: Date!
    
    var pickerData = ["Show My Age In Seconds", "Show My Age In Minutes", "Show My Age In Hours", "Show My Age In Days", "Show My Age In Months"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        datePick = UIDatePicker()
        datePick.datePickerMode = UIDatePickerMode.date

        hourPick = UIDatePicker()
        hourPick.datePickerMode = UIDatePickerMode.time
        
        let toolBar = UIToolbar()
        setToolbar(toolBar)
        
        let secondToolBar = UIToolbar()
        setToolbar(secondToolBar)
        
        let toolBarButtons = createButtons("doneButton", "Done", textDateField, #selector(textDateField.resignFirstResponder))
        
        let toolBarButtonsOne = createButtons("doneButtonOne", "Done", hourDateField, #selector(hourDateField.resignFirstResponder))
        
        setBarButton(toolBar, toolBarButtons)
        setBarButton(secondToolBar, toolBarButtonsOne)
        
        setDatePicker(textDateField, datePick, toolBar)
        textFieldEditing(textDateField)
        setDatePicker(hourDateField, hourPick, secondToolBar)
        timeTextEditing(hourDateField)
        
        hourDateField.isEnabled = false
        hourDateField.backgroundColor = UIColor.lightGray
        hourDateField.attributedPlaceholder = NSAttributedString(string:"Enter Date First",
                                                             attributes:[NSForegroundColorAttributeName: UIColor.white])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func setToolbar(_ tool: UIToolbar){
        tool.barStyle = UIBarStyle.default
        tool.isTranslucent = true
        tool.tintColor = UIColor.black
        tool.sizeToFit()
    }
    
    func createButtons(_ name: String, _ title: String, _ textField: UITextField, _ selector: Selector) ->  [UIBarButtonItem]{
        let name = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.plain, target: textField, action: selector)
        name.width = 89
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: textField, action: nil)
        let UIButtons: [UIBarButtonItem] = [space, name]
        return UIButtons
    }
    
    func setBarButton(_ tool: UIToolbar, _ button: [UIBarButtonItem]){
        tool.setItems(button, animated: false)
        tool.isUserInteractionEnabled = true
    }
    
    func setDatePicker (_ sender: UITextField, _ datePick: UIDatePicker, _ tool: UIToolbar){
        sender.inputView = datePick
        sender.inputAccessoryView = tool
    }
    
    func noneSelected(_ hourortime: String) {
        pickerView.selectRow(0, inComponent: 0, animated: true)
        outputLabelOne.text = ""
        outputLabelTwo.text = hourortime
        outputLabelThree.text = ""
        outputLabelFour.text = ""
    }
    
    func standardOutput() {
        self.outputLabelOne.text = "You Are:"
        self.outputLabelTwo.text = "No Output Selected"
        self.outputLabelThree.text = "With Your Birthday Being:"
        self.outputLabelFour.text = "No Date Selected"
    }
    
    func setFormatter(_ formatter: DateFormatter, _ format: String){
        formatter.timeZone = NSTimeZone.local
        formatter.dateFormat = format
        formatter.locale = NSLocale.current
    }
    
    func automaticSetSeconds(){
        let firstDate  = NSDate()
        
        let formatter = DateFormatter()
        setFormatter(formatter, "dd:MM:yyyy 'at' HH:mm")
        let formattedDate = formatter.string(from: firstDate as Date)
        dateObj = formatter.date(from: formattedDate)!
        
        let string = date + " at " + String(hour)
        let format = DateFormatter()
        setFormatter(format, "dd/MM/yyyy 'at' HH:mm")
        
        finalDate = format.date(from: string)!
        
        pickerView.selectRow(0, inComponent: 0, animated: true)
        
        var second = dateObj.minutes(from: finalDate)
        print(second)
        second = second * 60;
        outputLabelOne.text = "You Are:"
        outputLabelTwo.text = String(describing: second) + " Seconds Old"
        outputLabelThree.text = "With Your Birthday Being:"
        outputLabelFour.text = textDateField.text
    }
    
    func calc(_ time: Int, _ timeType: String){
        outputLabelOne.text = "You Are:"
        outputLabelTwo.text = String(describing: time) + " " + timeType + " Old"
        outputLabelThree.text = "With Your Birthday Being:"
        outputLabelFour.text = textDateField.text
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        let firstDate  = NSDate()
        
        let formatter = DateFormatter()
        setFormatter(formatter, "dd:MM:yyyy 'at' HH:mm")
        let formattedDate = formatter.string(from: firstDate as Date)
        dateObj = formatter.date(from: formattedDate)!
        
        if(textDateField.text == ""){
            noneSelected("No Date Selected")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                self.standardOutput()
            }} else if(hourDateField.text == ""){
                noneSelected("No Time Selected")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                    self.standardOutput()
            }} else{
            let string = date + " at " + String(hour)
            let format = DateFormatter()
            setFormatter(format, "dd/MM/yyyy 'at' HH:mm")
            
            finalDate = format.date(from: string)!
            
            if (row == 0){
                var second = dateObj.minutes(from: finalDate)
                second = second*60
                calc(second, "Seconds")
            }else if (row == 1){
                let minutes = dateObj.minutes(from: finalDate)
                calc(minutes, "Minutes")
            }else if (row == 2){
                let hour = dateObj.hours(from: finalDate)
                calc(hour, "Hours")
            }else if (row == 3){
                let days = dateObj.days(from: finalDate)
                calc(days, "Days")
            }else if (row == 4){
                let months = dateObj.months(from: finalDate)
                calc(months, "Months")
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]

        let myTitle = NSAttributedString(string:titleData, attributes:[NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName: UIColor.white])
        return myTitle
    }
    
    @objc func donePicker(sender: UITextField){
        switch sender{
            case textDateField:
                textDateField.resignFirstResponder()
                break;
            case hourDateField:
                hourDateField.resignFirstResponder()
                break;
            default:
                break;
        }
    }
    
    @IBAction func textFieldEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(ViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        if(textDateField.text != ""){
        hourDateField.isEnabled = true
        hourDateField.backgroundColor = UIColor.white
        hourDateField.attributedPlaceholder = NSAttributedString(string:"Enter Hour", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        }
        
        if(hourDateField.text != ""){
            automaticSetSeconds()
        }
    }
    
    @IBAction func timeTextEditing(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.time
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(ViewController.hourPickerValueChanged), for: UIControlEvents.valueChanged)
        
        if (textDateField.text?.isEmpty)!{
            if(hourDateField.text == ""){
                hourDateField.resignFirstResponder()
            }
        } else {
            automaticSetSeconds()
        }
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        date = dateFormatter.string(from: sender.date)
        
        textDateField.text = date
    }
    
    @objc func hourPickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "HH:mm"
        
        hour = dateFormatter.string(from: sender.date)
        
        hourDateField.text = hour
    }
}

