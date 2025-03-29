//
//  SensorData.swift
//  Waterly Watch App
//
//  Created by Stefan Popescu on 28.06.2023.
//

import Foundation

class SensorData {
    var accX: Double
    var accY: Double
    var accZ: Double
    var gyrX: Double
    var gyrY: Double
    var gyrZ: Double
    
    init(_ accX: Double, _ accY: Double, _ accZ: Double, _ gyrX: Double, _ gyrY: Double, _ gyrZ: Double) {
        self.accX = accX
        self.accY = accY
        self.accZ = accZ
        self.gyrX = gyrX
        self.gyrY = gyrY
        self.gyrZ = gyrZ
    }
}
