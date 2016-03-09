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
    
    private var boardInfo: BoardInfo?
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var dateTextField: UITextField!
    @IBOutlet private weak var saveButton: UIBarButtonItem!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.enabled = false
    }
    
    func setBoardInfo( info: BoardInfo ) {
        
        self.boardInfo = info
        if info.title.isEmpty {
            self.navigationItem.title = "New Board"
            self.titleTextField.text = String()
        } else {
            self.navigationItem.title = info.title
            self.titleTextField.text = info.title
        }
        //TODO self.dateTextField.text = info.createdAt.
    }
    
    @IBAction private func OnCancelAction(sender: AnyObject) {
        delegate?.OnCancelAction()
    }
    
    @IBAction private func OnSaveAction(sender: AnyObject) {
        if let titleText = titleTextField.text {
            if let dateText = dateTextField.text {
                delegate?.OnSaveAction( titleText, date: NSDate())
            }
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
        // 撮影画面をモーダルビューとして表示する
        self.presentViewController(controller, animated: true, completion: nil)
        return false
    }
}

extension InfoBoardViewController: DatePickerViewControllerDelegate {
    func OnDoneAction(date: NSDate) {
        dateTextField.text = dateToString(date)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func OnValueChanged(date: NSDate) {
        dateTextField.text = dateToString(date)
    }
    
    private func dateToString(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("yyyy年 MM月 dd日")
        return formatter.stringFromDate(date)
    }
}
