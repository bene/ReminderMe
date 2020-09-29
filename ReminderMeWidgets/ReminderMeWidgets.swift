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

    func getTimeline(for configuration: ViewRemindersIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        let endOfToday = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
        
        let predicate: NSPredicate? = store.predicateForIncompleteReminders(
            withDueDateStarting: nil,
            ending: configuration.showOnlyToday == true ? endOfToday : nil,
            calendars: getCalendarsForConfiguration(configuration: configuration)
        )
        
        if let aPredicate = predicate {
            store.fetchReminders(matching: aPredicate, completion: {(_ reminders: [EKReminder]?) -> Void in
                
                let date = Date()
                let entry = RemindersEntry(
                    reminders: reminders ?? [],
                    date: date,
                    configuration: configuration
                )
                
                let nextUpdateDate = Calendar.current.date(byAdding: .second, value: 5, to: date)!
                
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

struct ReminderWidgetEntryView : View {
    
    var entry: Provider.Entry

    func getTitle() -> String {
        if entry.configuration.selectedLists?.count == 1 {
            return entry.configuration.selectedLists!.first!.displayString
        } else if entry.configuration.showOnlyToday ?? 0 == 1 {
            return "Heute"
        } else {
            return "Demnächst"
        }
    }
    
    func getColor() -> UIColor? {
        return entry.configuration.selectedLists?.first?.getColor()
    }
    
    var body: some View {
        VStack {
            HStack(content: {
                Text(getTitle()).bold().padding()
                Spacer()
            }).background(Color(UIColor.secondarySystemBackground))
            
            if (entry.reminders.isEmpty) {
                Spacer()
                Image(systemName: "checkmark.seal.fill").font(.largeTitle).foregroundColor(Color(UIColor.secondaryLabel))
                Text("Alles erledigt!").font(.caption).padding(.top).foregroundColor(Color(UIColor.secondaryLabel))
            } else {
                ForEach(entry.reminders, id: \.calendarItemIdentifier) { reminder in
                    ReminderView(title: reminder.title, due: reminder.dueDateComponents?.date)
                    Divider()
                }.padding(.horizontal)
            }
            
            Spacer()
        }.background(Color(UIColor.systemBackground))
    }
}

struct UpComingReminderWidget: Widget {
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: "dev.bene.reminder.upcoming",
            intent: ViewRemindersIntent.self,
            provider: Provider()
        ) { entry in
            ReminderWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Upcoming")
        .description("Zeigt die kommenden Erinnerungen ausgewählter Listen an.")
        .supportedFamilies([.systemMedium, .systemLarge])
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
            ReminderWidgetEntryView(entry: RemindersEntry(reminders: [], date: Date(), configuration: ViewRemindersIntent()))
                .previewContext(WidgetPreviewContext(family: .systemLarge)).colorScheme(.dark)
            ReminderWidgetEntryView(entry: RemindersEntry(reminders: [], date: Date(), configuration: ViewRemindersIntent()))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
            ReminderWidgetEntryView(entry: RemindersEntry(reminders: [], date: Date(), configuration: ViewRemindersIntent()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
