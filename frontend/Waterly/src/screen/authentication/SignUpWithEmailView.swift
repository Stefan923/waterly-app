//
//  SignUpWithEmailView.swift
//  Waterly
//
//  Created by Stefan Popescu on 22.03.2023.
//

import SwiftUI

struct SignUpWithEmailView: View {
    private let emailValidator: Validator = EmailValidator()
    private let passwordValidator: Validator = PasswordValidator()
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var router: Router
    
    @Binding var emailBinding: String
    @Binding var userAccount: UserAccount
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmedPassword = ""
    
    @State private var isEmailUsed = false
    @State private var isEmailInvalid = false
    @State private var isPasswordInvalid = false
    @State private var isConfirmedPasswordInvalid = false
    
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
                        self.createFormView()
                        
                        Spacer()
                        
                        VStack(spacing: 10) {
                            RoundedButton(title: "Continue",
                                          backgroundColor: Color("PrimaryColor"),
                                          foregroundColor: .white,
                                          maxWidth: 140) {
                                self.confirmUserAccount()
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
            }
        }
        .onChange(of: email) { email in
            self.isEmailUsed = false
            self.isEmailInvalid = false
        }
        .onChange(of: password) { password in
            self.isPasswordInvalid = false
        }
        .onChange(of: confirmedPassword) { confirmedPassword in
            self.isConfirmedPasswordInvalid = false
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
    
    private func createFormView() -> some View {
        VStack(spacing: 0) {
            Text("Sign up using your email:")
                .foregroundColor(Color("TextFieldFontColor"))
                .font(.system(size: 20).weight(.semibold))
                .padding([.bottom], 16.0)
            
            TextField(text: $email, prompt: Text("E-mail").foregroundColor(Color("TextFieldPlaceholderColor"))) {
                Text("E-mail")
            }
            .textFieldStyle(OutlinedTextFieldStyle(corners: [.topLeft, .topRight], isWrongValue: Binding.constant(isEmailInvalid || isEmailUsed)))
            .keyboardType(.emailAddress)
            .textContentType(.username)
            .textInputAutocapitalization(.never)
            .focused($focusedField, equals: .email)
            .padding([.leading, .trailing], 6.0)
            .frame(height: 60.0)
            
            SecureField(text: $password, prompt: Text("Password").foregroundColor(Color("TextFieldPlaceholderColor"))) {
                Text("Password")
            }
            .textFieldStyle(OutlinedTextFieldStyle(corners: [], isWrongValue: $isPasswordInvalid))
            .textContentType(.password)
            .focused($focusedField, equals: .password)
            .padding([.leading, .trailing], 6.0)
            .frame(height: 60.0)
            
            SecureField(text: $confirmedPassword, prompt: Text("Confirm password").foregroundColor(Color("TextFieldPlaceholderColor"))) {
                Text("Password")
            }
            .textFieldStyle(OutlinedTextFieldStyle(corners: [.bottomLeft, .bottomRight], isWrongValue: $isConfirmedPasswordInvalid))
            .textContentType(.password)
            .focused($focusedField, equals: .confirmedPassword)
            .padding([.leading, .trailing], 6.0)
            .frame(height: 60.0)
            
            if isEmailInvalid {
                HStack {
                    Image("error-icon")
                        .resizable()
                        .frame(width: 16, height: 16)
                    
                    Text("Email should be like: email@example.com")
                        .lineLimit(nil)
                        .foregroundColor(Color("ErrorRedColor"))
                        .font(.system(size: 18).weight(.regular))
                }
                .padding([.top], 16.0)
            } else if isEmailUsed {
                HStack {
                    Image("error-icon")
                        .resizable()
                        .frame(width: 16, height: 16)
                    
                    Text("This email address is already used.")
                        .lineLimit(nil)
                        .foregroundColor(Color("ErrorRedColor"))
                        .font(.system(size: 18).weight(.regular))
                }
                .padding([.top], 16.0)
            } else if isPasswordInvalid {
                HStack {
                    Image("error-icon")
                        .resizable()
                        .frame(width: 16, height: 16)
                    
                    Text("The password should be between 8 and 32 characters long and it should contain an uppercase letter, a lowercase letter and a digit.")
                        .lineLimit(nil)
                        .foregroundColor(Color("ErrorRedColor"))
                        .font(.system(size: 18).weight(.regular))
                }
                .padding([.top], 16.0)
                .fixedSize(horizontal: false, vertical: true)
            } else if isConfirmedPasswordInvalid {
                HStack {
                    Image("error-icon")
                        .resizable()
                        .frame(width: 16, height: 16)
                    
                    Text("The password and the confirmed password should be equal.")
                        .lineLimit(nil)
                        .foregroundColor(Color("ErrorRedColor"))
                        .font(.system(size: 18).weight(.regular))
                }
                .padding([.top], 16.0)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(alignment: .top)
        .padding([.leading, .trailing], 36.0)
    }
    
    private func confirmUserAccount() -> Void {
        var isUserAccountValid = true
        
        if !emailValidator.validate(email) {
            isUserAccountValid = false
            isEmailInvalid = true
        }
        
        if !passwordValidator.validate(password) {
            isUserAccountValid = false
            isPasswordInvalid = true
            isConfirmedPasswordInvalid = true
        }
        
        if password != confirmedPassword {
            isUserAccountValid = false
            isConfirmedPasswordInvalid = true
        }
        
        if isUserAccountValid {
            self.userAccount.email = self.email
            self.userAccount.password = self.password
            self.viewModel.validateEmail(self.email, self.validateSuccess, self.validateFailure)
        }
    }
    
    private func validateFailure(_ statusCode: Int) -> Void {
        self.isEmailUsed = true
        self.isLoading.toggle()
    }

    private func validateSuccess() -> Void {
        DispatchQueue.main.async {
            router.push("SignUpUserDetailsView")
        }
        
        self.isLoading.toggle()
    }
}

extension SignUpWithEmailView {
    private enum Field: Int, CaseIterable {
        case email, password, confirmedPassword
    }
    
    private func focusPreviousField() {
        focusedField = focusedField.map {
            Field(rawValue: $0.rawValue - 1) ?? .email
        }
    }
    
    private func focusNextField() {
        focusedField = focusedField.map {
            Field(rawValue: $0.rawValue + 1) ?? .confirmedPassword
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

struct SignUpWithEmailView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpWithEmailView(emailBinding: Binding.constant(""),
                            userAccount: Binding.constant(UserAccount()))
    }
}
