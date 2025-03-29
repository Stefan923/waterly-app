//
//  UserInfoService.swift
//  Waterly
//
//  Created by Stefan Popescu on 01.07.2023.
//

import Foundation

class UserInfoService {
    private func sendRequest(withRequest request: URLRequest, completion: @escaping (Result<Data?, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            completion(.success(data))
        }.resume()
    }

    func sendUserInfoRequest(withRequestMapping requestMapping: String, httpMethod: String, userInfo: UserInfo?, completion: @escaping (Result<UserInfo?, Error>) -> Void) {
        let urlString = "http://stefanpopescu.local:8080/api/user_info\(requestMapping)"
        print(urlString)
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(UserAccountTokenManager.shared.getUserAccountToken()?.getToken() ?? "")", forHTTPHeaderField: "Authorization")

        if let userInfo = userInfo {
            do {
                if let userId = UserAccountTokenManager.shared.getUserAccountToken()?.getUserId() {
                    let encoder = JSONEncoder()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    encoder.dateEncodingStrategy = .formatted(dateFormatter)
                    
                    let requestData = try encoder.encode(UserInfoDto(userId: userId, userInfo: userInfo))
                    request.httpBody = requestData
                }
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
                        let decoder = JSONDecoder()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        decoder.dateDecodingStrategy = .formatted(dateFormatter)
                        
                        let userInfo = try decoder.decode(UserInfo.self, from: data)
                        completion(.success(userInfo))
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

    func getUserInfoByUserId(completion: @escaping (Result<UserInfo, Error>) -> Void) {
        let userId = UserAccountTokenManager.shared.getUserAccountToken()?.getUserId() ?? ""
        sendUserInfoRequest(withRequestMapping: "?userId=\(userId)", httpMethod: "GET", userInfo: nil) { result in
            switch result {
            case .success(let userInfo):
                if let userInfo = userInfo {
                    completion(.success(userInfo))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateUserInfo(userInfo: UserInfo, completion: @escaping (Result<UserInfo, Error>) -> Void) {
        sendUserInfoRequest(withRequestMapping: "", httpMethod: "PUT", userInfo: userInfo) { result in
            switch result {
            case .success(let userInfo):
                if let userInfo = userInfo {
                    completion(.success(userInfo))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
