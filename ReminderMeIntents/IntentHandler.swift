//
//  IntentHandler.swift
//  ReminderMeIntents
//
//  Created by Benedict on 29.09.20.
//

import Intents
import EventKit
import SwiftUI

class IntentHandler: INExtension, ViewRemindersIntentHandling {
    
    let store = EKEventStore()
    
    func provideSelectedListsOptionsCollection(for intent: ViewRemindersIntent, with completion: @escaping (INObjectCollection<ReminderList>?, Error?) -> Void) {
        
        let lists: [ReminderList] = store.calendars(for: EKEntityType.reminder).map { list in
            
            let reminderList = ReminderList(
                identifier: list.calendarIdentifier,
                display: list.title
            )
            
            if list.cgColor.components?.count == 4 {
                let color = [
                    Double(list.cgColor.components![0]),
                    Double(list.cgColor.components![1]),
                    Double(list.cgColor.components![2]),
                    Double(list.cgColor.components![3]),
                ]
                reminderList.color = color
            }
            
            return reminderList
        }
        
        let collection = INObjectCollection(items: lists)
        completion(collection, nil)
    }
    
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
}

extension ReminderList {
    
    func getColor() -> UIColor? {
        if color?.count == 4 {
            return UIColor.init(
                red: CGFloat.init(color![0]),
                green: CGFloat.init(color![1]),
                blue: CGFloat.init(color![2]),
                alpha: CGFloat.init(color![3])
            )
        }
        
        return nil
    }
}
