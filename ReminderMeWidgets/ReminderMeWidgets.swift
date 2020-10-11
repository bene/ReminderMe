//
//  ReminderMeWidgets.swift
//  ReminderMeWidgets
//
//  Created by Benedict on 29.09.20.
//

import EventKit
import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    
    let store = EKEventStore()
    
    func getCalendarsForConfiguration(configuration: ViewRemindersIntent) -> [EKCalendar]? {
        if let cLists = configuration.selectedLists {
            var lists = [EKCalendar]()
            
            cLists.forEach { optionalList in
                if let list = store.calendar(withIdentifier: optionalList.identifier ?? "") {
                    lists.append(list)
                }
            }
            return lists
        }
        return nil
    }
    
    func placeholder(in context: Context) -> RemindersEntry {
        RemindersEntry(reminders: [], date: Date(), configuration: ViewRemindersIntent())
    }

    func getSnapshot(for configuration: ViewRemindersIntent, in context: Context, completion: @escaping (RemindersEntry) -> ()) {
        
        let now = Date()
        let startOfToday = Calendar.current.startOfDay(for: now)
        let endOfToday = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: now)!)
        
        let predicate: NSPredicate? = store.predicateForIncompleteReminders(
            withDueDateStarting: nil,
            ending: nil,
            calendars: getCalendarsForConfiguration(configuration: configuration)
        )
        
        if let aPredicate = predicate {
            store.fetchReminders(matching: aPredicate, completion: {(_ reminders: [EKReminder]?) -> Void in
                
                var processedReminders = configuration.showOnlyToday == true ? reminders?.filter { $0.dueDateComponents == nil || $0.dueDateComponents?.date ?? now < endOfToday } : reminders
                processedReminders = processedReminders!.sorted { $0.dueDateComponents?.date ?? startOfToday < $1.dueDateComponents?.date ?? startOfToday }
                
                let entry = RemindersEntry(
                    reminders: processedReminders ?? [],
                    date: now,
                    configuration: configuration
                )

                completion(entry)
            })
        }
    }

    func getTimeline(for configuration: ViewRemindersIntent, in context: Context, completion: @escaping (Timeline<RemindersEntry>) -> ()) {
        
        let now = Date()
        let startOfToday = Calendar.current.startOfDay(for: now)
        let endOfToday = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: now)!)
        
        let predicate: NSPredicate? = store.predicateForIncompleteReminders(
            withDueDateStarting: nil,
            ending: nil,
            calendars: getCalendarsForConfiguration(configuration: configuration)
        )
        
        if let aPredicate = predicate {
            store.fetchReminders(matching: aPredicate, completion: {(_ reminders: [EKReminder]?) -> Void in
                
                var processedReminders = configuration.showOnlyToday == true ? reminders?.filter { $0.dueDateComponents == nil || $0.dueDateComponents?.date ?? now < endOfToday } : reminders
                processedReminders = processedReminders!.sorted { $0.dueDateComponents?.date ?? startOfToday < $1.dueDateComponents?.date ?? startOfToday }
                
                let entry = RemindersEntry(
                    reminders: processedReminders ?? [],
                    date: now,
                    configuration: configuration
                )
                
                let timeline = Timeline(
                    entries:[entry],
                    policy: .after(endOfToday)
                )

                completion(timeline)
            })
        }
    }
}

struct RemindersEntry: TimelineEntry {
    let reminders: [EKReminder]
    let date: Date
    let configuration: ViewRemindersIntent
}

struct UpComingReminderWidget: Widget {
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: "dev.bene.reminders",
            intent: ViewRemindersIntent.self,
            provider: Provider()
        ) { entry in
            ReminderWidgeView(entry: entry)
        }
        .configurationDisplayName(NSLocalizedString("widget.title", comment: "widget.title"))
        .description(NSLocalizedString("widget.description", comment: "widget.description"))
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

@main
struct ReminderWidgets: WidgetBundle {
    
    let store = EKEventStore()
    var observer: Any
    
    init() {
        observer = NotificationCenter.default.addObserver(forName: .EKEventStoreChanged, object: store, queue: .main) { _ in
            WidgetCenter.shared.reloadTimelines(ofKind: "dev.bene.reminders")
        }
    }
    
    @WidgetBundleBuilder
    var body: some Widget {
        UpComingReminderWidget()
    }
}

struct ReminderWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ReminderWidgeView(entry: RemindersEntry(reminders: [], date: Date(), configuration: ViewRemindersIntent()))
                .previewContext(WidgetPreviewContext(family: .systemLarge)).colorScheme(.dark)
            ReminderWidgeView(entry: RemindersEntry(reminders: [], date: Date(), configuration: ViewRemindersIntent()))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
            ReminderWidgeView(entry: RemindersEntry(reminders: [], date: Date(), configuration: ViewRemindersIntent()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            ReminderWidgeView(entry: RemindersEntry(reminders: [], date: Date(), configuration: ViewRemindersIntent()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
