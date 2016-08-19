//
//  MessageHelper.swift
//  FinputTest
//
//  Created by Benjamin Lim on 25/07/2016.
//  Copyright © 2016 Benjamin Lim. All rights reserved.
//

import UIKit
import CoreData

extension FinController {
    
    func clearData() {
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            do {
                
                let entityNames = ["Message"]
                
                for entityName in entityNames {
                    let fetchRequest =  NSFetchRequest(entityName: entityName)
                    
                    let objects = try (context.executeFetchRequest(fetchRequest)) as? [NSManagedObject]
                    
                    for object in objects! {
                        context.deleteObject(object)
                    }
                }
                
                try(context.save())
                
            } catch let err {
                print (err)
            }

        }
    }
    
    //Data is set-up
    
    func setupData() {
        clearData()
        
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        let introMessage = "Hello there. My name is Finn, I'm here to help you with your finances. On the left of this page, there is a directory to help you out if you are slightly confused on how I can help you. On the right of this page is where I store all the information you want me to keep for you. I'm glad to be at your service. :)"
        
        if let context = delegate?.managedObjectContext {
           FinController.createMessageWithText(introMessage, minutesAgo: 0, context: context)
            
            do {
                try (context.save())
            } catch let err {
                print (err)
            }
        }
        
        loadData()
        
    }
    

    static func createMessageWithText (text: String , minutesAgo: Double, context: NSManagedObjectContext, isSender: Bool = false) -> Message {
        let message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: context) as! Message
        message.text = text
        message.date = NSDate().dateByAddingTimeInterval(-minutesAgo * 60)
        message.isSender = NSNumber(bool: isSender)
        return message
    }
    
    func loadData() {
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        if let context = delegate?.managedObjectContext {
            
            messages = [Message]()

            let fetchRequest = NSFetchRequest(entityName: "Message")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key:"date", ascending: false)]
            fetchRequest.fetchLimit = 1
            
            do {
                let fetchedMessages = try (context.executeFetchRequest((fetchRequest)) as? [Message])
                messages?.appendContentsOf(fetchedMessages!)
            } catch let err {
                print (err)
            }
            
            messages = messages?.sort({$0.date?.compare($1.date!) == .OrderedDescending})
        }
    }
    
//    private func fetchMessages() -> [Message]? {
//        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
//        
//        if let context = delegate?.managedObjectContext {
//            let request = NSFetchRequest(entityName: "Message")
//            
//            do {
//                return try context.executeFetchRequest(request) as? [Message]
//            } catch let err {
//                print (err)
//            }
//        }
//        return nil
//    }
    
}
