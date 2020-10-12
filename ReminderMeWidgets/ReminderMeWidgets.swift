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

struct RemindersWidget: Widget {
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: "dev.bene.reminders",
            intent: ViewRemindersIntent.self,
            provider: RemindersProvider()
        ) { entry in
            ReminderWidgeView(entry: entry)
        }
        .configurationDisplayName(NSLocalizedString("widget.reminders.title", comment: "widget.reminders.title"))
        .description(NSLocalizedString("widget.reminders.description", comment: "widget.reminders.description"))
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct CombinedWidget: Widget {
    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: "dev.bene.combined",
            intent: ViewCombinedIntent.self,
            provider: CombinedProvider()
        ) { entry in
            CombinedWidgetView(entry: entry)
        }
        .configurationDisplayName(NSLocalizedString("widget.combined.title", comment: "widget.combined.title"))
        .description(NSLocalizedString("widget.combined.description", comment: "widget.combined.description"))
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

@main
struct ReminderWidgets: WidgetBundle {
    
    @WidgetBundleBuilder
    var body: some Widget {
        RemindersWidget()
        CombinedWidget()
    }
}
