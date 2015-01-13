//
//  Checklist.swift
//  Checklists
//
//  Created by Lennart Erikson on 07/01/15.
//  Copyright (c) 2015 Lennart Erikson. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
    
    // MARK: - iVars
    var name: String
    var items = [ChecklistItem]()
    var iconName: String = "No Icon"
    
    convenience init(name: String) {
        
        self.init(name: name, iconName: "No Icon")
    }
    
    init(name: String, iconName: String){
        
        self.name = name
        self.iconName = iconName
        
        super.init()
    }
    
    // MARK: - NSCoding Delegate
    required init(coder aDecoder: NSCoder) {
        
        items = aDecoder.decodeObjectForKey("Items") as [ChecklistItem]
        name = aDecoder.decodeObjectForKey("Name") as String
        iconName = aDecoder.decodeObjectForKey("IconName") as String
        
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
     
        aCoder.encodeObject(items, forKey: "Items")
        aCoder.encodeObject(name, forKey: "Name")
        aCoder.encodeObject(iconName, forKey: "IconName")
    }
    
    // MARK: - Checklist methods
    func countUncheckedItems() -> Int {
        
        var count = 0
        
        for item in items {
            
            if !item.checked {
                
                count++
            }
        }
        
        return count
    }
    
    
}