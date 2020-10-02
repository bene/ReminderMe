//
//  ReminderView.swift
//  ReminderMeWidgetsExtension
//
//  Created by Benedict on 29.09.20.
//

import SwiftUI
import EventKit

struct ReminderView: View {
    
    let title: String
    let due: Date?
    var flag: Bool = false
    
    private func getDueText() -> String? {
        
        if due == nil {
            return nil
        } else if (Calendar.current.isDateInToday(due!)) {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: due!)
        }
        
        return String(Calendar.current.shortWeekdaySymbols[Calendar.current.component(.weekday, from: due!) - 1])
    }
    
    var body: some View {
        
        HStack {
            Text(title).font(.caption)
            Spacer()
            if due != nil {
                Text(getDueText() ?? "").font(.caption)
            }
        }
    }
}

struct ReminderView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderView(title: "Visit Anna", due: Date())
    }
}
