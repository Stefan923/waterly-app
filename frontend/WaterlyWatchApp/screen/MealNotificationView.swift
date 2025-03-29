//
//  MealNotificationView.swift
//  Waterly Watch App
//
//  Created by Stefan Popescu on 19.06.2023.
//

import SwiftUI

struct MealNotificationView: View {
    @StateObject private var router = Router()
    private var dataTransfer = DataTransferSender()
    
    private var notificationData: Binding<[AnyHashable: Any]>
    private var onFinish: () -> Void
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeToComplete: TimeInterval = 30 * 60
    @State private var timerDisplay: String = "00:00"
    
    @State private var defaultConsumption: String = "0"
    @State private var showingCommunicationAlert: Bool = false
    @State private var disableButtons: Bool = false
    
    init(
        notificationData: Binding<[AnyHashable : Any]>,
        onFinish: @escaping () -> Void
    ) {
        self.notificationData = notificationData
        self.onFinish = onFinish
    }
    
    var body: some View {
        NavigationStack(path: $router.navPath) {
            VStack(spacing: 10) {
                ScrollView(.vertical) {
                    VStack {
                        Text("It's time to eat!")
                            .lineLimit(10)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(timerDisplay)
                            .lineLimit(10)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Button("Confirm") {
                        router.push("ConsumptionInputView")
                    }
                    .disabled(self.disableButtons)
                    
                    Button("Postphone") {
                        self.disableButtons = true
                        if self.dataTransfer.sendToSmartphone(
                            notificationId: notificationData["id"].wrappedValue as! String,
                            consumption: 0,
                            status: "POSTPHONED") {
                            self.onFinish()
                        } else {
                            self.disableButtons = false
                            self.showingCommunicationAlert = true
                        }
                    }
                    .disabled(self.disableButtons)
                    
                    Button("Cancel") {
                        self.disableButtons = true
                        if self.dataTransfer.sendToSmartphone(
                            notificationId: notificationData["id"].wrappedValue as! String,
                            consumption: 0,
                            status: "CANCELED") {
                            self.onFinish()
                        } else {
                            self.disableButtons = false
                            self.showingCommunicationAlert = true
                        }
                    }
                    .disabled(self.disableButtons)
                }
            }
            .navigationDestination(for: String.self) { view in
                if (view == "ConsumptionInputView") {
                    ConsumptionInputView(notificationId: notificationData["id"].wrappedValue as! String, consumption: defaultConsumption, dataTransfer: self.dataTransfer, onFinish: self.onFinish)
                        .navigationTitle {
                            HStack {
                                Text("Waterly")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("PrimaryColor"))
                                    .frame(alignment: .leading)
                                
                                Spacer(minLength: 0.0)
                            }
                        }
                }
            }
            .onAppear(perform: {
                defaultConsumption = "\(notificationData["defaultCaloriesConsumption"].wrappedValue as! Int)"
            })
            .onReceive(timer) { _ in
                if timeToComplete > 0 {
                    timeToComplete -= 1
                    timerDisplay = TimeIntervalConverter.formatTimeInterval(timeToComplete)
                }
            }
            .navigationTitle {
                HStack {
                    Text("Waterly")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color("PrimaryColor"))
                        .frame(alignment: .leading)
                    
                    Spacer(minLength: 0.0)
                }
            }
            .alert(isPresented: $showingCommunicationAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text("Couldn't communicate to iPhone."),
                    dismissButton: .default(Text("Close"))
                )
            }
        }
        .environmentObject(router)
    }
}

struct MealNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        let notificationData: [AnyHashable: Any] = [
            "defaultCaloriesConsumption": 150
        ]
        MealNotificationView(notificationData: Binding.constant(notificationData), onFinish: {})
    }
}
