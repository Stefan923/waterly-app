//
//  ConfirmAccountView.swift
//  Waterly
//
//  Created by Stefan Popescu on 03.04.2023.
//

import SwiftUI

struct ConfirmAccountView: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var router: Router
    
    @Binding var emailBinding: String
    
    @State private var confirmCode = ""
    @State private var isConfirmCodeWrong = false
    @State private var isLoading = false
    @State private var errorAlert: ErrorAlert?
    
    @FocusState private var focusedField: Field?
    
    @ObservedObject var viewModel = AuthenticationService()
    
    @Binding var isAuthenticated : Bool
    
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
                        VStack(spacing: 0) {
                            Text("To finish creating your account, enter the verification code we sent to your email address:")
                                .foregroundColor(Color("TextFieldFontColor"))
                                .font(.system(size: 20).weight(.semibold))
                                .padding([.bottom], 16.0)
                            
                            TextField(text: $confirmCode, prompt: Text("000000").foregroundColor(Color("TextFieldPlaceholderColor"))) {
                                Text("000000")
                            }
                            .textFieldStyle(OutlinedTextFieldStyle(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], isWrongValue: $isConfirmCodeWrong))
                            .focused($focusedField, equals: .confirmCode)
                            .padding([.leading, .trailing], 6.0)
                            .keyboardType(.numberPad)
                            .frame(height: 60.0)
                            .padding([.bottom], 16.0)
                            
                            Button(action: {
                                isLoading = true
                                viewModel.requestConfirmCode(emailBinding, self.codeRequestSuccess, self.codeRequestFailure)
                            }) {
                                Text("Resend confirmation code")
                                    .font(.system(size: 18).weight(.regular))
                                    .foregroundColor(.blue)
                                    .underline()
                            }
                            
                            if isConfirmCodeWrong {
                                HStack {
                                    Image("error-icon")
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                    
                                    Text("The confirmation code should match the 6-digits code we've sent you on email.")
                                        .foregroundColor(Color("ErrorRedColor"))
                                        .font(.system(size: 18).weight(.regular))
                                }
                                .padding([.top], 16.0)
                            }
                        }
                        .frame(alignment: .top)
                        .padding([.leading, .trailing], 36.0)
                        
                        Spacer()
                        
                        VStack(spacing: 0) {
                            RoundedButton(title: "Continue",
                                          backgroundColor: Color("PrimaryColor"),
                                          foregroundColor: .white,
                                          maxWidth: 140) {
                                isLoading = true
                                viewModel.confirmUserAccount(UserAccountConfirmation(email: emailBinding, confirmCode: confirmCode), self.confirmSuccess, self.confirmFailure)
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
        .onChange(of: confirmCode) { confirmCode in
            isConfirmCodeWrong = false
        }
        .alert(item: $errorAlert) { error in
            Alert(title: Text(error.title), message: Text(error.message), dismissButton: .default(Text("Close")))
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button(action: focusPreviousField) {
                    Image(systemName: "chevron.up")
                }
                .disabled(!canFocusPreviousField())
            }
            
            ToolbarItem(placement: .keyboard) {
                Button(action: focusNextField) {
                    Image(systemName: "chevron.down")
                }
                .disabled(!canFocusNextField())
            }
        }
        .ignoresSafeArea(.keyboard)
    }
    
    private func codeRequestFailure(statusCode: Int) -> Void {
        switch statusCode {
        default:
            self.errorAlert = ErrorAlert(title: "Error", message: "Couldn't connect to server in order to send a new confirmation code.")
        }
        
        isLoading.toggle()
    }
    
    private func codeRequestSuccess() -> Void {
        self.errorAlert = ErrorAlert(title: "Success", message: "A confirmation code has been sent to your email.")
        
        isLoading.toggle()
    }
    
    private func confirmFailure(statusCode: Int) -> Void {
        switch statusCode {
        default:
            self.errorAlert = ErrorAlert(title: "Error", message: "Couldn't connect to server in order to confirm your account.")
        }
        
        isLoading.toggle()
    }
    
    private func confirmSuccess() -> Void {
        isAuthenticated = true
        router.clear()
        
        isLoading.toggle()
    }
}

extension ConfirmAccountView {
    private enum Field: Int, CaseIterable {
        case confirmCode
    }
    
    private func focusPreviousField() {
        focusedField = focusedField.map {
            Field(rawValue: $0.rawValue - 1) ?? .confirmCode
        }
    }
    
    private func focusNextField() {
        focusedField = focusedField.map {
            Field(rawValue: $0.rawValue + 1) ?? .confirmCode
        }
    }
    
    private func canFocusPreviousField() -> Bool {
        guard let currentFocusedField = focusedField else {
            return false
        }
        return currentFocusedField.rawValue > 0
    }
    
    private func canFocusNextField() -> Bool {
        guard let currentFocusedField = focusedField else {
            return false
        }
        return currentFocusedField.rawValue < Field.allCases.count - 1
    }
}

struct ConfirmAccountView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmAccountView(emailBinding: Binding.constant(""),
                           isAuthenticated: Binding.constant(false))
    }
}
