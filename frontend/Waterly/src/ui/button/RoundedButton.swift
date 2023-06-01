//
//  RoundedButton.swift
//  Waterly
//
//  Created by Stefan Popescu on 12.03.2023.
//

import SwiftUI

struct RoundedButton: View {
    
    private static let buttonHorizontalMargins: CGFloat = 20
    
    var backgroundColor: Color
    var foregroundColor: Color
    
    private let icon: Image?
    private let title: String
    private let maxWidth: CGFloat
    private let action: () -> Void
    
    private let disabled: Bool
    
    init(title: String,
         icon: Image? = nil,
         disabled: Bool = false,
         backgroundColor: Color = Color.black,
         foregroundColor: Color = Color.white,
         maxWidth: CGFloat = .greatestFiniteMagnitude,
         action: @escaping () -> Void) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.icon = icon
        self.title = title
        self.action = action
        self.maxWidth = maxWidth
        self.disabled = disabled
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Spacer(minLength: RoundedButton.buttonHorizontalMargins)
                Button(action: self.action) {
                    HStack {
                        if icon != nil {
                            icon?
                                .resizable()
                                .frame(width: 19,
                                       height: 19)
                                .padding(.trailing, 5)
                        }
                        
                        Text(self.title)
                            .font(.system(size: 20)
                                .weight(.semibold))
                        
                    }
                    .frame(width: min(maxWidth, geometry.size.width * 0.65))
                }
                .buttonStyle(RoundedButtonStyle(backgroundColor: backgroundColor,
                                                foregroundColor: foregroundColor,
                                                isDisabled: disabled))
                .disabled(self.disabled)
                Spacer(minLength: RoundedButton.buttonHorizontalMargins)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: 70)
    }
}

struct RoundedButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RoundedButton(title: "Sign in with Apple",
                          icon: Image("apple-logo-white"),
                          backgroundColor: .black) {
                print("Ola!")
            }
            
            RoundedButton(title: "Sign in with Apple",
                          backgroundColor: .black) {
                print("Ola!")
            }
        }
    }
}
