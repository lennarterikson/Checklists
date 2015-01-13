//
//  IconPickerController.swift
//  Checklists
//
//  Created by Lennart Erikson on 08/01/15.
//  Copyright (c) 2015 Lennart Erikson. All rights reserved.
//

import UIKit

protocol IconPickerControllerDelegate: class {
    func iconPicker(picker: IconPickerController, didPickIcon iconName: String)
}

class IconPickerController: UITableViewController {
    

    // MARK: - iVars
    weak var delegate: IconPickerControllerDelegate?
    
    let icons = ["No Icon", "Appointments", "Birthdays", "Chores", "Drinks", "Folder", "Groceries",
    "Inbox", "Photos", "Trips"]
    
    // MARK: - TableView DataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return icons.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("IconCell") as UITableViewCell
        
        let iconName = icons[indexPath.row]
        
        cell.textLabel!.text = iconName
        cell.imageView!.image = UIImage(named: iconName)
        
        return cell
    }
    
    // MARK: - TableView Delegate methods
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){

        if let delegate = self.delegate {
            
            let icon = icons[indexPath.row]
            
            delegate.iconPicker(self, didPickIcon: icon)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
