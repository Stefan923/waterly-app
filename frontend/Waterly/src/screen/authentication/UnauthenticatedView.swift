//
//  UnauthenticatedView.swift
//  Waterly
//
//  Created by Stefan Popescu on 12.03.2023.
//

import SwiftUI

struct UnauthenticatedView: View {
    @StateObject private var router = Router()
    private var notificationScheduler: NotificationScheduler = NotificationScheduler()
    
    private let isAuthenticated: Binding<Bool>
    private let handleGoogleAuthentication: () -> Void
    
    @State private var email: String
    @State private var userAccount: UserAccount
    
    init(isAuthenticated: Binding<Bool>,
         handleGoogleAuthentication: @escaping () -> Void) {
        self.isAuthenticated = isAuthenticated
        self.handleGoogleAuthentication = handleGoogleAuthentication
        
        self.email = ""
        self.userAccount = UserAccount()
    }
    
    var body: some View {
        NavigationStack(path: $router.navPath) {
            GeometryReader { geometry in
                ZStack {
                    Color("PrimaryColor")
                        .ignoresSafeArea(.all, edges: .all)
                    Image("waterly-logo")
                        .resizable()
                        .frame(width: 256, height: 256)
                        .padding([.bottom], geometry.size.height * 0.74)
                    
                    ZStack {
                        VStack {
                            Spacer()
                            
                            WaveEdgedRectangle()
                                .fill(Color("SecondaryColor"))
                                .shadow(color: .black.opacity(0.25), radius: 15, x: 0, y: -10)
                                .frame(height: geometry.size.height * 0.70, alignment: .bottom)
                        }
                        .frame(height: geometry.size.height * 1.05)
                        
                        VStack(spacing: 10) {
                            RoundedButton(title: "Sign in with your email",
                                          icon: Image("email-icon-black"),
                                          backgroundColor: .white,
                                          foregroundColor: .black) {
                                router.push("SignInWithEmailView")
                            }
                            
                            HStack {
                                VStack{
                                    Divider()
                                        .overlay(Color.black)
                                }
                                
                                Text("OR").foregroundColor(Color("TextFieldFontColor"))
                                
                                VStack {
                                    Divider()
                                        .overlay(Color.black)
                                }
                            }
                            .padding([.trailing, .leading], 35)
                            .padding([.top, .bottom], 12)
                            
                            RoundedButton(title: "Sign up with your email",
                                          icon: Image("email-icon-black"),
                                          backgroundColor: .white,
                                          foregroundColor: .black) {
                                router.push("SignUpWithEmailView")
                            }
                            
                            RoundedButton(title: "Sign up with Apple",
                                          icon: Image("apple-logo-white"),
                                          backgroundColor: .black) {
                                notificationScheduler.sendNotification("Waterly", "It's time to drink 150 ml of liquids.")
                            }
                            
                            RoundedButton(title: "Sign up with Google",
                                          icon: Image("google-logo-white"),
                                          backgroundColor: Color("GoogleSignUpButtonColor")) {
                                self.handleGoogleAuthentication()
                            }
                        }
                        .padding([.top], 250)
                    }
                }
            }
            .navigationDestination(for: String.self) { view in
                if (view == "SignInWithEmailView") {
                    SignInWithEmailView(isAuthenticated: isAuthenticated, emailBinding: $email)
                } else if (view == "SignUpWithEmailView") {
                    SignUpWithEmailView(emailBinding: $email, userAccount: $userAccount)
                } else if (view == "SignUpUserDetailsView") {
                    SignUpUserDetailsView(userAccount: $userAccount)
                } else if (view == "ConfirmAccountView") {
                    ConfirmAccountView(emailBinding: $email, isAuthenticated: isAuthenticated)
                }
            }
        }
        .environmentObject(router)
    }
}

struct UnauthenticatedView_Previews: PreviewProvider {
    static var previews: some View {
        UnauthenticatedView(isAuthenticated: Binding.constant(false),
                            handleGoogleAuthentication: {})
    }
}
