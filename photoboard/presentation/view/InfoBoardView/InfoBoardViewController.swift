//
//  InfoBoardViewController.swift
//  photoboard
//
//  Created by tohrinagi on 2016/03/07.
//  Copyright © 2016年 tohrinagi. All rights reserved.
//

import Foundation
import UIKit

protocol InfoBoardViewControllerDelegate {
    func OnSaveAction( title: String, date: NSDate )
    func OnCancelAction()
}

class InfoBoardViewController: UITableViewController {
    var delegate: InfoBoardViewControllerDelegate? = nil
    
    private var date = NSDate()
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var dateTextField: UITextField!
    @IBOutlet private weak var saveButton: UIBarButtonItem!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.enabled = false
        updateDateString()
        self.navigationItem.title = "New Board"
    }
    
    func setTitleString( title: String ) {
        self.navigationItem.title = title
        self.titleTextField.text = title
    }
    
    func setDate( date: NSDate ) {
        self.date = date
        updateDateString()
    }
    
    private func updateDateString() {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP")
        formatter.dateStyle = .LongStyle
        dateTextField.text = formatter.stringFromDate(date)
    }
    
    @IBAction private func OnCancelAction(sender: AnyObject) {
        delegate?.OnCancelAction()
    }
    
    @IBAction private func OnSaveAction(sender: AnyObject) {
        if let titleText = titleTextField.text {
            delegate?.OnSaveAction( titleText, date: date)
        }
    }

    @IBAction private func OnEditingChanged(sender: AnyObject) {
        saveButton.enabled = false
        if let text = titleTextField.text {
            if text.lengthOfBytesUsingEncoding(NSUTF16StringEncoding) > 0 {
                saveButton.enabled = true
            }
        }
    }
}

extension InfoBoardViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        let controller = DatePickerViewController.Create(self.storyboard!)
        controller.delegate = self
        controller.setDate(date)
        self.presentViewController(controller, animated: true, completion: nil)
        return false
    }
}

extension InfoBoardViewController: DatePickerViewControllerDelegate {
    func OnDoneAction(date: NSDate) {
        self.date = date
        updateDateString()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func OnCancelAction(date: NSDate) {
        self.date = date
        updateDateString()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func OnValueChanged(date: NSDate) {
        self.date = date
        updateDateString()
    }
}
