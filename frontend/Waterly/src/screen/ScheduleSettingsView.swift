//
//  ScheduleSettingsView.swift
//  Waterly
//
//  Created by Stefan Popescu on 10.06.2023.
//

import SwiftUI

struct ScheduleSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var router: Router
    
    @State private var mondayStartHour: Date
    @State private var mondayEndHour: Date
    @State private var tuesdayStartHour: Date
    @State private var tuesdayEndHour: Date
    @State private var wednesdayStartHour: Date
    @State private var wednesdayEndHour: Date
    @State private var thursdayStartHour: Date
    @State private var thursdayEndHour: Date
    @State private var fridayStartHour: Date
    @State private var fridayEndHour: Date
    @State private var saturdayStartHour: Date
    @State private var saturdayEndHour: Date
    @State private var sundayStartHour: Date
    @State private var sundayEndHour: Date
    
    @State private var errorAlert: ErrorAlert?
    
    private var userSettingsService = UserSettingsService()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color("PrimaryColor")
                    .ignoresSafeArea(.all, edges: .all)
                
                ZStack {
                    VStack {
                        Spacer()
                        
                        WaveEdgedRectangle()
                            .fill(Color("SecondaryColor"))
                            .shadow(color: .black.opacity(0.25), radius: 15, x: 0, y: -10)
                            .frame(height: geometry.size.height * 0.98, alignment: .bottom)
                    }
                    .frame(height: geometry.size.height * 1.05)
                    
                    VStack {
                        HStack {
                            Text("Notifications schedule")
                                .foregroundColor(Color("TextFieldFontColor"))
                                .font(.system(size: 20).weight(.bold))
                                .padding([.bottom], 9.0)
                                .frame(alignment: .leading)
                            
                            Spacer()
                        }
                        .padding([.horizontal], geometry.size.width * 0.10)
                        
                        ZStack {
                            RoundedCornersRectangle(radius: 0.02, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
                                .fill(.white.shadow(.drop(radius: 2)))
                                .frame(width: geometry.size.width * 0.80, height: geometry.size.height * 0.80)
                            
                            ScrollView(.vertical) {
                                self.createScheduleListView(geometry.size.width * 0.80)
                            }
                            .frame(width: geometry.size.width * 0.80, height: geometry.size.height * 0.80)
                            .cornerRadius(14)
                        }
                    }
                    .padding([.top], geometry.size.height * 0.06)
                }
            }
        }
        .onDisappear(perform: {
            self.saveScheduleSettings()
        })
        .alert(item: $errorAlert) { error in
            Alert(title: Text(error.title), message: Text(error.message), dismissButton: .default(Text("Close")))
        }
    }
    
    private func createScheduleListView(_ buttonWidth: CGFloat) -> some View {
        VStack(spacing: 0.0) {
            DropdownButton(title: "Monday",
                           
                           radius: 0.20,
                           corners: [.top],
                           expandedCorners: [.top],
                           buttonWidth: buttonWidth) {
                VStack(spacing:0.0) {
                    TimeInput(startHour: $mondayStartHour, endHour: $mondayEndHour)
                }
            }.frame(alignment: .top)
            
            DropdownButton(title: "Tuesday",
                           radius: 0.20,
                           corners: [],
                           expandedCorners: [],
                           buttonWidth: buttonWidth) {
                TimeInput(startHour: $tuesdayStartHour, endHour: $tuesdayEndHour)
            }.frame(alignment: .top)
            
            DropdownButton(title: "Wednesday",
                           radius: 0.20,
                           corners: [],
                           expandedCorners: [],
                           buttonWidth: buttonWidth) {
                TimeInput(startHour: $wednesdayStartHour, endHour: $wednesdayEndHour)
            }.frame(alignment: .top)
            
            DropdownButton(title: "Thursday",
                           radius: 0.20,
                           corners: [],
                           expandedCorners: [],
                           buttonWidth: buttonWidth) {
                TimeInput(startHour: $thursdayStartHour, endHour: $thursdayEndHour)
            }.frame(alignment: .top)
            
            DropdownButton(title: "Friday",
                           radius: 0.20,
                           corners: [],
                           expandedCorners: [],
                           buttonWidth: buttonWidth) {
                TimeInput(startHour: $fridayStartHour, endHour: $fridayEndHour)
            }.frame(alignment: .top)
            
            DropdownButton(title: "Saturday",
                           radius: 0.20,
                           corners: [],
                           expandedCorners: [],
                           buttonWidth: buttonWidth) {
                TimeInput(startHour: $saturdayStartHour, endHour: $saturdayEndHour)
            }.frame(alignment: .top)
            
            DropdownButton(title: "Sunday",
                           radius: 0.20,
                           corners: [],
                           expandedCorners: [],
                           buttonWidth: buttonWidth) {
                TimeInput(startHour: $sundayStartHour, endHour: $sundayEndHour)
            }.frame(alignment: .top)
            
            Spacer(minLength: 0.0)
        }
    }
    
    init() {
        let scheduleSettings = UserSettingsManager.shared.getUserSettings()?.scheduleSettings
        
        _mondayStartHour = State(initialValue: DateTimeConverter.convertTimeToDate(from: scheduleSettings?.monday.startHour ?? Time(hour: 0, minute: 0)) ?? Date())
        _mondayEndHour = State(initialValue: DateTimeConverter.convertTimeToDate(from: scheduleSettings?.monday.endHour ?? Time(hour: 0, minute: 0)) ?? Date())
        _tuesdayStartHour = State(initialValue: DateTimeConverter.convertTimeToDate(from: scheduleSettings?.tuesday.startHour ?? Time(hour: 0, minute: 0)) ?? Date())
        _tuesdayEndHour = State(initialValue: DateTimeConverter.convertTimeToDate(from: scheduleSettings?.tuesday.endHour ?? Time(hour: 0, minute: 0)) ?? Date())
        _wednesdayStartHour = State(initialValue: DateTimeConverter.convertTimeToDate(from: scheduleSettings?.wednesday.startHour ?? Time(hour: 0, minute: 0)) ?? Date())
        _wednesdayEndHour = State(initialValue: DateTimeConverter.convertTimeToDate(from: scheduleSettings?.wednesday.endHour ?? Time(hour: 0, minute: 0)) ?? Date())
        _thursdayStartHour = State(initialValue: DateTimeConverter.convertTimeToDate(from: scheduleSettings?.thursday.startHour ?? Time(hour: 0, minute: 0)) ?? Date())
        _thursdayEndHour = State(initialValue: DateTimeConverter.convertTimeToDate(from: scheduleSettings?.thursday.endHour ?? Time(hour: 0, minute: 0)) ?? Date())
        _fridayStartHour = State(initialValue: DateTimeConverter.convertTimeToDate(from: scheduleSettings?.friday.startHour ?? Time(hour: 0, minute: 0)) ?? Date())
        _fridayEndHour = State(initialValue: DateTimeConverter.convertTimeToDate(from: scheduleSettings?.friday.endHour ?? Time(hour: 0, minute: 0)) ?? Date())
        _saturdayStartHour = State(initialValue: DateTimeConverter.convertTimeToDate(from: scheduleSettings?.saturday.startHour ?? Time(hour: 0, minute: 0)) ?? Date())
        _saturdayEndHour = State(initialValue: DateTimeConverter.convertTimeToDate(from: scheduleSettings?.saturday.endHour ?? Time(hour: 0, minute: 0)) ?? Date())
        _sundayStartHour = State(initialValue: DateTimeConverter.convertTimeToDate(from: scheduleSettings?.sunday.startHour ?? Time(hour: 0, minute: 0)) ?? Date())
        _sundayEndHour = State(initialValue: DateTimeConverter.convertTimeToDate(from: scheduleSettings?.sunday.endHour ?? Time(hour: 0, minute: 0)) ?? Date())
    }
    
    private func saveScheduleSettings() -> Void {
        let userSettings = UserSettingsManager.shared.getUserSettings()
        if let userSettings = userSettings {
            var scheduleSettings = userSettings.scheduleSettings
            
            scheduleSettings.monday.startHour = DateTimeConverter.convertDateToTime(from: $mondayStartHour.wrappedValue)
            scheduleSettings.monday.endHour = DateTimeConverter.convertDateToTime(from: $mondayEndHour.wrappedValue)
            scheduleSettings.tuesday.startHour = DateTimeConverter.convertDateToTime(from: $tuesdayStartHour.wrappedValue)
            scheduleSettings.tuesday.endHour = DateTimeConverter.convertDateToTime(from: $tuesdayEndHour.wrappedValue)
            scheduleSettings.wednesday.startHour = DateTimeConverter.convertDateToTime(from: $wednesdayStartHour.wrappedValue)
            scheduleSettings.wednesday.endHour = DateTimeConverter.convertDateToTime(from: $wednesdayEndHour.wrappedValue)
            scheduleSettings.thursday.startHour = DateTimeConverter.convertDateToTime(from: $thursdayStartHour.wrappedValue)
            scheduleSettings.thursday.endHour = DateTimeConverter.convertDateToTime(from: $thursdayEndHour.wrappedValue)
            scheduleSettings.friday.startHour = DateTimeConverter.convertDateToTime(from: $fridayStartHour.wrappedValue)
            scheduleSettings.friday.endHour = DateTimeConverter.convertDateToTime(from: $fridayEndHour.wrappedValue)
            scheduleSettings.saturday.startHour = DateTimeConverter.convertDateToTime(from: $saturdayStartHour.wrappedValue)
            scheduleSettings.saturday.endHour = DateTimeConverter.convertDateToTime(from: $saturdayEndHour.wrappedValue)
            scheduleSettings.sunday.startHour = DateTimeConverter.convertDateToTime(from: $sundayStartHour.wrappedValue)
            scheduleSettings.sunday.endHour = DateTimeConverter.convertDateToTime(from: $sundayEndHour.wrappedValue)
            
            userSettings.scheduleSettings = scheduleSettings
            
            UserSettingsManager.shared.setUserSettings(userSettings)
            self.userSettingsService.updateUserSettings(userSettings: userSettings, completion: { result in
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    self.errorAlert = ErrorAlert(title: "Error", message: "\(error)")
                }
            })
        }
    }
}

enum Day: String, CaseIterable {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday
}

struct ScheduleSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleSettingsView()
    }
}
