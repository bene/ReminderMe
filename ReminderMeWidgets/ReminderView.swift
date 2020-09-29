//
//  ReminderView.swift
//  ReminderMeWidgetsExtension
//
//  Created by Benedict on 29.09.20.
//

import SwiftUI
import EventKit

struct ReminderView: View {
    
    var title: String
    var due: Date?
    var flag: Bool = false
    
    private func getDueText() -> String {
        
        if due == nil {
            return ""
        } else if (Calendar.current.isDateInToday(due!)) {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: due!)
        }
        
        return String(NSLocalizedString(Calendar.current.weekdaySymbols[Calendar.current.component(.weekday, from: due!) - 1], comment: "Weekday").prefix(2))
    }
    
    var body: some View {
        
        HStack {
            Text(title).font(.caption)
            Spacer()
            if due != nil {
                Text(getDueText()).font(.caption)
            }
        }
    }
}

struct ReminderView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderView(title: "Visit Anna", due: Date())
    }
}
