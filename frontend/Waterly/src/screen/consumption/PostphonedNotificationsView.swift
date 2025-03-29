//
//  PostphonedNotificationsView.swift
//  Waterly
//
//  Created by Stefan Popescu on 04.05.2023.
//

import SwiftUI

struct PostphonedNotificationsView : View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var router: Router
    
    @Binding var selectedConsumption: Consumption?
    
    @State private var isLoading = true
    @State private var consumptions: [Consumption] = []
    var consumptionService = ConsumptionService()
    
    @State private var errorAlert: ErrorAlert?
    
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
                            Text("Delayed Notifications")
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
                                VStack(spacing: 0.0) {
                                    ForEach(consumptions) { consumption in
                                        self.createConsumptionView(geometry, consumption)
                                    }
                                    
                                    Spacer(minLength: 0.0)
                                }
                            }
                            .frame(width: geometry.size.width * 0.80, height: geometry.size.height * 0.80)
                            .cornerRadius(14)
                            
                            if isLoading {
                                Color("LoadingBackgroundColor")
                                    .frame(width: geometry.size.width * 0.80, height: geometry.size.height * 0.80)
                                    .cornerRadius(14)
                                ProgressView()
                                    .colorScheme(.light)
                            }
                        }
                    }
                    .padding([.top], geometry.size.height * 0.06)
                }
            }
            .onAppear() {
                self.isLoading = true
                self.loadPostphonedNotifications()
            }
            .alert(item: $errorAlert) { error in
                Alert(title: Text(error.title), message: Text(error.message), dismissButton: .default(Text("Close")))
            }
        }
    }
    
    @ViewBuilder
    private func createConsumptionView(_ geometry: GeometryProxy, _ consumption: Consumption) -> some View {
        let title = consumption.createdAt.toTitle
        if (consumption == consumptions.first) {
            if (consumption == consumptions.last) {
                RoundedCornersButton(title: title,
                                     radius: 0.20,
                                     corners: [.all],
                                     buttonWidth: geometry.size.width * 0.80) {
                    selectedConsumption = consumption
                    router.push("PostphonedNotificationView")
                }
                .frame(alignment: .top)
            } else {
                RoundedCornersButton(title: title,
                                     radius: 0.20,
                                     corners: [.top],
                                     buttonWidth: geometry.size.width * 0.80) {
                    selectedConsumption = consumption
                    router.push("PostphonedNotificationView")
                }
                .frame(alignment: .top)
            }
        } else if (consumption == consumptions.last) {
            RoundedCornersButton(title: title,
                                 radius: 0.20,
                                 corners: [.bottom],
                                 buttonWidth: geometry.size.width * 0.80) {
                selectedConsumption = consumption
                router.push("PostphonedNotificationView")
            }
            .frame(alignment: .top)
        } else {
            RoundedCornersButton(title: title,
                                 radius: 0.20,
                                 corners: [],
                                 buttonWidth: geometry.size.width * 0.80) {
                selectedConsumption = consumption
                router.push("PostphonedNotificationView")
            }
            .frame(alignment: .top)
        }
    }
    
    private func loadPostphonedNotifications() -> Void {
        if let userId = UserAccountTokenManager.shared.getUserAccountToken()?.getUserId() {
            consumptionService.getConsumptionsByUserIdAndConsumptionStatus(
                userId: userId, consumptionStatus: .POSTPHONED, page: 0,
                size: 50, completion: { result in
                    switch result {
                    case .success(let consumptionsDto):
                        self.consumptions = consumptionsDto.consumptions
                        break
                    case.failure(let error):
                        self.errorAlert = ErrorAlert(title: "Error", message: "\(error)")
                        break
                    }
                    isLoading = false
                })
        }
    }
}

struct UncertainGesturesView_Previews: PreviewProvider {
    static var previews: some View {
        @State var consumption: Consumption? = nil
        PostphonedNotificationsView(selectedConsumption: $consumption)
    }
}
