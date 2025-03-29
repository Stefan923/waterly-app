//
//  DrinkActivityDetectedView.swift
//  Waterly Watch App
//
//  Created by Stefan Popescu on 30.06.2023.
//

import SwiftUI

struct DrinkActivityDetectedView: View {
    @StateObject private var router = Router()
    private var dataTransfer = DataTransferSender()
    
    private var onFinish: () -> Void
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeToComplete: TimeInterval = 2 * 60
    @State private var timerDisplay: String = "02:00"
    
    @State private var defaultConsumption: String
    @State private var showingCommunicationAlert: Bool = false
    
    init(
        defaultConsumption: Int,
        onFinish: @escaping () -> Void
    ) {
        self.defaultConsumption = "\(defaultConsumption)"
        self.onFinish = onFinish
    }
    
    var body: some View {
        NavigationStack(path: $router.navPath) {
            VStack(spacing: 10) {
                ScrollView(.vertical) {
                    VStack {
                        Text("I've noticed a drinking activity! Did you have something to drink recently?")
                            .lineLimit(10)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 2)
                        Text(timerDisplay)
                            .lineLimit(10)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Button("Confirm") {
                        router.push("ConsumptionInputView")
                    }
                    
                    Button("Cancel") {
                        self.onFinish()
                    }
                }
            }
            .navigationDestination(for: String.self) { view in
                if (view == "ConsumptionInputView") {
                    ConsumptionInputView(notificationId: "new_entry", consumption: defaultConsumption, dataTransfer: self.dataTransfer, onFinish: self.onFinish)
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

struct DrinkActivityDetectedView_Previews: PreviewProvider {
    static var previews: some View {
        DrinkActivityDetectedView(defaultConsumption: 150, onFinish: {})
    }
}
