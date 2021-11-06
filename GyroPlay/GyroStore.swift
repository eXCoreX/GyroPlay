//
//  GyroStore.swift
//  GyroPlay
//
//  Created by Rostyslav Litvinov on 06.11.2021.
//

import CoreMotion

class GyroStore: ObservableObject {
    @Published var deviceMotion: CMDeviceMotion?

    private let manager = CMMotionManager()

    init() {
        manager.deviceMotionUpdateInterval = 1 / 100.0
        manager.startDeviceMotionUpdates(to: OperationQueue.main) { deviceMotion, _ in
            guard let deviceMotion = deviceMotion else { return }
            self.deviceMotion = deviceMotion
        }
    }
}
