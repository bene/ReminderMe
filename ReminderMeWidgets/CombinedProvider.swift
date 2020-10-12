//
//  CombinedTimeline.swift
//  ReminderMeWidgetsExtension
//
//  Created by Benedict on 11.10.20.
//

import EventKit
import WidgetKit
import SwiftUI
import Intents

struct CombinedProvider: IntentTimelineProvider {
    
    let store = EKEventStore()
    
    func placeholder(in context: Context) -> CombinedEntry {
        CombinedEntry(reminders: [EKReminder](), events: [EKEvent](), date: Date(), configuration: ViewCombinedIntent())
    }

    func getSnapshot(for configuration: ViewCombinedIntent, in context: Context, completion: @escaping (CombinedEntry) -> ()) {
        
        let entry = CombinedEntry(reminders: [EKReminder](), events: [EKEvent](), date: Date(), configuration: ViewCombinedIntent())
        completion(entry)
    }

    func getTimeline(for configuration: ViewCombinedIntent, in context: Context, completion: @escaping (Timeline<CombinedEntry>) -> ()) {
        
        let endOfToday = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
        let entry = CombinedEntry(reminders: [EKReminder](), events: [EKEvent](), date: Date(), configuration: ViewCombinedIntent())
        
        let timeline = Timeline(
            entries:[entry],
            policy: .after(endOfToday)
        )

        completion(timeline)
    }
}


struct CombinedEntry: TimelineEntry {
    let reminders: [EKReminder]
    let events: [EKEvent]
    let date: Date
    let configuration: ViewCombinedIntent
}
