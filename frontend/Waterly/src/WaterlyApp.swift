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
    @State var isActive: Bool = false
    @State var isAuthenticated: Bool = false
    @State var showingGoogleAuthAlert: Bool = false
    
    @ObservedObject var viewModel = AuthenticationService()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if self.isActive {
                    if self.isAuthenticated {
                        HomeStatsView(handleSignOut: self.handleSignOut)
                            .environmentObject(WCSessionManager.shared)
                    } else {
                        UnauthenticatedView(isAuthenticated: $isAuthenticated,
                                            handleGoogleAuthentication: self.handleGoogleAuthentication)
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
                GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                    if let user = user {
                        isAuthenticated.toggle()
                    }
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
    
    func handleGoogleAuthentication() -> Void {
        let rootViewController = ((UIApplication.shared.windows.first?.rootViewController)! as UIViewController)
        
        GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController) { signInResult, error in
                guard signInResult != nil else {
                    showingGoogleAuthAlert.toggle()
                    return
                }
                isAuthenticated.toggle()
            }
    }
    
    func handleSignOut() -> Void {
        GIDSignIn.sharedInstance.signOut()
        self.isAuthenticated.toggle()
    }
}
