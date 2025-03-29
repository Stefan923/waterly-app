//
//  ConsumptionService.swift
//  Waterly
//
//  Created by Stefan Popescu on 18.06.2023.
//

import Foundation

class ConsumptionService {
    
    private var userAccountToken: UserAccountToken? {
        return UserAccountTokenManager.shared.getUserAccountToken()
    }
    
    private func sendRequest(withRequest request: URLRequest, completion: @escaping (Result<Data?, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
    
    func sendConsumptionsRequest(withRequestMapping requestMapping: String, httpMethod: String, consumption: Consumption?, completion: @escaping (Result<ConsumptionsDto?, Error>) -> Void) {
        let urlString = "http://stefanpopescu.local:8080/api/consumptions\(requestMapping)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(userAccountToken?.getToken() ?? "")", forHTTPHeaderField: "Authorization")
        
        if let consumption = consumption {
            do {
                let requestData = try JSONEncoder().encode(consumption)
                request.httpBody = requestData
            } catch {
                completion(.failure(error))
                return
            }
        }
        
        sendRequest(withRequest: request) { result in
            switch result {
            case .success(let data):
                if let data = data {
                    do {
                        print(url)
                        print(data)
                        let decoder = JSONDecoder()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        decoder.dateDecodingStrategy = .formatted(dateFormatter)
                        
                        let response = try decoder.decode(ConsumptionsDto.self, from: data)
                        completion(.success(response))
                    } catch {
                        print(error)
                        completion(.failure(error))
                    }
                } else {
                    completion(.success(nil))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func sendIntervalConsumptionsRequest(withRequestMapping requestMapping: String, httpMethod: String, consumption: Consumption?, completion: @escaping (Result<IntervalConsumptionsDto?, Error>) -> Void) {
        let urlString = "http://stefanpopescu.local:8080/api/consumptions\(requestMapping)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(userAccountToken?.getToken() ?? "")", forHTTPHeaderField: "Authorization")
        
        if let consumption = consumption {
            do {
                let requestData = try JSONEncoder().encode(consumption)
                request.httpBody = requestData
            } catch {
                completion(.failure(error))
                return
            }
        }
        
        sendRequest(withRequest: request) { result in
            switch result {
            case .success(let data):
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        decoder.dateDecodingStrategy = .formatted(dateFormatter)
                        
                        let response = try decoder.decode(IntervalConsumptionsDto.self, from: data)
                        completion(.success(response))
                    } catch {
                        print(error)
                        completion(.failure(error))
                    }
                } else {
                    completion(.success(nil))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func sendConsumptionRequest<T: Encodable>(withRequestMapping requestMapping: String, httpMethod: String, consumption: T?, completion: @escaping (Result<Consumption?, Error>) -> Void) {
        let urlString = "http://stefanpopescu.local:8080/api/consumptions\(requestMapping)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(userAccountToken?.getToken() ?? "")", forHTTPHeaderField: "Authorization")
        
        if let consumption = consumption {
            do {
                let requestData = try JSONEncoder().encode(consumption)
                request.httpBody = requestData
            } catch {
                completion(.failure(error))
                return
            }
        }
        
        sendRequest(withRequest: request) { result in
            switch result {
            case .success(let data):
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        decoder.dateDecodingStrategy = .formatted(dateFormatter)
                        
                        let response = try decoder.decode(Consumption.self, from: data)
                        completion(.success(response))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.success(nil))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func sendSensorDataRequest(withRequestMapping requestMapping: String, httpMethod: String, consumption: String, completion: @escaping (Result<String?, Error>) -> Void) {
        let urlString = "http://stefanpopescu.local:8080/api/consumptions\(requestMapping)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(userAccountToken?.getToken() ?? "")", forHTTPHeaderField: "Authorization")
        
        do {
            let requestData = try JSONEncoder().encode(consumption)
            request.httpBody = requestData
        } catch {
            completion(.failure(error))
            return
        }
        
        sendRequest(withRequest: request) { result in
            switch result {
            case .success(let data):
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        
                        let response = try decoder.decode(String.self, from: data)
                        completion(.success(response))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.success(nil))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getConsumptionsByUserId(userId: String, page: Int, size: Int, completion: @escaping (Result<ConsumptionsDto, Error>) -> Void) {
        let requestMapping = "?userId=\(userId)&page=\(page)&size=\(size)"
        sendConsumptionsRequest(withRequestMapping: requestMapping, httpMethod: "GET", consumption: nil, completion: { result in
            switch result {
            case .success(let consumptions):
                if let consumptions = consumptions {
                    completion(.success(consumptions))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
            
        })
    }
    
    func getConsumptionsByUserIdAndConsumptionStatus(userId: String, consumptionStatus: ConsumptionStatus, page: Int,
                                                     size: Int, completion: @escaping (Result<ConsumptionsDto, Error>) -> Void) {
        let requestMapping = "?userId=\(userId)&consumptionStatus=\(consumptionStatus)&page=\(page)&size=\(size)"
        sendConsumptionsRequest(withRequestMapping: requestMapping, httpMethod: "GET", consumption: nil, completion: { result in
            switch result {
            case .success(let consumptions):
                if let consumptions = consumptions {
                    completion(.success(consumptions))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
            
        })
    }
    
    func getTodayConsumptionsByUserId(userId: String, page: Int, size: Int, completion: @escaping (Result<ConsumptionsDto, Error>) -> Void) {
        let requestMapping = "/today?userId=\(userId)&page=\(page)&size=\(size)"
        sendConsumptionsRequest(withRequestMapping: requestMapping, httpMethod: "GET", consumption: nil) { result in
            switch result {
            case .success(let consumptions):
                if let consumptions = consumptions {
                    completion(.success(consumptions))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getConsumptionStatisticsByUserId(statsType: String, userId: String, type: ConsumptionType, date: Date, page: Int, size: Int, completion: @escaping (Result<IntervalConsumptionsDto, Error>) -> Void) {
        let requestMapping = "/\(statsType)?userId=\(userId)&type=\(type.toString())&modificationDate=\(date.toDateString)&page=\(page)&size=\(size)"
        sendIntervalConsumptionsRequest(withRequestMapping: requestMapping, httpMethod: "GET", consumption: nil) { result in
            switch result {
            case .success(let consumptions):
                if let consumptions = consumptions {
                    completion(.success(consumptions))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func saveSensorData(sensorData: String, completion: @escaping (Result<String, Error>) -> Void) {
        sendSensorDataRequest(withRequestMapping: "/sensor-data", httpMethod: "POST", consumption: sensorData) { result in
            switch result {
            case .success(let response):
                if let response = response {
                    completion(.success(response))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func createConsumption(consumption: ConsumptionRequest, completion: @escaping (Result<Consumption, Error>) -> Void) {
        sendConsumptionRequest(withRequestMapping: "", httpMethod: "POST", consumption: consumption) { result in
            switch result {
            case .success(let consumption):
                if let consumption = consumption {
                    completion(.success(consumption))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateConsumption(consumption: ConsumptionUpdateRequest, completion: @escaping (Result<Consumption, Error>) -> Void) {
        let requestMapping = "/\(consumption.id)"
        sendConsumptionRequest(withRequestMapping: requestMapping, httpMethod: "PUT", consumption: consumption) { result in
            switch result {
            case .success(let consumption):
                if let consumption = consumption {
                    completion(.success(consumption))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteConsumption(id: String, completion: @escaping (Result<String, Error>) -> Void) {
        let requestMapping = "/\(id)"
        let consumption: Consumption? = nil
        sendConsumptionRequest(withRequestMapping: requestMapping, httpMethod: "DELETE", consumption: consumption) { result in
            switch result {
            case .success:
                completion(.success("Successfully deleted consumption entry for given user id."))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
