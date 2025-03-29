//
//  UserProfileView.swift
//  Waterly
//
//  Created by Stefan Popescu on 01.07.2023.
//

import SwiftUI

struct UserProfileView : View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var router: Router
    
    @State private var userInfo: UserInfo? = UserInfo("Stefan", "Popescu", Date.now, .MALE, 72, 193)
    
    @State private var isLoading = true
    var userInfoService = UserInfoService()
    
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
                        HStack {
                            Text("Your profile")
                                .foregroundColor(Color("TextFieldFontColor"))
                                .font(.system(size: 26).weight(.bold))
                                .padding(10.0)
                                .frame(alignment: .leading)
                            
                            Spacer()
                            
                            Text("Modify")
                                .font(.system(size: 16).weight(.regular))
                                .foregroundColor(.blue)
                                .underline()
                                .padding(10.0)
                                .onTapGesture {
                                    router.push("EditUserProfileView")
                                }
                                .disabled(self.isLoading)
                        }
                        .padding([.horizontal], geometry.size.width * 0.10)
                        
                        ZStack {
                            createUserInfoView(geometry)
                            
                            if isLoading {
                                Color("LoadingBackgroundColor")
                                    .frame(width: geometry.size.width * 0.82, height: geometry.size.height * 0.50)
                                    .cornerRadius(14)
                                ProgressView()
                                    .colorScheme(.light)
                            }
                        }
                    }
                    .padding([.bottom], geometry.size.height * 0.22)
                }
            }
            .onAppear() {
                self.isLoading = true
                self.loadUserInfo()
            }
            .alert(item: $errorAlert) { error in
                Alert(title: Text(error.title), message: Text(error.message), dismissButton: .default(Text("Close")))
            }
        }
    }
    
    @ViewBuilder
    private func createUserInfoView(_ geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            if let userInfo = self.userInfo {
                OutlinedPreviewTextField(key: "First name:", value: userInfo.firstName, corners: [.top])
                OutlinedPreviewTextField(key: "Last name:", value: userInfo.lastName)
                OutlinedPreviewTextField(key: "Date of birth:", value: userInfo.dateOfBirth.toDateString)
                OutlinedPreviewTextField(key: "Gender:", value: userInfo.gender.toStringWithFirstUpper())
                OutlinedPreviewTextField(key: "Weight:", value: "\(Int(userInfo.weight)) kg")
                OutlinedPreviewTextField(key: "Height:", value: "\(Int(userInfo.height)) cm", corners: [.bottom])
                
                Spacer(minLength: 0)
            }
        }
        .frame(width: geometry.size.width * 0.80, height: geometry.size.height * 0.50)
    }
    
    private func loadUserInfo() -> Void {
        if UserAccountTokenManager.shared.getUserAccountToken()?.getUserId() != nil {
            userInfoService.getUserInfoByUserId(completion: { result in
                    switch result {
                    case .success(let userInfo):
                        self.userInfo = userInfo
                        break
                    case.failure(let error):
                        self.errorAlert = ErrorAlert(title: "Error", message: "\(error)")
                        break
                    }
                    isLoading = false
                })
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}

