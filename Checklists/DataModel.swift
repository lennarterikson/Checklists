//
//  DataModel.swift
//  Checklists
//
//  Created by Lennart Erikson on 07/01/15.
//  Copyright (c) 2015 Lennart Erikson. All rights reserved.
//

import Foundation

class DataModel {
    
    var lists = [Checklist]()
    
    var indexOfSelectedChecklist: Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey("ChecklistIndex")
        }
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "ChecklistIndex")
        }
    }
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    // MARK: - NSUserDefaults helper methods
    func registerDefaults(){
        
        let defaults = ["ChecklistIndex" : -1,
                        "FirstTime": true,
                        "ChecklistItemID": 0]
        
        NSUserDefaults.standardUserDefaults().registerDefaults(defaults)
    }
    
    func handleFirstTime(){
        
        let firstTime = NSUserDefaults.standardUserDefaults().boolForKey("FirstTime")
        
        if firstTime {
            
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            indexOfSelectedChecklist = 0
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "FirstTime")
            
        }
    }
    
    // MARK: - Saving to disk methods
    func documentsDirectory() -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String]
        
        return paths[0]
    }
    
    func dataFilePath() -> String {
        
        return documentsDirectory().stringByAppendingPathComponent("Checklists.plist")
    }
    
    func saveChecklists() {
        
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        
        archiver.encodeObject(lists, forKey: "Checklists")
        archiver.finishEncoding()
        
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func loadChecklists() {
        
        let path = dataFilePath()
        
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            
            if let data = NSData(contentsOfFile: path) {
                
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                lists = unarchiver.decodeObjectForKey("Checklists") as [Checklist]
                
                unarchiver.finishDecoding()
                
                sortChecklists()
            }
        }
    }
    
    class func nextChecklistItemID() -> Int {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let itemID = userDefaults.integerForKey("ChecklistItemID")
        
        userDefaults.setInteger(itemID + 1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        
        return itemID
    }
    
    // MARK: - Sorting
    func sortChecklists() {
    
        lists.sort({checklist1, checklist2 in return
            checklist1.name.localizedStandardCompare(checklist2.name)
                == NSComparisonResult.OrderedAscending
        })
    }
}