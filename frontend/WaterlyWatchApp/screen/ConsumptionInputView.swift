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
    
    @State private var showKeyboard: Bool = false
    @State private var disableButtons: Bool = false
    
    var notificationId: String
    @State var consumption: String
    var dataTransfer: DataTransferSender
    var onFinish: () -> Void
    
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
                        self.disableButtons = true
                        if self.dataTransfer.sendToSmartphone(
                            notificationId: self.notificationId,
                            consumption: Int(consumption) ?? 0,
                            status: "DONE") {
                            self.onFinish()
                        } else {
                            self.disableButtons = false
                        }
                    }
                    .disabled(self.disableButtons)
                    
                    Button("Cancel") {
                        dismiss()
                    }
                    .disabled(self.disableButtons)
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
        ConsumptionInputView(notificationId: "test-id", consumption: "0", dataTransfer: DataTransferSender(), onFinish: {})
    }
}
