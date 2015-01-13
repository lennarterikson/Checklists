//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Lennart Erikson on 05/01/15.
//  Copyright (c) 2015 Lennart Erikson. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
    
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController)
    func itemDetailViewControllerDidFinish(controller: ItemDetailViewController, withItem item: ChecklistItem)
    func itemDetailViewControllerDidFinishEditing(controller: ItemDetailViewController, withItem item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    weak var delegate: ItemDetailViewControllerDelegate?
    var itemToEdit: ChecklistItem?
    var dueDate = NSDate()
    
    var datePickerVisible = false
    
    // MARK: - Show and Hide DatePicker
    func showDatePicker() {
        
        datePickerVisible = true
        
        let cellIndexPath = NSIndexPath(forRow: 1, inSection: 1)
        let indexPath = NSIndexPath(forRow: 2, inSection: 1)
        
        if let dateCell = tableView.cellForRowAtIndexPath(cellIndexPath) {
            
            dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
        }
        
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        tableView.reloadRowsAtIndexPaths([cellIndexPath], withRowAnimation: .None)
        tableView.endUpdates()
        
        if let pickerCell = tableView.cellForRowAtIndexPath(indexPath) {
            
            let datePicker = pickerCell.viewWithTag(100) as UIDatePicker
            datePicker.setDate(dueDate, animated: false)
        }
    }
    
    func hideDatePicker() {
        
        if datePickerVisible {
            
            datePickerVisible = false
            
            let cellIndexPath = NSIndexPath(forRow: 1, inSection: 1)
            let pickerIndexPath = NSIndexPath(forRow: 2, inSection: 1)
            
            if let cell = tableView.cellForRowAtIndexPath(cellIndexPath) {
                // Half transparent black : Gray
                cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
            
            tableView.beginUpdates()
            tableView.reloadRowsAtIndexPaths([cellIndexPath], withRowAnimation: .None)
            tableView.deleteRowsAtIndexPaths([pickerIndexPath], withRowAnimation: .Fade)
            tableView.endUpdates()
            
        }
    }
    
    
    // MARK: - Overriden tableView methods to make DatePicker visible
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 2 && indexPath.section == 1 {
            
            var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("DatePickerCell") as? UITableViewCell
            
            if cell == nil {
                
                cell = UITableViewCell(style: .Default, reuseIdentifier: "DatePickerCell")
                cell.selectionStyle = .None
                
                let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 320, height: 216))
                datePicker.tag = 100
                cell.contentView.addSubview(datePicker)
                
                datePicker.addTarget(self, action: Selector("dateChanged:"), forControlEvents: .ValueChanged)
            }
            
            return cell
            
        } else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 && datePickerVisible {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        textField.resignFirstResponder()
        
        if indexPath.section == 1 && indexPath.row == 1 {

            if !datePickerVisible {
                showDatePicker()
            } else {
                hideDatePicker()
            }
        }
    }
    
    override func tableView(tableView: UITableView, var indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        
        if indexPath.section == 1 && indexPath.row == 2 {
            
            indexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAtIndexPath: indexPath)
    }
    
    func dateChanged(datePicker: UIDatePicker){
        
        dueDate = datePicker.date
        updateDueLabel()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.rowHeight = 44
        
        if let item = itemToEdit {
            
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.enabled = true
            shouldRemindSwitch.on = item.shouldRemind
            dueDate = item.dueDate
        }
        
        updateDueLabel()
    }
    
    func updateDueLabel(){
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        
        dueDateLabel.text = dateFormatter.stringFromDate(dueDate)
    }
    
    // MARK: - TableView methods
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    // MARK: - TextFieldDelegate methods
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let oldText: NSString = textField.text
        let newText: NSString = oldText.stringByReplacingCharactersInRange(
            range, withString: string)
        
        doneBarButton.enabled = (newText.length > 0)
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        hideDatePicker()
    }
    
    // MARK: - IBActions
    @IBAction func cancel(){
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done(){
        
        if let item = itemToEdit {
        
            item.text = textField.text
            item.dueDate = dueDate
            item.shouldRemind = shouldRemindSwitch.on
            item.scheduleNotification()
            
            delegate?.itemDetailViewControllerDidFinishEditing(self, withItem: item)
        } else {
        
            let item = ChecklistItem(text: textField.text)
            item.checked = false
            item.dueDate = dueDate
            item.shouldRemind = shouldRemindSwitch.on
            item.scheduleNotification()
        
            delegate?.itemDetailViewControllerDidFinish(self, withItem: item)
        }
    }
    
    @IBAction func shouldRemindToggled(switchControl: UISwitch) {
    
        if switchControl.on {
            
            let notificationSettings = UIUserNotificationSettings(forTypes: .Alert | .Sound, categories: nil)
            
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        }
    }
}
