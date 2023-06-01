//
//  LoadingView.swift
//  Waterly
//
//  Created by Stefan Popescu on 26.05.2023.
//

import SwiftUI

struct LoadingView: View {
    private static let INITIAL_DEGREE: Angle = .degrees(270)
    private static let FULL_ROTATION_DEGREE: Angle = .degrees(360)
    
    private static let VIEW_WIDTH: CGFloat = 200
    private static let VIEW_HEIGHT: CGFloat = 200
    
    private let circleColor1 = Color("LoadingCircleColor1")
    private let circleColor2 = Color("LoadingCircleColor2")
    private let circleColor3 = Color("LoadingCircleColor3")
    
    private let animationInterval: Double = 1.9
    private let rotationInterval: Double = 0.75
    
    @State private var spinnerTrimFrom: CGFloat = 0.0
    @State private var spinnerTrimToC1: CGFloat = 0.03
    @State private var spinnerTrimToC2C3: CGFloat = 0.03
    @State private var rotationDegreeS1 = INITIAL_DEGREE
    @State private var rotationDegreeS2 = INITIAL_DEGREE
    @State private var rotationDegreeS3 = INITIAL_DEGREE
    
    var body: some View {
        Color("LoadingBackgroundColor")
            .edgesIgnoringSafeArea(.all)
        ZStack {
            SpinningCircle(trimFrom: spinnerTrimFrom,
                          trimTo: spinnerTrimToC2C3,
                          rotation: rotationDegreeS3,
                          color: circleColor1)
            SpinningCircle(trimFrom: spinnerTrimFrom,
                          trimTo: spinnerTrimToC2C3,
                          rotation: rotationDegreeS2,
                          color: circleColor2)
            SpinningCircle(trimFrom: spinnerTrimFrom,
                          trimTo: spinnerTrimToC1,
                          rotation: rotationDegreeS1,
                          color: circleColor3)
        }
        .frame(width: LoadingView.VIEW_WIDTH, height: LoadingView.VIEW_HEIGHT)
        .onAppear() {
            Timer.scheduledTimer(withTimeInterval: animationInterval, repeats: true) { (mainTimer) in
                self.executeLoadingAnimation()
            }
        }
    }
    
    private func executeLoadingAnimation() {
        self.executeLoadingAnimation(with: rotationInterval) { self.spinnerTrimToC1 = 1.0 }

        self.executeLoadingAnimation(with: (rotationInterval * 2) - 0.025) {
            self.rotationDegreeS1 += LoadingView.FULL_ROTATION_DEGREE
            self.spinnerTrimToC2C3 = 0.8
        }

        self.executeLoadingAnimation(with: (rotationInterval * 2)) {
            self.spinnerTrimToC1 = 0.03
            self.spinnerTrimToC2C3 = 0.03
        }

        self.executeLoadingAnimation(with: (rotationInterval * 2) + 0.0525) { self.rotationDegreeS2 += LoadingView.FULL_ROTATION_DEGREE }

        self.executeLoadingAnimation(with: (rotationInterval * 2) + 0.225) { self.rotationDegreeS3 += LoadingView.FULL_ROTATION_DEGREE }
    }

    private func executeLoadingAnimation(with timeInterval: Double, completion: @escaping (() -> Void)) {
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
            withAnimation(Animation.easeInOut(duration: rotationInterval)) {
                completion()
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color("PrimaryColor").ignoresSafeArea()
            Color("LoadingBackgroundColor").ignoresSafeArea()
            VStack {
                LoadingView()
            }
            .frame(width: 200, height: 200)
        }
    }
}
