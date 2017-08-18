//
//  ViewController.swift
//  APJTextPickerView
//
//  Created by angelopino on 08/17/2017.
//  Copyright (c) 2017 angelopino. All rights reserved.
//

import UIKit
import APJTextPickerView

class ViewController: UIViewController {
    
    @IBOutlet weak var textDatePickerView: APJTextPickerView!
    @IBOutlet weak var textTimePickerView: APJTextPickerView!
    @IBOutlet weak var textStringsPickerView: APJTextPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        _initTextDatePickerView()
        _initTextTimePickerView()
        initTextStringsPickerView()
    }
    
    // MARK: private methods
    private func _initTextDatePickerView() {
        textDatePickerView.pickerDelegate = self
        textDatePickerView.dateFormatter.dateStyle = .medium
    }
    
    private func _initTextTimePickerView() {
        textTimePickerView.pickerDelegate = self
        textTimePickerView.datePicker?.datePickerMode = .time
        textTimePickerView.dateFormatter.dateFormat = "HH:mm"
    }
    
    fileprivate var strings = ["Rome", "Madrid", "Tokyo", "Rio de Janeiro", "Moscow", "Shanghai"]
    private func initTextStringsPickerView() {
        textStringsPickerView.type = .strings
        textStringsPickerView.pickerDelegate = self
        textStringsPickerView.dataSource = self
    }
}

extension ViewController: APJTextPickerViewDelegate {
    func textPickerView(_ textPickerView: APJTextPickerView, didSelectDate date: Date) {
        print("Date Selected: \(date)")
    }
    
    func textPickerView(_ textPickerView: APJTextPickerView, didSelectString row: Int) {
        print("City Selected: \(strings[row])")
    }
    
    func textPickerView(_ textPickerView: APJTextPickerView, titleForRow row: Int) -> String? {
        return strings[row]
    }
}

extension ViewController: APJTextPickerViewDataSource {
    func numberOfRows(in pickerView: APJTextPickerView) -> Int {
        return strings.count
    }
}

