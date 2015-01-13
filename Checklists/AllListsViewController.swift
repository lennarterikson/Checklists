//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Lennart Erikson on 07/01/15.
//  Copyright (c) 2015 Lennart Erikson. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    var dataModel: DataModel!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklist
        
        if index >= 0 && index < dataModel.lists.count {
            
            let checklist = dataModel.lists[index]
            performSegueWithIdentifier("ShowChecklist", sender: checklist)
        }
        
        self.tableView.tableFooterView = UIView()
    }

    // MARK: - TableView Data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        
        if cell == nil {
            
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }
        
        let checklist = dataModel.lists[indexPath.row]
        
        cell.textLabel!.text = checklist.name
        
        let itemsRemaining = checklist.countUncheckedItems()
        
        if checklist.items.count == 0 {
            cell.detailTextLabel!.text = "No items"
        }
        
        else if itemsRemaining == 0 {
            cell.detailTextLabel!.text = "All done!"
        } else {
            cell.detailTextLabel!.text = "\(itemsRemaining) remaining"
        }
        
        cell.imageView!.image = UIImage(named: checklist.iconName)
        
        cell.accessoryType = .DetailDisclosureButton
        
        return cell
    }
    
    // MARK: - TableView Delegate methods
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        dataModel.indexOfSelectedChecklist = indexPath.row
        
        let checklist = dataModel.lists[indexPath.row]
        
        performSegueWithIdentifier("ShowChecklist", sender: checklist)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        dataModel.lists.removeAtIndex(indexPath.row)
        
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    // Create and open a viewController by hand!
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        let navigationController = storyboard!.instantiateViewControllerWithIdentifier("ListNavigationController") as UINavigationController
        
        let listController = navigationController.topViewController as ListDetailViewController
        listController.delegate = self
        
        let checklist = dataModel.lists[indexPath.row]
        listController.listToEdit = checklist
        
        presentViewController(navigationController, animated: true, completion: nil)
        
    }
    
    // MARK: - Navigation methods
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowChecklist" {
            
            let controller = segue.destinationViewController as ChecklistViewController
            controller.checklist = sender as Checklist
        }
        
        if segue.identifier == "AddChecklist" {
            
            let navController = segue.destinationViewController as UINavigationController
            let listDetailController = navController.topViewController as ListDetailViewController
            
            listDetailController.delegate = self
            listDetailController.listToEdit = nil
        }
        
        if segue.identifier == "EditChecklist" {
            
            let navController = segue.destinationViewController as UINavigationController
            let listDetailController = navController.topViewController as ListDetailViewController
            
            listDetailController.delegate = self
            listDetailController.listToEdit = sender as? Checklist
        }
    }
    
    // MARK: - Helper methods
    func configureTextForCell(cell: UITableViewCell, withList list: Checklist){

        cell.textLabel?.text = list.name
    }
    
    // MARK: - ListDetailViewController Delegate methods
    func listDetailViewControllerDidCancel(controller: ListDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishEditingChecklist list: Checklist) {
        

        dataModel.sortChecklists()
        
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishAddingChecklist list: Checklist) {
        
        dataModel.lists.append(list)
        dataModel.sortChecklists()
        
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - UINavigationControllerDelegate methods
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    
    
    
    
    
}
