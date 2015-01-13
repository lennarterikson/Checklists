//
//  ViewController.swift
//  Checklists
//
//  Created by Lennart Erikson on 23/12/14.
//  Copyright (c) 2014 Lennart Erikson. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    // MARK: - iVars
    var checklist: Checklist!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = checklist.name
        
        // fix for xcode bug
        tableView.rowHeight = 44
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem") as UITableViewCell
        
        let item = checklist.items[indexPath.row]
        
        configureTextForCell(cell, withChecklistItem: item)
        configureCheckmarkForCell(cell, withChecklistItem: item)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            

            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            
            configureTextForCell(cell, withChecklistItem: item)
            configureCheckmarkForCell(cell, withChecklistItem: item)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        

    }
    
    // AkA "Swipe-To-Delete" function
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        checklist.items.removeAtIndex(indexPath.row)
        
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        

    }
    
    // MARK: - ItemDetailViewControllerDelegate methods
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func itemDetailViewControllerDidFinish(controller: ItemDetailViewController, withItem item: ChecklistItem) {
        
        // get index to fade the cell in 
        let index = checklist.items.count
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        
        checklist.items.append(item)

        dismissViewControllerAnimated(true, completion: nil)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
    }
    
    func itemDetailViewControllerDidFinishEditing(controller: ItemDetailViewController, withItem item: ChecklistItem) {
        
        if let index = find(checklist.items, item) {

            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            
                configureTextForCell(cell, withChecklistItem: item)
            }
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        let navigationController = storyboard!.instantiateViewControllerWithIdentifier("itemDetailNavigationController") as UINavigationController
        
        let itemDetailController = navigationController.topViewController as ItemDetailViewController
        
        itemDetailController.delegate = self
        itemDetailController.itemToEdit = checklist.items[indexPath.row]
        
        presentViewController(navigationController, animated: true, completion: nil)
        
    }
    
    // MARK: - Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "addItem" {
            
            let navigationController = segue.destinationViewController as UINavigationController
            let itemDetailViewController = navigationController.topViewController as ItemDetailViewController
            
            itemDetailViewController.delegate = self
        }
        
    }
    
    
    // MARK: - Helper methods
    func configureCheckmarkForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem){
        
            // get the label to show the checkmark
            let checkmarkLabel = cell.viewWithTag(1001) as UILabel
            checkmarkLabel.textColor = view.tintColor
        
            if item.checked {
                checkmarkLabel.text = "√"
            } else {
                checkmarkLabel.text = ""
            }
        
    }
    
    func configureTextForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem){
        
        let label = cell.viewWithTag(1000) as UILabel
        label.text = item.text
    }


}

