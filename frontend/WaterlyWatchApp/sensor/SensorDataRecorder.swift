//
//  SensorDataRecorder.swift
//  Waterly Watch App
//
//  Created by Stefan Popescu on 28.06.2023.
//

import WatchKit
import Foundation
import CoreMotion
import CoreML

class SensorDataRecorder {
    static let predictionWindowLength = 300
    static let stateLength = 400
    static let intervalBetweenDetectionAlerts: Double = 60 * 2
    
    private let motionManager = CMMotionManager()
    private let motionQueue = OperationQueue()
    private let dataTransferSender = DataTransferSender()
    private var values: [SensorData] = []
    private var iteration = 0
    private var model: DrinkActivityClassifier3?
    
    private var stopNotificationsUntil: Date = .now
    
    var currentIndexInPredictionWindow = 0
    
    let accX = try! MLMultiArray(shape: [predictionWindowLength] as [NSNumber], dataType: MLMultiArrayDataType.double)
    let accY = try! MLMultiArray(shape: [predictionWindowLength] as [NSNumber], dataType: MLMultiArrayDataType.double)
    let accZ = try! MLMultiArray(shape: [predictionWindowLength] as [NSNumber], dataType: MLMultiArrayDataType.double)

    let gyrX = try! MLMultiArray(shape: [predictionWindowLength] as [NSNumber], dataType: MLMultiArrayDataType.double)
    let gyrY = try! MLMultiArray(shape: [predictionWindowLength] as [NSNumber], dataType: MLMultiArrayDataType.double)
    let gyrZ = try! MLMultiArray(shape: [predictionWindowLength] as [NSNumber], dataType: MLMultiArrayDataType.double)

    var stateIn = try! MLMultiArray(shape:[stateLength as NSNumber], dataType: MLMultiArrayDataType.double)
    
    init() {
        do {
            try model = DrinkActivityClassifier3(configuration: MLModelConfiguration())
        } catch {
            print(error)
        }
    }
    
    func startRecordingSensorData(onGestureDetection: @escaping () -> Void) -> Void {
        if motionManager.isDeviceMotionAvailable {
            print("Device motion is avaiable. Registering for sensor updates...")
            
            //motionManager.deviceMotionUpdateInterval = SensorDataRecorder.sensorsUpdateInterval
            motionManager.startDeviceMotionUpdates(to: motionQueue, withHandler: { (data, error) in
                if let data = data {
                    self.accX[[self.currentIndexInPredictionWindow] as [NSNumber]] = data.userAcceleration.x as NSNumber
                    self.accY[[self.currentIndexInPredictionWindow] as [NSNumber]] = data.userAcceleration.y as NSNumber
                    self.accZ[[self.currentIndexInPredictionWindow] as [NSNumber]] = data.userAcceleration.z as NSNumber
                    self.gyrX[[self.currentIndexInPredictionWindow] as [NSNumber]] = data.rotationRate.x as NSNumber
                    self.gyrY[[self.currentIndexInPredictionWindow] as [NSNumber]] = data.rotationRate.y as NSNumber
                    self.gyrZ[[self.currentIndexInPredictionWindow] as [NSNumber]] = data.rotationRate.z as NSNumber
                    
                    self.currentIndexInPredictionWindow += 1

                    if self.currentIndexInPredictionWindow == SensorDataRecorder.predictionWindowLength {
                        self.currentIndexInPredictionWindow = 0
                        
                        do {
                            let prediction = try? self.model?.prediction(accX: self.accX, accY: self.accY, accZ: self.accZ, gyrX: self.gyrX, gyrY: self.gyrY, gyrZ: self.gyrZ, stateIn: self.stateIn)
                            
                            if let prediction = prediction {
                                var predictionLabel = "other"
                                if prediction.labelProbability["drink"] ?? 0.0 > 0.8 {
                                    predictionLabel = "drink"
                                    
                                    let currentTime = Date.now
                                    if currentTime >= self.stopNotificationsUntil {
                                        self.stopNotificationsUntil = currentTime.addingTimeInterval(SensorDataRecorder.intervalBetweenDetectionAlerts)
                                        onGestureDetection()
                                        WKInterfaceDevice.current().play(.notification)
                                    }
                                }
                                print("Detection: \(predictionLabel), \(prediction.labelProbability), \(self.motionQueue.operationCount)")
                                self.stateIn = prediction.stateOut
                            }
                        }
                    }
                } else if let error = error {
                    print(error)
                }
            })
        }
    }
    
    func stopRecordingSensorDate() -> Void {
        motionManager.stopDeviceMotionUpdates()
    }
    
    func recordOneWindowOfSensorData() -> Void {
        if motionManager.isDeviceMotionAvailable {
            print("Device motion is avaiable. Registering for sensor updates...")
            
            motionManager.startDeviceMotionUpdates(to: motionQueue, withHandler: { (data, error) in
                if let data = data {
                    self.values.append(SensorData(data.userAcceleration.x, data.userAcceleration.y,
                                                  data.userAcceleration.z, data.rotationRate.x, data.rotationRate.y, data.rotationRate.z))
                    
                    if self.values.count == 400 {
                        print("Successfully recorded one window of sensor data.")
                        self.motionManager.stopDeviceMotionUpdates()
                        let csvString = self.values
                            .map { "\($0.accX),\($0.accY),\($0.accZ),\($0.gyrX),\($0.gyrY),\($0.gyrZ)" }
                            .joined(separator: "\n")
                        let csvColumns = "accX,accY,accZ,gyrX,gyrY,gyrZ"
                        self.values.removeAll()
                        self.dataTransferSender.sendSensorData(sensorData: "\(csvColumns)\n\(csvString)", fileName: "sensor-data-\(self.iteration).csv")
                        self.iteration += 1
                    }
                } else if let error = error {
                    print(error)
                }
            })
        }
    }
}
