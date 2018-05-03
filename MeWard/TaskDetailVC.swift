//
//  TaskDetailVC.swift
//  MeWard
//
//  Created by Tram Nguyen on 4/28/18.
//  Copyright © 2018 Tram Nguyen. All rights reserved.
//

import UIKit

class TaskDetailVC: UIViewController {
    
    @IBOutlet weak var taskNameField: UITextField!
    @IBOutlet weak var taskPointsField: UITextField!
    @IBOutlet weak var goalField: UITextField!
    @IBOutlet weak var dueDateField: UITextField!
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    var taskToDo: String?
    var taskPoints: String?
    
    let placeHolderArray = ["handbag", "vacation to hawaii", "pancakes", "new laptop", "more pancakes", "weekend dedicated to Netflix", "New video game", "Birthday gift"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let taskName = taskToDo {
            taskNameField.text = taskName
            self.navigationItem.title = "Edit To Do Item"
        } else {
            self.navigationItem.title = "New To Do Item"
        }
        if let taskPoints = taskPoints {
            taskPointsField.text = taskPoints
        }
        if let taskToDoCount = taskNameField.text?.count, taskToDoCount > 0 {
            saveBarButton.isEnabled = true
        } else {
            saveBarButton.isEnabled = false
        }
        taskPointsField.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    @IBAction func toDoFIeldChanged(_ sender: UITextField) {
        if taskNameField.text!.count > 0 {
            saveBarButton.isEnabled = true
        } else {
            saveBarButton.isEnabled = false
        }
    }
    
    
    
    @objc func handleGoalDoneButton(sender: UIButton) {
        goalField.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindFromSave" {
            taskToDo = taskNameField.text
            taskPoints = taskPointsField.text
        }
    }
    
    
    @IBAction func goalFieldInput(_ sender: UITextField) {
        
        let goalPicker = UIPickerView()
        goalPicker.delegate = self
        goalField.inputView = goalPicker
        
        let goalToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        let goalDoneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleGoalDoneButton(sender:)))
        let goalSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        goalToolBar.setItems([goalSpace, goalDoneBarButton], animated: false)
        goalToolBar.isUserInteractionEnabled = true
        goalField.inputAccessoryView = goalToolBar
        
        
        
        
        
        
    }
    
    
    // need more here

    @objc func handleDuDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
        dueDateField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func handleDoneButton(sender: UIButton) {
        dueDateField.resignFirstResponder()
    }
    
    @objc func handleClearButton(sender: UIButton) {
        dueDateField.text = ""
    }
    
    @IBAction func dueDateInput(_ sender: UITextField) {
        
        let dueDatePicker = UIDatePicker()
        dueDatePicker.addTarget(self, action: #selector(handleDuDatePicker(sender:)), for: .valueChanged)
        dueDateField.inputView = dueDatePicker
        
        let dueDateToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        let dueDateDoneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDoneButton(sender:)))
        let dueDateSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let dueDateClearBarButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(handleClearButton(sender:)))
        dueDateToolBar.setItems([dueDateClearBarButton,dueDateSpace, dueDateDoneBarButton], animated: false)
        dueDateToolBar.isUserInteractionEnabled = true
        dueDateField.inputAccessoryView = dueDateToolBar
        
        
    }
    

    

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    

}

extension TaskDetailVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return placeHolderArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return placeHolderArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        goalField.text = placeHolderArray[row]
    }
    
}
