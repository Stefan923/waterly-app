//
//  KeyboardView.swift
//  Waterly Watch App
//
//  Created by Stefan Popescu on 06.05.2023.
//

import SwiftUI
import WatchKit

struct KeyboardView: View {
    @State var enteredNumber: String
    var action: (Bool, String) -> Void
    @State private var digitalCrownNumber: Double
    
    init(enteredNumber: String,
         action: @escaping (Bool, String) -> Void) {
        self.enteredNumber = enteredNumber
        self.digitalCrownNumber = (Double(enteredNumber) ?? 0.0) / 25
        self.action = action
    }
    
    var body: some View {
        VStack {
            Text(String("\(enteredNumber)"))
                .focusable()
                .digitalCrownRotation($digitalCrownNumber, from: 0.0, through: 399.0, by: 1, sensitivity: .medium)
                .font(.system(size: 24).weight(.semibold))
                .onChange(of: digitalCrownNumber) { newValue in
                    enteredNumber = String(Int(newValue * 25))
                }
            ForEach(0...2, id: \.self) { i in
                HStack {
                    ForEach(1...3, id: \.self) { j in
                        Button(String("\(i * 3 + j)")) {
                            if enteredNumber.count < 4 {
                                enteredNumber += String(i * 3 + j)
                                digitalCrownNumber = (Double(enteredNumber) ?? 0) / 25
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(width: 50, height: 35)
                        .background(Color("KeyboardButtonColor"))
                        .cornerRadius(24.0)
                    }
                }
            }
            HStack {
                Button(action: {
                    if enteredNumber.count > 1 {
                        enteredNumber.removeLast()
                        digitalCrownNumber = (Double(enteredNumber) ?? 0) / 25
                    } else if enteredNumber != "0" {
                        enteredNumber = "0"
                        digitalCrownNumber = 0.0
                    }
                }) {
                    HStack(spacing: 4) {
                        Image("delete-icon")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .frame(width: 50, height: 35)
                .cornerRadius(24.0)
                Button(String("0")) {
                    if enteredNumber.count < 4 {
                        enteredNumber += "0"
                        digitalCrownNumber = (Double(enteredNumber) ?? 0) / 25
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .frame(width: 50, height: 35)
                .background(Color("KeyboardButtonColor"))
                .cornerRadius(24.0)
                Button(action: {
                    if enteredNumber == "" {
                        enteredNumber = "0"
                    }
                    self.action(false, enteredNumber)
                }) {
                    HStack(spacing: 4) {
                        Image("enter-icon")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .frame(width: 50, height: 35)
                .cornerRadius(24.0)
            }
        }
        .padding([.top], 18.0)
    }
}

struct KeyboardView_Previews: PreviewProvider {
    static var previews: some View {
        @State var value: String = "150"
        @State var finished: Bool = false
        
        if !finished {
            KeyboardView(enteredNumber: "100") { returnedFinished, returnedValue in
                withAnimation() {
                    finished = returnedFinished
                    value = returnedValue
                }
            }
        } else {
            Text("\(value)")
        }
    }
}
