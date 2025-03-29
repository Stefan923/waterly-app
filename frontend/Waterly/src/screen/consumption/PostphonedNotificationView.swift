//
//  PostphonedNotificationView.swift
//  Waterly
//
//  Created by Stefan Popescu on 01.07.2023.
//

import SwiftUI

struct PostphonedNotificationView: View {
    @Environment(\.dismiss) private var dismiss
    
    let consumption: Consumption?
    
    @State private var isLoading = false
    @State private var errorAlert: ErrorAlert?
    
    @State private var quantity = 0
    
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
                        self.createFormView()
                        
                        Spacer()
                        
                        VStack(spacing: 0) {
                            RoundedButton(title: "Confirm",
                                          backgroundColor: Color("PrimaryColor"),
                                          foregroundColor: .white,
                                          maxWidth: 140) {
                                isLoading = true
                                updateConsumption(.DONE)
                            }
                            
                            RoundedButton(title: "Cancel",
                                          backgroundColor: .white,
                                          foregroundColor: .black,
                                          maxWidth: 140) {
                                isLoading = true
                                updateConsumption(.CANCELED)
                            }
                        }
                        .frame(alignment: .bottom)
                    }
                    .padding([.top], geometry.size.height * 0.15)
                    .padding([.bottom], geometry.size.height * 0.08)
                }
                
                if isLoading {
                    Color("LoadingBackgroundColor").ignoresSafeArea()
                    ProgressView()
                }
            }
        }
        .alert(item: $errorAlert) { error in
            Alert(title: Text(error.title), message: Text(error.message), dismissButton: .default(Text("Close")))
        }
        .onAppear(perform: {
            if let userSettings = UserSettingsManager.shared.getUserSettings(),
               let consumption = consumption {
                if consumption.consumptionType == .LIQUID {
                    quantity = userSettings.defaultLiquidsConsumption
                } else {
                    quantity = userSettings.defaultCaloriesConsumption
                }
            }
        })
    }
    
    private func createFormView() -> some View {
        VStack(spacing: 0) {
            if let consumption = consumption {
                Text(consumption.consumptionType == .LIQUID ? "It's time to drink!" : "It's time to eat!")
                    .foregroundColor(Color("TextFieldFontColor"))
                    .font(.system(size: 20).weight(.semibold))
                    .padding([.bottom], 16.0)
                
                OutlinedIncrementalInput(value: $quantity, measureUnit: consumption.consumptionType == .LIQUID ? "ml" : "cal", incrementStep: 25, minValue: 0, maxValue: 2000, radius: 0.25, corners: [.all])
                    .frame(width: 300.0, height: 60.0)
            }
        }
        .frame(alignment: .top)
        .padding([.leading, .trailing], 24.0)
    }
    
    private func updateConsumption(_ consumptionStatus: ConsumptionStatus) -> Void {
        if let consumption = consumption {
            ConsumptionService().updateConsumption(consumption: ConsumptionUpdateRequest(
                id: consumption.id,
                consumptionStatus: consumptionStatus,
                quantity: consumptionStatus == .DONE ? Float(self.quantity) : 0
            ), completion: { result in
                switch result {
                case .success(_):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        dismiss()
                        isLoading = false
                    }
                    break
                case .failure(let error):
                    self.errorAlert = ErrorAlert(title: "Error", message: "\(error)")
                    isLoading = false
                    break
                }
            })
        }
    }
}

struct PostphonedNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        let consumption: Consumption = Consumption(
            id: "1", consumptionType: .LIQUID, consumptionStatus: .NO_ENTRY,
            quantity: 0, createdAt: Date.now, modifiedAt: Date.now)
        PostphonedNotificationView(consumption: consumption)
    }
}
