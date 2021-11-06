//
//  GyroPlayApp.swift
//  GyroPlay
//
//  Created by Rostyslav Litvinov on 05.11.2021.
//

import SwiftUI
import CoreMotion

@main
struct GyroPlayApp: App {
    @StateObject private var gyroStore = GyroStore()
    
    var body: some Scene {
        WindowGroup {
            CardView()
                .environmentObject(gyroStore)
        }
    }
}
