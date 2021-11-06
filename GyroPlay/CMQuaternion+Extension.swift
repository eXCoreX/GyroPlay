//
//  CMQuaternion+Extension.swift
//  GyroPlay
//
//  Created by Rostyslav Litvinov on 06.11.2021.
//

import CoreMotion
import SwiftUI

extension CMQuaternion {
    var rotationAngle: Angle {
        let angle: Double
        let fSqrLength: Double = x * x + y * y + z * z
        if fSqrLength > 0.0 {
            angle = 2.0 * acos(w)
        } else {
            angle = 0
        }

        guard !angle.isNaN else { return .radians(0) }

        return .radians(angle)
    }

    var axisCGFloat: (x: CGFloat, y: CGFloat, z: CGFloat) {
        let magnitude = sqrt(x * x + y * y + z * z)
        guard magnitude > 0 else { return (1, 0, 0) }

        // Inversed y feels more natural
        return (x / magnitude, -y / magnitude, z / magnitude)
    }

    var axisDouble: (x: Double, y: Double, z: Double) {
        let magnitude = sqrt(x * x + y * y + z * z)
        guard magnitude > 0 else { return (1, 0, 0) }

        // Inversed y feels more natural
        return (x / magnitude, -y / magnitude, z / magnitude)
    }
}
