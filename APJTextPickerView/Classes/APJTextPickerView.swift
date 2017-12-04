//
//  APJTextPickerView.swift
//  Pods
//
//  Created by Pino, Angelo on 17/08/2017.
//
//

import UIKit

public enum APJTextPickerViewType {
    case date, strings
}

public protocol APJTextPickerViewDelegate: class {
    // date picker delegate
    func textPickerView(_ textPickerView: APJTextPickerView, didSelectDate date: Date?)
    
    // strings picker delegate
    func textPickerView(_ textPickerView: APJTextPickerView, didSelectString row: Int)
    func textPickerView(_ textPickerView: APJTextPickerView, titleForRow row: Int) -> String?
}

public extension APJTextPickerViewDelegate {
    // date picker delegate
    func textPickerView(_ textPickerView: APJTextPickerView, didSelectDate date: Date?) {}
    
    // strings picker delegate
    func textPickerView(_ textPickerView: APJTextPickerView, didSelectString row: Int) {}
    func textPickerView(_ textPickerView: APJTextPickerView, titleForRow row: Int) -> String? { return nil }
}

public protocol APJTextPickerViewDataSource: class {
    func numberOfRows(in pickerView: APJTextPickerView) -> Int
}

open class APJTextPickerView: UITextField {
    
    // MARK: public properties
    public var type: APJTextPickerViewType = .date {
        didSet {
            _updateType()
        }
    }
    
    // date picker properties
    public var currentDate: Date? {
        didSet {
            _updateCurrentDate()
        }
    }
    private var _oldDateValue: Date?
    public var changeOnValueChanged = false
    public var datePicker: UIDatePicker? {
        return inputView as? UIDatePicker
    }
    public var dateFormatter: DateFormatter!
    
    // strings picker properties
    public var currentIndexSelected: Int? {
        didSet {
            _updateCurrentIndexSelected()
        }
    }
    private var _oldIndexSelected: Int?
    public var dataPicker: UIPickerView? {
        return inputView as? UIPickerView
    }
    public weak var dataSource: APJTextPickerViewDataSource?
    
    // common properties
    private(set) public var toolbar: UIToolbar?
    public weak var pickerDelegate: APJTextPickerViewDelegate?
    public var cancelText = "Cancel" {
        didSet {
            _updateToolbar()
        }
    }
    public var doneText = "Done" {
        didSet {
            _updateToolbar()
        }
    }
    public var pickerTitle: String? {
        didSet {
            _updateToolbar()
        }
    }
    
    // MARK: init methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        _initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _initialize()
    }
    
    private func _initialize() {
        _updateType()
        _updateToolbar()
    }
    
    override open func caretRect(for position: UITextPosition) -> CGRect {
        return .zero
    }
    
    // MARK: private
    
    private func _updateType() {
        switch type {
        case .strings:
            _initDataPicker()
        case .date:
            _initDatePicker()
            _initDateFormatter()
        }
    }
    
    // date picker setup
    private func _initDatePicker() {
        inputView = nil
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(_changeDate), for: .valueChanged)
        inputView = picker
    }
    
    private func _initDateFormatter() {
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
    }
    
    private func _updateDateText() {
        if let date = datePicker?.date {
            text = dateFormatter.string(from: date)
        } else {
            text = nil
        }
    }
    
    private func _updateCurrentDate() {
        if _oldDateValue != currentDate {
            pickerDelegate?.textPickerView(self, didSelectDate: currentDate)
            _updateDateText()
        } else if currentDate == nil {
            text = nil
        }
        datePicker?.setDate(currentDate ?? Date(), animated: true)
        _oldDateValue = currentDate
    }
    
    @objc private func _changeDate() {
        if changeOnValueChanged {
            switch type {
            case .date:
                _updateDateText()
            case .strings:
                _updateDataText()
            }
        }
    }
    
    // strings data picker setup
    private func _initDataPicker() {
        inputView = nil
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        inputView = picker
    }
    
    private func _updateDataText() {
        if let row = dataPicker?.selectedRow(inComponent: 0) {
            text = pickerDelegate?.textPickerView(self, titleForRow: row)
        }
    }
    
    private func _updateCurrentIndexSelected() {
        let count = dataSource?.numberOfRows(in: self) ?? -1
        if let row = currentIndexSelected, count > 0, row < count, _oldIndexSelected != currentIndexSelected {
            pickerDelegate?.textPickerView(self, didSelectString: row)
            _oldIndexSelected = currentIndexSelected
            _updateDataText()
        } else if currentIndexSelected == nil {
            text = nil
        }
        dataPicker?.selectRow(currentIndexSelected ?? 0, inComponent: 0, animated: true)
    }
    
    // toolbar setup
    private func _updateToolbar() {
        
        let cancelButton = UIBarButtonItem(title: cancelText, style: .plain, target: self, action: #selector(_cancel)),
        space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
        doneButton = UIBarButtonItem(title: doneText, style: .done, target: self, action: #selector(_done)),
        titleBarButton = UIBarButtonItem(title: pickerTitle ?? placeholder, style: .done, target: nil, action: nil)
        titleBarButton.isEnabled = false
        
        toolbar = UIToolbar()
        toolbar?.barStyle = .default
        toolbar?.isTranslucent = true
        toolbar?.setItems([cancelButton, space, titleBarButton, space, doneButton], animated: false)
        toolbar?.isUserInteractionEnabled = true
        toolbar?.sizeToFit()
        
        inputAccessoryView = toolbar
    }
    
    // MARK: action methods
    
    @objc private func _cancel() {
        switch type {
        case .strings:
            currentIndexSelected = _oldIndexSelected
        case .date:
            currentDate = _oldDateValue
        }
        endEditing(true)
    }
    
    @objc private func _done() {
        switch type {
        case .strings:
            currentIndexSelected = dataPicker?.selectedRow(inComponent: 0)
        case .date:
            currentDate = datePicker?.date
        }
        endEditing(true)
    }
    
}

extension APJTextPickerView: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource?.numberOfRows(in: self) ?? 0
    }
}

extension APJTextPickerView: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDelegate?.textPickerView(self, titleForRow: row)
    }
}
