//
//  AddConsumptionView.swift
//  Waterly
//
//  Created by Stefan Popescu on 27.06.2023.
//

import SwiftUI

struct AddConsumptionView: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var router: Router
    
    @State private var isLoading = false
    @State private var errorAlert: ErrorAlert?
    
    @State private var consumptionType: ConsumptionType = .LIQUID
    @State private var quantity = 0
    
    @State private var userSettings: UserSettings? = nil
    
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
                                isLoading.toggle()
                                createConsumption()
                            }
                            
                            RoundedButton(title: "Cancel",
                                          backgroundColor: .white,
                                          foregroundColor: .black,
                                          maxWidth: 140) {
                                dismiss()
                            }
                        }
                        .frame(alignment: .bottom)
                    }
                    .padding([.top], geometry.size.height * 0.16)
                    .padding([.bottom], geometry.size.height * 0.08)
                }
                
                if isLoading {
                    Color("LoadingBackgroundColor").ignoresSafeArea()
                }
            }
        }
        .alert(item: $errorAlert) { error in
            Alert(title: Text(error.title), message: Text(error.message), dismissButton: .default(Text("Close")))
        }
        .onChange(of: consumptionType, perform: { _ in
            updateQuantityWithDefaultValue()
        })
        .onAppear(perform: {
            updateQuantityWithDefaultValue()
        })
    }
    
    private func createFormView() -> some View {
        VStack(spacing: 0) {
            OutlinedConsumptionTypePicker(consumptionType: $consumptionType, radius: 0.25, corners: [.top])
                .colorScheme(.light)
                .frame(width: 370.0, height: 60.0)
            OutlinedIncrementalInput(value: $quantity, measureUnit: consumptionType == .LIQUID ? "ml" : "cal", incrementStep: 25, minValue: 1, maxValue: 2000, radius: 0.25, corners: [.bottom])
                .frame(width: 370.0, height: 60.0)
        }
        .frame(alignment: .top)
        .padding([.leading, .trailing], 24.0)
    }
    
    private func updateQuantityWithDefaultValue() -> Void {
        userSettings = UserSettingsManager.shared.getUserSettings()
        if let userSettings = userSettings {
            if consumptionType == .LIQUID {
                quantity = userSettings.defaultLiquidsConsumption
            } else {
                quantity = userSettings.defaultCaloriesConsumption
            }
        }
    }
    
    private func createConsumption() -> Void {
        if let userId = UserAccountTokenManager.shared.getUserAccountToken()?.getUserId() {
            ConsumptionService().createConsumption(consumption: ConsumptionRequest(userId, consumptionType, .DONE, Float(quantity)),
                completion: { result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        dismiss()
                    }
                    break
                case .failure(let error):
                    isLoading.toggle()
                    self.errorAlert = ErrorAlert(title: "Error", message: "\(error)")
                    break
                }
            })
        }
    }
}

struct AddConsumptionView_Previews: PreviewProvider {
    static var previews: some View {
        AddConsumptionView()
    }
}
