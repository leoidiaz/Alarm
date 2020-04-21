//
//  AlarmDetailTableViewController.swift
//  myAlarm
//
//  Created by Leonardo Diaz on 4/20/20.
//  Copyright © 2020 trevorAdcock. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {
    //MARK: - Outlets
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var enableButton: UIButton!
    
    //MARK: - Property
    var alarm: Alarm? {
        didSet{
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    var alarmIsOn = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableButton.setTitle("On", for: .normal)
        enableButton.setTitleColor(.black, for: .normal)
        enableButton.backgroundColor = .green
    }
    

    @IBAction func enableButtonTapped(_ sender: Any) {
        alarmIsOn = !alarmIsOn
        if alarmIsOn {
            enableButton.setTitle("On", for: .normal)
            enableButton.setTitleColor(.black, for: .normal)
            enableButton.backgroundColor = .green
        } else {
            enableButton.setTitle("Off", for: .normal)
            enableButton.setTitleColor(.white, for: .normal)
            enableButton.backgroundColor = .red
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text else { return }

        if let alarm = alarm {
            AlarmController.shared.update(alarm: alarm, fireDate: datePicker.date, name: name, enabled: alarmIsOn)
            navigationController?.popViewController(animated: true)
        } else {
            AlarmController.shared.addAlarm(fireDate: datePicker.date, name: name, enabled: alarmIsOn)
            navigationController?.popViewController(animated: true)
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    private func updateViews(){
        guard let alarm = alarm else {return}
        datePicker.date = alarm.fireDate
        nameTextField.text = alarm.name
        alarmIsOn = alarm.enabled
        if alarmIsOn {
            enableButton.setTitle("On", for: .normal)
            enableButton.setTitleColor(.black, for: .normal)
            enableButton.backgroundColor = .green
        } else {
            enableButton.setTitle("Disabled", for: .normal)
            enableButton.setTitleColor(.white, for: .normal)
            enableButton.backgroundColor = .red
        }
    }

}
