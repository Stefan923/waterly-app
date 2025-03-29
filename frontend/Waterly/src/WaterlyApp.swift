//
//  WaterlyApp.swift
//  Waterly
//
//  Created by Stefan Popescu on 18.11.2022.
//

import SwiftUI
import GoogleSignIn

@main
struct WaterlyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State var isActive: Bool = false
    @State var isAuthenticated: Bool = false
    @State var showingGoogleAuthAlert: Bool = false
    
    @State var displayNotification: Bool = false
    @State var notificationData: [AnyHashable: Any] = [:]
    
    @ObservedObject var viewModel = AuthenticationService()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if self.isActive {
                    if displayNotification {
                        ConsumptionNotificationView(notificationData: notificationData, onFinish: onNotificationFinish)
                    } else {
                        if self.isAuthenticated {
                            HomeStatsView(handleSignOut: self.handleSignOut)
                        } else {
                            UnauthenticatedView(isAuthenticated: $isAuthenticated,
                                                handleGoogleAuthentication: self.handleGoogleAuthentication)
                        }
                    }
                }
                SplashScreenView()
                    .opacity(isActive ? 0.0 : 1.0)
                    .animation(.easeInOut(duration: 0.25))
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        self.isActive.toggle()
                    }
                }
                if !isAuthenticated {
                    useLastMethodToAuthenticate()
                }
            }
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
            .alert(isPresented: $showingGoogleAuthAlert) {
                Alert(
                    title: Text("Google authentication failed"),
                    message: Text("There was an error while trying to authenticate with Google account."),
                    dismissButton: .default(Text("Close"))
                )
            }
        }
    }
    
    func useLastMethodToAuthenticate() -> Void {
        let userAccountOptional = UserAccount.loadFromLocalData()
        if userAccountOptional != nil {
            let userAccount = userAccountOptional!
            
            if userAccount.accountType == .credentials {
                AuthenticationService().loginUsingCredentials(userAccount.email, userAccount.password, {
                    UserSettingsService().getUserSettingsByUserId(completion: { result in
                        switch result {
                        case .success(let settings):
                            UserSettingsManager.shared.setUserSettings(settings)
                            WCSessionManager.shared.processReceivedData()
                            appDelegate.setNotificationAction(self.onNotificationReceive)
                            
                            DispatchQueue.main.async {
                                isAuthenticated = true
                            }
                        case .failure(_):
                            break
                        }
                    })
                }, { _ in })
            }
            
            if userAccount.accountType == .google {
                GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                    guard error == nil else {
                        print(error)
                        return
                    }
                    guard let user = user else {
                        return
                    }
                    
                    if let idToken = user.idToken?.tokenString {
                        AuthenticationService().loginUsingGoogle(idToken, {
                            isAuthenticated.toggle()
                        }, {_ in})
                    }
                }
            }
        }
    }
    
    private func handleGoogleAuthentication(router: Router, userAccount: Binding<UserAccount>, emailBinding: Binding<String>) -> Void {
        let rootViewController = ((UIApplication.shared.windows.first?.rootViewController)! as UIViewController)
        
        GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController) { signInResult, error in
                if let signInResult = signInResult {
                    signInResult.user.refreshTokensIfNeeded { user, error in
                        guard error == nil else {
                            print(error)
                            return
                        }
                        guard let user = user else {
                            return
                        }
                        
                        if let idToken = user.idToken?.tokenString {
                            AuthenticationService().loginUsingGoogle(idToken, {
                                if let email = user.profile?.email {
                                    userAccount.email.wrappedValue = email
                                    userAccount.accountType.wrappedValue = .google
                                    userAccount.wrappedValue.saveToLocalData()
                                }
                                isAuthenticated.toggle()
                            }, { statusCode in
                                if (statusCode == 404) {
                                    if let email = user.profile?.email {
                                        userAccount.email.wrappedValue = email
                                        userAccount.accountType.wrappedValue = .google
                                        userAccount.wrappedValue.saveToLocalData()
                                    }
                                    DispatchQueue.main.async {
                                        router.navPath.append("SignUpUserDetailsView")
                                    }
                                } else if (statusCode == 403) {
                                    if let email = user.profile?.email {
                                        userAccount.email.wrappedValue = email
                                        userAccount.accountType.wrappedValue = .google
                                        userAccount.wrappedValue.saveToLocalData()
                                        emailBinding.wrappedValue = email
                                    }
                                    DispatchQueue.main.async {
                                        router.navPath.append("ConfirmAccountView")
                                    }
                                }
                            })
                        }
                    }
                } else {
                    showingGoogleAuthAlert.toggle()
                    return
                }
            }
    }
    
    private func handleSignOut() -> Void {
        GIDSignIn.sharedInstance.signOut()
        UserAccount().saveToLocalData()
        self.isAuthenticated.toggle()
    }
    
    private func onNotificationReceive(_ notificationData: [AnyHashable: Any]) -> Void {
        self.notificationData = notificationData
        self.displayNotification = true
    }
    
    private func onNotificationFinish() {
        self.displayNotification = false
    }
}
