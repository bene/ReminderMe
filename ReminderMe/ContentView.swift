//
//  ContentView.swift
//  ReminderMe
//
//  Created by Benedict on 29.09.20.
//

import SwiftUI
import EventKit
import WidgetKit

struct ContentView: View {
    
    let store = EKEventStore()
    
    func getAuthorizationStatus() -> EKAuthorizationStatus {
        return EKEventStore.authorizationStatus(for: EKEntityType.reminder)
    }
    
    @ViewBuilder
    var body: some View {
        NavigationView {
            Button(action: {
                store.requestAccess(to: .reminder) { (_, _) in
                    
                }
            }) {
                Text(NSLocalizedString("access.request", comment: "access.request"))
            }
            List {
                NavigationLink(destination : ReminderListView(title: "Reminders", color: Color(UIColor.systemGreen), reminders: [])) {
                    Text("Settings")
                }
            }.navigationBarItems(trailing: Button("Bearbeiten", action: {
                
            }))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
