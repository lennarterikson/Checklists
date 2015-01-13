//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Lennart Erikson on 05/01/15.
//  Copyright (c) 2015 Lennart Erikson. All rights reserved.
//

import Foundation
import UIKit

class ChecklistItem: NSObject, NSCoding {
    
    var text = ""
    var checked = false
    
    var dueDate = NSDate()
    var shouldRemind = false
    var itemID: Int
    
    convenience init(text: String) {
        self.init(text: text, checked: false)
    }
    
    init(text: String, checked: Bool){
        
        self.text = text
        self.checked = checked
        itemID = DataModel.nextChecklistItemID()
        
        super.init()
    }
    
    // Called when object is about to get deleted permanetely
    deinit{
        
        let existingNotification = notificationForThisItem()
        
        if let notification = existingNotification {
            
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
    }
    
    func toggleChecked(){

        checked = !checked
    }
    
    
    // MARK: - NSCoding protocoll methods
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeBool(checked, forKey: "Checked")
        aCoder.encodeObject(dueDate, forKey: "DueDate")
        aCoder.encodeBool(shouldRemind, forKey: "ShouldRemind")
        aCoder.encodeInteger(itemID, forKey: "ItemID")
    }
    
    required init(coder aDecoder: NSCoder) {
        
        text = aDecoder.decodeObjectForKey("Text") as String
        checked = aDecoder.decodeBoolForKey("Checked")
        dueDate = aDecoder.decodeObjectForKey("DueDate") as NSDate
        shouldRemind = aDecoder.decodeBoolForKey("ShouldRemind")
        itemID = aDecoder.decodeIntegerForKey("ItemID")
        
        
        super.init()
    }
    
    // MARK: - Notifications
    func notificationForThisItem() -> UILocalNotification? {
        
        let allNotifications = UIApplication.sharedApplication().scheduledLocalNotifications as [UILocalNotification]
        
        for notification in allNotifications {
            
            if let number = notification.userInfo?["ItemID"] as? NSNumber {
                
                if number.integerValue == itemID {
                    return notification
                }
            }
        }
        
        return nil
    }
    
    func scheduleNotification() {
        
        // First check if a notification is already set up and scheduled
        let existingNotification = notificationForThisItem()
        
        if let notification = existingNotification {
            
            // cancel notification
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
        
        // Ascending: DueDate is after now (NSDate())
        if shouldRemind && dueDate.compare(NSDate()) != NSComparisonResult.OrderedAscending {
        
            let localNotification = UILocalNotification()
            localNotification.fireDate = dueDate
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.alertBody = text
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.userInfo = ["ItemID": itemID]
            
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }
        
    }
}