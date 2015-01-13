//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Lennart Erikson on 07/01/15.
//  Copyright (c) 2015 Lennart Erikson. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {
    
    func listDetailViewControllerDidCancel(controller: ListDetailViewController)
    func listDetailViewController(controller: ListDetailViewController, didFinishAddingChecklist list: Checklist)
    func listDetailViewController(controller: ListDetailViewController, didFinishEditingChecklist list: Checklist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerControllerDelegate {

    
    // MARK: - iVars
    weak var delegate: ListDetailViewControllerDelegate?
    var listToEdit: Checklist?
    var iconName = "Folder"
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var iconImageView: UIImageView!

    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // XCode Fix
        tableView.rowHeight = 44
        
        if let checklist = listToEdit {
            
            textField.text = checklist.name
            doneBarButton.enabled = true
            iconName = checklist.iconName
            
        }
        
        iconImageView.image = UIImage(named: iconName)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
        
        textField.delegate = self
    }
    
    // MARK: - IBActions
    @IBAction func cancel(){
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done(){
        
        if let checklist = listToEdit {
            
            checklist.name = textField.text
            checklist.iconName = iconName
            delegate?.listDetailViewController(self, didFinishEditingChecklist: checklist)
        } else {
            
            let checklist = Checklist(name: textField.text, iconName: iconName)
            delegate?.listDetailViewController(self, didFinishAddingChecklist: checklist)
        }
    }
    
    // MARK: - TableView Delegate
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {

        if indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    // MARK: - TextField Delegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let oldText: NSString = textField.text
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        doneBarButton.enabled = (newText.length > 0)
        
        return true
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "PickIcon" {
            
            let controller = segue.destinationViewController as IconPickerController
            controller.delegate = self
        }
    }
    
    // MARK: - IconPickerControllerDelegate methods
    func iconPicker(picker: IconPickerController, didPickIcon iconName: String) {
        
        self.iconName = iconName
        iconImageView.image = UIImage(named: iconName)
    
        if let checklist = listToEdit {
            checklist.iconName = iconName
        }
        
        navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    
    
    
}
