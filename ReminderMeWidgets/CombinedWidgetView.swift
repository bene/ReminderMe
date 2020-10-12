//
//  CombinedWidgetView.swift
//  ReminderMeWidgetsExtension
//
//  Created by Benedict on 11.10.20.
//

import SwiftUI
import EventKit

struct CombinedWidgetView: View {
    
    @Environment(\.widgetFamily)
    var family
    var entry: CombinedProvider.Entry
    
    var body: some View {
        Text("Hallo Welt")
    }
}

struct CombinedWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        CombinedWidgetView(entry: CombinedEntry(reminders: [EKReminder](), events: [EKEvent](), date: Date(), configuration: ViewCombinedIntent()))
    }
}
