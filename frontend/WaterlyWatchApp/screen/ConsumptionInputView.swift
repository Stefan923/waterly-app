//
//  ConsumptionInputScreen.swift
//  Waterly Watch App
//
//  Created by Stefan Popescu on 28.04.2023.
//

import SwiftUI
import UIKit

struct ConsumptionInputView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var consumption: String = "100"
    @State private var showKeyboard: Bool = false
    
    var dataTransfer: DataTransferSender
    
    var body: some View {
        VStack(spacing: 5.0) {
            if true {
                ScrollView {
                    TextField("Enter Amount", text: $consumption)
                        .onTapGesture {
                            withAnimation() {
                                showKeyboard = true
                            }
                        }
                    Button("Confirm") {
                        self.dataTransfer.sendToSmartphone(
                            notificationId: "1",
                            consumption: Int(consumption) ?? 0,
                            status: "DONE")
                    }
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .padding([.top], 16.0)
        .sheet(isPresented: $showKeyboard) {
            KeyboardView(enteredNumber: consumption) { returnedFinished, returnedValue in
                withAnimation() {
                    showKeyboard = returnedFinished
                    consumption = returnedValue
                }
            }
        }
    }
}

struct ConsumptionInputView_Previews: PreviewProvider {
    static var previews: some View {
        ConsumptionInputView(dataTransfer: DataTransferSender())
    }
}
