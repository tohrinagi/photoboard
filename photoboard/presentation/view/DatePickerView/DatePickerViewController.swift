//
//  DatePickerViewController.swift
//  photoboard
//
//  Created by tohrinagi on 2016/03/09.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation
import UIKit

protocol DatePickerViewControllerDelegate {
    func OnDoneAction( date: NSDate )
    func OnCancelAction( date: NSDate )
    func OnValueChanged( date: NSDate )
}

class DatePickerViewController: UIViewController {
    @IBOutlet private weak var datePicker: UIDatePicker!
    var delegate: DatePickerViewControllerDelegate? = nil
    private var prevDate = NSDate()
    
    class func Create( storyboard: UIStoryboard ) -> DatePickerViewController {
        return storyboard.instantiateViewControllerWithIdentifier(
            "DatePickerViewController") as! DatePickerViewController
    }
    
    func setDate( date: NSDate ) {
        prevDate = date
    }
    
    override func viewDidLoad() {
        datePicker.setDate(prevDate, animated: false)
    }
    
    @IBAction private func OnTodayAction(sender: AnyObject) {
        datePicker.setDate(NSDate(), animated: true)
        delegate?.OnValueChanged(datePicker.date)
    }
    
    @IBAction private func OnDoneAction(sender: AnyObject) {
        delegate?.OnDoneAction(datePicker.date)
    }
    @IBAction func OnCancelAction(sender: AnyObject) {
        delegate?.OnCancelAction(prevDate)
    }
    
    @IBAction private func OnPickerValueChanged(sender: AnyObject) {
        delegate?.OnValueChanged(datePicker.date)
    }
}
