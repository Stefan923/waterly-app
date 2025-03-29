//
//  UserSettingsService.swift
//  Waterly
//
//  Created by Stefan Popescu on 02.06.2023.
//

import Foundation

class UserSettingsService {
    private func sendRequest(withRequest request: URLRequest, completion: @escaping (Result<Data?, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            completion(.success(data))
        }.resume()
    }

    func sendUserSettings(withRequestMapping requestMapping: String, httpMethod: String, userSettings: UserSettings?, completion: @escaping (Result<UserSettings?, Error>) -> Void) {
        let urlString = "http://stefanpopescu.local:8080/api/user_settings\(requestMapping)"
        print(urlString)
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(UserAccountTokenManager.shared.getUserAccountToken()?.getToken() ?? "")", forHTTPHeaderField: "Authorization")

        if let userSettings = userSettings {
            do {
                let userId = UserAccountTokenManager.shared.getUserAccountToken()?.getUserId()
                let requestData = try JSONEncoder().encode(UserSettingsDto(userId: userId!, userSettings: userSettings))
                request.httpBody = requestData
            } catch {
                completion(.failure(error))
                return
            }
        }

        sendRequest(withRequest: request, completion: { result in
            switch result {
            case .success(let data):
                if let data = data {
                    do {
                        let userSettings = try JSONDecoder().decode(UserSettings.self, from: data)
                        completion(.success(userSettings))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.success(nil))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }

    func getUserSettingsByUserId(completion: @escaping (Result<UserSettings, Error>) -> Void) {
        let userId = UserAccountTokenManager.shared.getUserAccountToken()?.getUserId() ?? ""
        sendUserSettings(withRequestMapping: "?userId=\(userId)", httpMethod: "GET", userSettings: nil) { result in
            switch result {
            case .success(let userSettings):
                if let userSettings = userSettings {
                    print(userSettings)
                    completion(.success(userSettings))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func createUserSettings(userSettings: UserSettings, completion: @escaping (Result<UserSettings, Error>) -> Void) {
        sendUserSettings(withRequestMapping: "", httpMethod: "POST", userSettings: userSettings) { result in
            switch result {
            case .success(let userSettings):
                if let userSettings = userSettings {
                    completion(.success(userSettings))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateUserSettings(userSettings: UserSettings, completion: @escaping (Result<UserSettings, Error>) -> Void) {
        print(userSettings.dailyLiquidsConsumptionTarget)
        sendUserSettings(withRequestMapping: "", httpMethod: "PUT", userSettings: userSettings) { result in
            switch result {
            case .success(let userSettings):
                if let userSettings = userSettings {
                    completion(.success(userSettings))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func deleteUserSettings(completion: @escaping (Result<String, Error>) -> Void) {
        let userId = UserAccountTokenManager.shared.getUserAccountToken()?.getUserId() ?? ""
        sendUserSettings(withRequestMapping: "/\(userId)", httpMethod: "DELETE", userSettings: nil) { result in
            switch result {
            case .success:
                completion(.success("Successfully deleted user settings for given user id."))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
