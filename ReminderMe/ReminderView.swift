//
//  ReminderView.swift
//  ReminderMe
//
//  Created by Benedict on 04.10.20.
//

import SwiftUI

struct ReminderView: View {
    
    let title: String
    var done: Bool
    
    @ViewBuilder
    var body: some View {
        VStack {
            HStack {
                Image(systemName: !done ? "circle" : "largecircle.fill.circle")
                Text(title)
                Spacer()
            }
            Divider()
        }.padding([.horizontal])
        
    }
}

struct ReminderView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderView(title: "Meet Anna", done: false)
    }
}
