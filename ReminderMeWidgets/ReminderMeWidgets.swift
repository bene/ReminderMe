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
        
        let endOfToday = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
        
        let predicate: NSPredicate? = store.predicateForIncompleteReminders(
            withDueDateStarting: nil,
            ending: configuration.showOnlyToday == true ? endOfToday : nil,
            calendars: getCalendarsForConfiguration(configuration: configuration)
        )
        
        if let aPredicate = predicate {
            store.fetchReminders(matching: aPredicate, completion: {(_ reminders: [EKReminder]?) -> Void in
                completion(RemindersEntry(reminders: reminders ?? [], date: Date(), configuration: configuration))
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
                
                let nextUpdateDate = Calendar.current.date(byAdding: .second, value: 15, to: now)!
                
                let timeline = Timeline(
                    entries:[entry],
                    policy: .after(nextUpdateDate)
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
            kind: "dev.bene.reminder.upcoming",
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
