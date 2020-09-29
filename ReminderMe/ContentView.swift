//
//  ContentView.swift
//  ReminderMe
//
//  Created by Benedict on 29.09.20.
//

import SwiftUI
import EventKit

struct ContentView: View {
    
    var body: some View {
        Button(action: {
            let store = EKEventStore()
            
            store.requestAccess(to: .reminder) { (_, _) in
                
            }
        }) {
            Text("Request authorization")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
