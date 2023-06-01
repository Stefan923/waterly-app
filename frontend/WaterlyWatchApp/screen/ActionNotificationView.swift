//
//  ActionNotificationView.swift
//  Waterly Watch App
//
//  Created by Stefan Popescu on 18.11.2022.
//

import SwiftUI

struct ActionNotificationView: View {
    @StateObject private var router = Router()
    private var dataTransfer = DataTransferSender()
    
    @State private var showingCommunicationAlert: Bool = false
    
    var body: some View {
        NavigationStack(path: $router.navPath) {
            VStack(spacing: 10) {
                ScrollView(.vertical) {
                    VStack {
                        Text("It's time to drink!")
                            .lineLimit(10)
                            .fixedSize(horizontal: false, vertical: true)
                        Text("01:58")
                            .lineLimit(10)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Button("Confirm") {
                        router.push("ConsumptionInputView")
                    }
                    Button("Postphone") {
                        if !self.dataTransfer.sendToSmartphone(
                            notificationId: "1",
                            consumption: 0,
                            status: "POSTPHONED") {
                            showingCommunicationAlert = true
                        }
                    }
                    Button("Cancel") {
                        if !self.dataTransfer.sendToSmartphone(
                            notificationId: "1",
                            consumption: 0,
                            status: "CANCELED") {
                            showingCommunicationAlert = true
                        }
                    }
                }
            }
            .navigationDestination(for: String.self) { view in
                if (view == "ConsumptionInputView") {
                    ConsumptionInputView(dataTransfer: self.dataTransfer)
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

struct ActionNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        ActionNotificationView()
    }
}
