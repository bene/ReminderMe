//
//  ContentView.swift
//  ReminderMe
//
//  Created by Benedict on 29.09.20.
//

import SwiftUI
import EventKit

struct ContentView: View {
    
    let store = EKEventStore()
    
    func getAuthorizationStatus() -> EKAuthorizationStatus {
        return EKEventStore.authorizationStatus(for: EKEntityType.reminder)
    }
    
    @ViewBuilder
    var body: some View {
        TabView {
            Section {
                Text("Add")
                    
                    
            }.tabItem {
                Image(systemName: "list.bullet")
                Text("First Tab")
              }
            NavigationView {
                Form {
                    Section {
                        HStack {
                            switch getAuthorizationStatus() {
                            case EKAuthorizationStatus.authorized:
                                Image(systemName: "checkmark.circle.fill").foregroundColor(Color(UIColor.systemGreen)).padding(.trailing)
                                Text(NSLocalizedString("access.granted", comment: "access.granted"))
                            case EKAuthorizationStatus.denied:
                                Image(systemName: "xmark.octagon.fill").foregroundColor(Color(UIColor.systemRed)).padding(.trailing)
                                Text(NSLocalizedString("access.denied", comment: "access.denied"))
                            default:
                                Button(action: {
                                    store.requestAccess(to: .reminder) { (_, _) in
                                        
                                    }
                                }) {
                                    Text(NSLocalizedString("access.request", comment: "access.request"))
                                }
                            }
                        }
                    }
                }.navigationTitle(NSLocalizedString("configuration", comment: "configuration"))
            }.tabItem {
                Image(systemName: "gear")
                Text(NSLocalizedString("configuration", comment: "configuration"))
              }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
