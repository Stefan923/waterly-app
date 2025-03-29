//
//  SignUpUserDetailsView.swift
//  Waterly
//
//  Created by Stefan Popescu on 27.03.2023.
//

import SwiftUI

struct SignUpUserDetailsView: View {
    private let nameValidator: Validator = NameValidator()
    private let ageValidator: Validator = DateOfBirthValidator()
    private let weightHeightValidator: Validator = WeightHeightValidator()
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var router: Router
    
    @State private var firstname = ""
    @State private var lastname = ""
    @State private var dateOfBirth = Date()
    @State private var gender = GenderType.MALE
    @State private var weight = ""
    @State private var height = ""
    
    @State private var isFirstnameInvalid = false
    @State private var isLastnameInvalid = false
    @State private var isDateOfBirthInvalid = false
    @State private var isWeightInvalid = false
    @State private var isHeightInvalid = false
    
    @State private var isLoading = false
    
    var userAccount: Binding<UserAccount>
    
    @FocusState private var focusedField: Field?
    
    @ObservedObject var viewModel = AuthenticationService()
    
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
                        self.createFormView()
                        
                        Spacer()
                        
                        VStack(spacing: 0) {
                            RoundedButton(title: "Continue",
                                          backgroundColor: Color("PrimaryColor"),
                                          foregroundColor: .white,
                                          maxWidth: 140) {
                                self.confirmUserInfo()
                            }
                            
                            RoundedButton(title: "Cancel",
                                          backgroundColor: .white,
                                          foregroundColor: .black,
                                          maxWidth: 140) {
                                dismiss()
                            }
                            
                            Text("By continuing, you agree to our\nTerms of Service and Privacy Policy.")
                                .foregroundColor(Color("TextFieldFontColor"))
                                .font(.system(size: 19).weight(.thin))
                                .multilineTextAlignment(.center)
                                .padding([.top], 20)
                        }
                        .frame(alignment: .bottom)
                    }
                    .padding([.top], geometry.size.height * 0.16)
                    .padding([.bottom], geometry.size.height * 0.08)
                }
                
                if isLoading {
                    Color("LoadingBackgroundColor").ignoresSafeArea()
                    ProgressView().colorScheme(.light)
                }
            }
        }
        .onChange(of: firstname) { firstname in
            isFirstnameInvalid = false
        }
        .onChange(of: lastname) { lastname in
            isLastnameInvalid = false
        }
        .onChange(of: dateOfBirth) { dateOfBirth in
            isDateOfBirthInvalid = false
        }
        .onChange(of: weight) { weight in
            isWeightInvalid = false
        }
        .onChange(of: height) { height in
            isHeightInvalid = false
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
    
    private func createFormView() -> some View {
        VStack(spacing: 0) {
            Text("Fill in to complete account creation:")
                .foregroundColor(Color("TextFieldFontColor"))
                .font(.system(size: 20).weight(.semibold))
                .padding([.bottom], 16.0)
            
            TextField(text: $firstname, prompt: Text("Firstname").foregroundColor(Color("TextFieldPlaceholderColor"))) {
                Text("Firstname")
            }
            .textFieldStyle(OutlinedTextFieldStyle(corners: [.topLeft, .topRight]))
            .focused($focusedField, equals: .firstname)
            .padding([.leading, .trailing], 6.0)
            .frame(height: 60.0)
            
            TextField(text: $lastname, prompt: Text("Lastname").foregroundColor(Color("TextFieldPlaceholderColor"))) {
                Text("Lastname")
            }
            .textFieldStyle(OutlinedTextFieldStyle(corners: []))
            .focused($focusedField, equals: .lastname)
            .padding([.leading, .trailing], 6.0)
            .frame(height: 60.0)
            
            OutlinedGenderPicker(title: "Gender",
                           gender: $gender,
                           corners: [],
                           isWrongValue: Binding.constant(false))
            .padding([.leading, .trailing], 6.0)
            .colorScheme(.light)
            
            OutlinedDatePicker(title: "Date of birth",
                               selectedDate: $dateOfBirth,
                               corners: [],
                               isWrongValue: $isDateOfBirthInvalid)
            .padding([.leading, .trailing], 6.0)
            .colorScheme(.light)
            
            TextField(text: $weight, prompt: Text("Weight").foregroundColor(Color("TextFieldPlaceholderColor"))) {
                Text("Weight")
            }
            .textFieldStyle(OutlinedTextFieldStyle(corners: []))
            .keyboardType(.decimalPad)
            .focused($focusedField, equals: .weight)
            .padding([.leading, .trailing], 6.0)
            .frame(height: 60.0)
            
            TextField(text: $height, prompt: Text("Height").foregroundColor(Color("TextFieldPlaceholderColor"))) {
                Text("Height")
            }
            .textFieldStyle(OutlinedTextFieldStyle(corners: [.bottomLeft, .bottomRight]))
            .keyboardType(.decimalPad)
            .focused($focusedField, equals: .height)
            .padding([.leading, .trailing], 6.0)
            .frame(height: 60.0)
            
            if isFirstnameInvalid {
                HStack {
                    Image("error-icon")
                        .resizable()
                        .frame(width: 16, height: 16)
                    
                    Text("Firstname should only contain letters!")
                        .foregroundColor(Color("ErrorRedColor"))
                        .font(.system(size: 18).weight(.regular))
                }
                .padding([.top], 16.0)
            } else if isLastnameInvalid {
                HStack {
                    Image("error-icon")
                        .resizable()
                        .frame(width: 16, height: 16)
                    
                    Text("Lastname should only contain letters!")
                        .foregroundColor(Color("ErrorRedColor"))
                        .font(.system(size: 18).weight(.regular))
                }
                .padding([.top], 16.0)
            } else if isDateOfBirthInvalid {
                HStack {
                    Image("error-icon")
                        .resizable()
                        .frame(width: 16, height: 16)
                    
                    Text("You should be at least 7 years old!")
                        .foregroundColor(Color("ErrorRedColor"))
                        .font(.system(size: 18).weight(.regular))
                }
                .padding([.top], 16.0)
            } else if isWeightInvalid {
                HStack {
                    Image("error-icon")
                        .resizable()
                        .frame(width: 16, height: 16)
                    
                    Text("Weight should be a positive number!")
                        .foregroundColor(Color("ErrorRedColor"))
                        .font(.system(size: 18).weight(.regular))
                }
                .padding([.top], 16.0)
            } else if isHeightInvalid {
                HStack {
                    Image("error-icon")
                        .resizable()
                        .frame(width: 16, height: 16)
                    
                    Text("Height should be a positive number!")
                        .foregroundColor(Color("ErrorRedColor"))
                        .font(.system(size: 18).weight(.regular))
                }
                .padding([.top], 16.0)
            }
        }
        .frame(alignment: .top)
        .padding([.leading, .trailing], 36.0)
    }
    
    private var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: dateOfBirth)
    }
    
    private func confirmUserInfo() -> Void {
        var isUserAccountValid = true
        
        if !nameValidator.validate(firstname) {
            isUserAccountValid = false
            isFirstnameInvalid = true
        }
        
        if !nameValidator.validate(lastname) {
            isUserAccountValid = false
            isLastnameInvalid = true
        }
        
        if !ageValidator.validate(dateOfBirth) {
            isUserAccountValid = false
            isDateOfBirthInvalid = true
        }
        
        if let weightValue = Double(weight) {
            if !weightHeightValidator.validate(weightValue) {
                isUserAccountValid = false
                isWeightInvalid = true
            }
        } else {
            isUserAccountValid = false
            isWeightInvalid = true
        }
        
        if let heightValue = Double(height) {
            if !weightHeightValidator.validate(heightValue) {
                isUserAccountValid = false
                isHeightInvalid = true
            }
        } else {
            isUserAccountValid = false
            isHeightInvalid = true
        }
        
        if isUserAccountValid {
            let weightValue = Double(weight) ?? 0.0
            let heightValue = Double(height) ?? 0.0
            let userInfo = UserInfo(firstname, lastname, dateOfBirth, gender, weightValue, heightValue)
            
            self.viewModel.registerUsingCredentials(self.userAccount.wrappedValue, userInfo, self.signUpSuccess, self.signUpFailure)
        }
    }
    
    private func signUpFailure(_ statusCode: Int, _ message: String) -> Void {
        self.errorAlert = ErrorAlert(title: "Error", message: "Couldn't create your account: " + message)
        isLoading.toggle()
    }

    private func signUpSuccess() -> Void {
        viewModel.requestConfirmCode(self.userAccount.wrappedValue.email, self.codeRequestSuccess, self.codeRequestFailure)
        router.push("ConfirmAccountView")
        isLoading.toggle()
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
}

extension SignUpUserDetailsView {
    private enum Field: Int, CaseIterable {
        case firstname, lastname, age, weight, height
    }
    
    private func focusPreviousField() {
        focusedField = focusedField.map {
            Field(rawValue: $0.rawValue - 1) ?? .firstname
        }
    }
    
    private func focusNextField() {
        focusedField = focusedField.map {
            Field(rawValue: $0.rawValue + 1) ?? .age
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

struct SignUpUserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpUserDetailsView(userAccount: Binding.constant(UserAccount(email: "", accountType: .credentials, password: "")))
    }
}
