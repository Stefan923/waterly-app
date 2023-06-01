//
//  SignInWithEmailView.swift
//  Waterly
//
//  Created by Stefan Popescu on 27.03.2023.
//

import SwiftUI

struct SignInWithEmailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var router: Router
    
    @Binding var isAuthenticated: Bool
    @Binding var emailBinding: String
    
    @State private var email = ""
    @State private var password = ""
    @State private var wrongCredentials = false
    @State private var isLoading = false
    @State private var errorAlert: ErrorAlert?
    
    @ObservedObject var viewModel = AuthenticationService()
    
    @FocusState private var focusedField: Field?
    
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
                            Text("Sign in using your email:")
                                .foregroundColor(Color("TextFieldFontColor"))
                                .font(.system(size: 20).weight(.semibold))
                                .padding([.bottom], 16.0)
                            
                            TextField(text: $email, prompt: Text("E-mail").foregroundColor(Color("TextFieldPlaceholderColor"))) {
                                Text("E-mail")
                            }
                            .textFieldStyle(OutlinedTextFieldStyle(corners: [.topLeft, .topRight], isWrongValue: $wrongCredentials))
                            .focused($focusedField, equals: .email)
                            .padding([.leading, .trailing], 6.0)
                            .frame(height: 60.0)
                            
                            SecureField(text: $password, prompt: Text("Password").foregroundColor(Color("TextFieldPlaceholderColor"))) {
                                Text("Password")
                            }
                            .textFieldStyle(OutlinedTextFieldStyle(corners: [.bottomLeft, .bottomRight], isWrongValue: $wrongCredentials))
                            .focused($focusedField, equals: .password)
                            .padding([.leading, .trailing], 6.0)
                            .frame(height: 60.0)
                            
                            if wrongCredentials {
                                HStack {
                                    Image("error-icon")
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                    
                                    Text("Wrong username or password!")
                                        .foregroundColor(Color("ErrorRedColor"))
                                        .font(.system(size: 18).weight(.regular))
                                }
                                .padding([.top], 16.0)
                            }
                        }
                        .frame(alignment: .top)
                        .padding([.leading, .trailing], 24.0)
                        
                        Spacer()
                        
                        VStack(spacing: 0) {
                            RoundedButton(title: "Continue",
                                          backgroundColor: Color("PrimaryColor"),
                                          foregroundColor: .white,
                                          maxWidth: 140) {
                                isLoading.toggle()
                                viewModel.loginUsingCredentials(email, password, self.signInSuccess, self.signInFailure)
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
        .onChange(of: [email, password]) { credentials in
            wrongCredentials = false
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
    
    private func signInFailure(statusCode: Int) -> Void {
        switch statusCode {
        case 401:
            wrongCredentials = true
            break
        case 403:
            emailBinding = email
            router.push("ConfirmAccountView")
            break
        default:
            self.errorAlert = ErrorAlert(title: "Error", message: "Couldn't connect to server in order to confirm your authentication data.")
        }
        
        isLoading.toggle()
    }
    
    private func signInSuccess() -> Void {
        isAuthenticated = true
        router.clear()
        
        isLoading.toggle()
    }
}

extension SignInWithEmailView {
    private enum Field: Int, CaseIterable {
        case email, password
    }
    
    private func focusPreviousField() {
        focusedField = focusedField.map {
            Field(rawValue: $0.rawValue - 1) ?? .email
        }
    }
    
    private func focusNextField() {
        focusedField = focusedField.map {
            Field(rawValue: $0.rawValue + 1) ?? .password
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

struct SignInWithEmailView_Previews: PreviewProvider {
    static var previews: some View {
        SignInWithEmailView(isAuthenticated: Binding.constant(false),
                            emailBinding: Binding.constant(""))
    }
}
