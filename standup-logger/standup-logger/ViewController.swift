//
//  ViewController.swift
//  standup-logger
//
//  Created by Rob Drimmie on 2019-02-03.
//  Copyright © 2019 Rob Drimmie. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var yesterday: NSTextField!
    @IBOutlet weak var today: NSTextField!
    @IBOutlet weak var blockers: NSTextField!
    @IBOutlet weak var status: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    @IBAction func onStandupDone(_ sender: Any) {
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let standupEntity = NSEntityDescription.entity(forEntityName: "Standup", in: managedContext)
        
        let newStandup = NSManagedObject(entity: standupEntity!, insertInto: managedContext)
        newStandup.setValue(yesterday.stringValue, forKey: "yesterday")
        newStandup.setValue(today.stringValue, forKey: "today")//
        newStandup.setValue(blockers.stringValue, forKey: "blockers")
        newStandup.setValue(Date(), forKey:"created")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd mm yyyy"
        
        let result = formatter.string(from: newStandup.value(forKey: "created") as! Date)
        
        status.stringValue = result
        
        foo()
    }
    
    func foo() {
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
//        let standupEntity = NSEntityDescription.entity(forEntityName: "Standup", in: managedContext)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Standup")

        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "yesterday") as! String)
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    
}

