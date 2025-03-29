//
//  AuthenticationService.swift
//  Waterly
//
//  Created by Stefan Popescu on 24.05.2023.
//

import Foundation

class AuthenticationService: ObservableObject {
    private static let BACKEND_ENDPOINT = "http://stefanpopescu.local:8080/auth"
    private static let SERVICE_NAME = "me.stefan923.WaterlyApp"
    
    private var userAccountTokenManager = UserAccountTokenManager.shared

    func loginUsingCredentials(_ email: String, _ password: String, _ successAction: @escaping () -> Void, _ failureAction: @escaping (Int) -> Void) {
        guard let url = URL(string: "\(AuthenticationService.BACKEND_ENDPOINT)/login") else {
            return
        }
        
        let requestData = [
            "accountType": "CREDENTIALS",
            "email": email,
            "password": password
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: requestData)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                failureAction(600)
                print("Error: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if !(200...299).contains(httpResponse.statusCode) {
                    failureAction(httpResponse.statusCode)
                    return;
                }
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(UserAccountToken.self, from: data)
                    self.userAccountTokenManager.setUserAccountToken(decodedData)
                    UserAccount(email: email, accountType: .credentials, password: password).saveToLocalData()
                    
                    successAction()
                } catch {
                    failureAction(600)
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
    
    func loginUsingGoogle(_ o2authToken: String, _ successAction: @escaping () -> Void, _ failureAction: @escaping (Int) -> Void) {
        guard let url = URL(string: "\(AuthenticationService.BACKEND_ENDPOINT)/login") else {
            return
        }
        
        let requestData = [
            "accountType": "GOOGLE",
            "o2authToken": o2authToken
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: requestData)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                failureAction(600)
                print("Error: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if !(200...299).contains(httpResponse.statusCode) {
                    failureAction(httpResponse.statusCode)
                    return;
                }
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let userAccountToken = try decoder.decode(UserAccountToken.self, from: data)
                    self.userAccountTokenManager.setUserAccountToken(userAccountToken)
                    
                    successAction()
                } catch {
                    failureAction(600)
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
    
    func registerUsingCredentials(_ userAccount: UserAccount,
                                  _ userInfo: UserInfo,
                                  _ successAction: @escaping () -> Void,
                                  _ failureAction: @escaping (Int, String) -> Void) {
        guard let url = URL(string: "\(AuthenticationService.BACKEND_ENDPOINT)/register") else {
            return
        }
        
        let requestData: [String: Any] = [
            "userAccountRegistration": userAccount.toJSON(),
            "userInfoRequest": userInfo.toJSON()
        ]
        
        print(requestData)
        
        let jsonData = try? JSONSerialization.data(withJSONObject: requestData)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                failureAction(600, "Aici 4")
                print("Error: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if !(200...299).contains(httpResponse.statusCode) {
                    if let data = data {
                        let stringData = String(data: data, encoding: .utf8)
                        DispatchQueue.main.async {
                            failureAction(httpResponse.statusCode, stringData ?? "Aici 1")
                            return;
                        }
                    }
                    
                    failureAction(httpResponse.statusCode, "Aici 2")
                    return;
                }
            }
            
            successAction()
        }.resume()
    }
    
    func validateEmail(_ email: String, _ successAction: @escaping () -> Void, _ failureAction: @escaping (Int) -> Void) {
        guard let url = URL(string: "\(AuthenticationService.BACKEND_ENDPOINT)/validate?email=\(email)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                failureAction(600)
                print("Error: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if !(200...299).contains(httpResponse.statusCode) {
                    failureAction(httpResponse.statusCode)
                    return;
                }
            }
            
            successAction()
        }.resume()
    }
    
    func requestConfirmCode(_ email: String, _ successAction: @escaping () -> Void, _ failureAction: @escaping (Int) -> Void) {
        guard let url = URL(string: "\(AuthenticationService.BACKEND_ENDPOINT)/request_confirm_code?email=\(email)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                failureAction(600)
                print("Error: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if !(200...299).contains(httpResponse.statusCode) {
                    failureAction(httpResponse.statusCode)
                    return;
                }
            }
            
            successAction()
        }.resume()
    }
    
    func confirmUserAccount(_ userAccountConfirmation: UserAccountConfirmation, _ successAction: @escaping () -> Void, _ failureAction: @escaping (Int) -> Void) {
        guard let url = URL(string: "\(AuthenticationService.BACKEND_ENDPOINT)/confirm") else {
            return
        }
        
        let requestData: [String: Any] = userAccountConfirmation.toJSON()
        let jsonData = try? JSONSerialization.data(withJSONObject: requestData)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                failureAction(600)
                print("Error: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if !(200...299).contains(httpResponse.statusCode) {
                    failureAction(httpResponse.statusCode)
                    return;
                }
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(UserAccountToken.self, from: data)
                    DispatchQueue.main.async {
                        self.userAccountTokenManager.setUserAccountToken(decodedData)
                    }
                    
                    successAction()
                } catch {
                    failureAction(600)
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
}
