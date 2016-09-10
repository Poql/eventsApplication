//
//  DatePickerViewController.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 09/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

protocol DatePickerViewControllerDelegate: class {
    func controller(controller: DatePickerViewController, didPickDate date: NSDate)
}

class DatePickerViewController: UIViewController {
    
    @IBOutlet var datePicker: UIDatePicker!

    var initialDate: NSDate?
    weak var delegate: DatePickerViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerView()
    }
    
    // MARK: - Private
    
    private func setupPickerView(){
        datePicker.date = initialDate ?? NSDate()
        datePicker.minimumDate = NSDate()
        datePicker.addTarget(self, action: #selector(datePickerAction(_:)), forControlEvents: .ValueChanged)
    }
    
    // MARK: - Action

    @objc private func datePickerAction(sender: UIDatePicker) {
        delegate?.controller(self, didPickDate: datePicker.date)
    }
}
