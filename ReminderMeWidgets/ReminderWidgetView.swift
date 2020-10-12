//
//  ReminderWidgetView.swift
//  ReminderMeWidgetsExtension
//
//  Created by Benedict on 03.10.20.
//

import SwiftUI
import WidgetKit

struct ReminderWidgeView : View {
    
    @Environment(\.widgetFamily)
    var family
    var entry: RemindersProvider.Entry

    func getTitle() -> String {
        if entry.configuration.selectedLists?.count == 1 {
            return entry.configuration.selectedLists!.first!.displayString
        } else if entry.configuration.showOnlyToday == true {
            return NSLocalizedString("today", comment: "today").capitalized
        } else {
            return NSLocalizedString("upcoming", comment: "upcoming").capitalized
        }
    }
    
    func maxLines() -> Int {
        switch family {
        case .systemSmall:
            return 3
        case .systemMedium:
            return 3
        default:
            return 10
        }
    }
    
    func getColor() -> UIColor? {
        return entry.configuration.selectedLists?.first?.getColor()
    }
    
    @ViewBuilder
    var body: some View {
        VStack {
            Group {
                HStack {
                    Text(getTitle()).bold()
                    Spacer()
                }.padding()
            }.background(Color(UIColor.secondarySystemBackground)).shadow(radius: 1)
            
            if entry.reminders.isEmpty {
                Spacer()
                Image(systemName: "checkmark.seal.fill").font(.largeTitle).foregroundColor(Color(UIColor.secondaryLabel))
                Text(NSLocalizedString("widget.done.all", comment: "widget.done.all")).font(.caption).padding(.top, 2)
                Spacer()
            } else {
                
                ForEach(0..<(entry.reminders.count > maxLines() ? maxLines()-1 : entry.reminders.count)) { i in
                    ReminderItemView(
                        title: entry.reminders[i].title,
                        due: entry.reminders[i].dueDateComponents?.date
                    )
                    if i != entry.reminders.count-1 {
                        Divider()
                    }
                }.padding(.horizontal)
                
                Spacer()
                
                if entry.reminders.count > maxLines() {
                    Text("+ \(entry.reminders.count - (maxLines()-1)) \(NSLocalizedString("widget.more", comment: "widget.more"))").font(.caption2).padding([.horizontal, .bottom])
                }
            }
        }.background(Color(UIColor.systemBackground))
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
