//
//  TimeInput.swift
//  Waterly
//
//  Created by Stefan Popescu on 10.06.2023.
//

import SwiftUI

struct TimeInput : View {
    var startHour: Binding<Date>
    var endHour: Binding<Date>
    
    private var minimumStartDate: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: endHour.wrappedValue)
        components.hour = 0
        components.minute = 0
        
        return calendar.date(from: components)!
    }
    
    private var maximumStartDate: Date {
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: endHour.wrappedValue)
        let currentMinute = calendar.component(.minute, from: endHour.wrappedValue)
        
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: endHour.wrappedValue)
        components.hour = min(16, max(0, currentHour - 8) % 24)
        components.minute = currentMinute
        
        return calendar.date(from: components)!
    }
    
    private var minimumEndDate: Date {
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: startHour.wrappedValue)
        let currentMinute = calendar.component(.minute, from: startHour.wrappedValue)
        
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: startHour.wrappedValue)
        components.hour = max(8, min(16, (currentHour + 8)) % 24)
        components.minute = currentMinute
        
        return calendar.date(from: components)!
    }
    
    private var maximumEndDate: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: endHour.wrappedValue)
        components.hour = 23
        components.minute = 59
        
        return calendar.date(from: components)!
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack(spacing: 0.0) {
                    Text(String("From "))
                        .foregroundColor(Color("TextFieldFontColor"))
                        .font(.system(size: 17).weight(.regular))
                        .frame(alignment: .leading)
                        .padding([.leading], 20.0)
                    
                    DatePicker("", selection: startHour, in: ...maximumStartDate, displayedComponents: [.hourAndMinute])
                        .datePickerStyle(CompactDatePickerStyle())
                        .labelsHidden()
                        .frame(alignment: .leading)
                        .colorScheme(.light)
                    
                    Text(String(" to "))
                        .foregroundColor(Color("TextFieldFontColor"))
                        .font(.system(size: 17).weight(.regular))
                        .frame(alignment: .leading)
                    
                    DatePicker("", selection: endHour, in: minimumEndDate..., displayedComponents: [.hourAndMinute])
                        .datePickerStyle(CompactDatePickerStyle())
                        .labelsHidden()
                        .frame(alignment: .leading)
                        .colorScheme(.light)
                    
                    Spacer(minLength: 0.0)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}

struct TimeInput_Previews : PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("TextFieldEdgeColor")
                .frame(width: 380.0, height: 60.0)
            TimeInput(startHour: Binding.constant(Date()), endHour: Binding.constant(Date()))
                .frame(width: 380.0, height: 60.0)
        }
    }
}
