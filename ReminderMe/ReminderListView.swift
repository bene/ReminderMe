//
//  ReminderListView.swift
//  ReminderMe
//
//  Created by Benedict on 04.10.20.
//

import SwiftUI
import EventKit

struct ReminderListView: View {
    
    let title: String
    let color: Color
    let reminders: [EKReminder]
    
    init(title: String, color: Color, reminders: [EKReminder]) {
        self.title = title
        self.color = color
        self.reminders = reminders
        
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(color)]
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(color)]
    }
    
    var body: some View {
        VStack {
            
            
            
            
            if reminders.isEmpty {
                Spacer()
                Text(NSLocalizedString("list.empty", comment: "list.empty"))
            } else {
                List(reminders, id: \.calendarItemIdentifier) { reminder in
                    ReminderView(title: reminder.title, done: reminder.isCompleted)
                }
            }
            
            Spacer()
            HStack {
                Image(systemName: "plus.circle.fill")
                Text(NSLocalizedString("reminder.new", comment: "reminder.new"))
            }.frame(maxWidth: .infinity, alignment: .leading).foregroundColor(color).font(.body)
        }.padding([.horizontal, .bottom]).navigationTitle(title).font(.system(.body, design: .rounded))
    }
}

struct ReminderListView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderListView(title: "Reminders", color: Color(UIColor.systemBlue), reminders: [])
    }
}
