//
//  CardView.swift
//  GyroPlay
//
//  Created by Rostyslav Litvinov on 05.11.2021.
//

import SwiftUI
import CoreMotion
import SFSafeSymbols

struct CardView: View {
    @EnvironmentObject private var gyroStore: GyroStore
    @State private var currentAttitude: CMAttitude?
    @State private var offsetAttitude: CMAttitude?
    @State private var needToReplaceOffset = true
    @State private var currentSymbol: SFSymbol = .house

    private static let offsets: [Double] = {
        (0..<Int.random(in: 3...6))
            .map { _ in Double.random(in: 0...1) }
    }()

    private var colors: [Color] {
        Self.offsets.map {
            Color(hue: (10 + $0 + (currentAttitude?.quaternion.x ?? 0) / 2).truncatingRemainder(dividingBy: 1),
                  saturation: 1,
                  brightness: 1)
        }
    }

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        colors: colors,
                        startPoint: .leading,
                        endPoint: .trailing)
                )
                .mask(Text("GyroPlay").font(.largeTitle))
                .frame(height: 60)

            if let currentAttitude = currentAttitude {
                ZStack {
                    Color(red: 0, green: 0, blue: 0)
                        .ignoresSafeArea()

                    RoundedRectangle(cornerRadius: 25)
                        .fill(
                            LinearGradient(
                                colors: colors,
                                startPoint: .init(x: -1 + currentAttitude.quaternion.y, y: 0.2),
                                endPoint: .init(x: 1 + currentAttitude.quaternion.y + 1, y: 0.8))
                        )
                        .mask(Image(systemSymbol: currentSymbol).resizable().scaledToFit())
                        .frame(width: 250, height: 250)
                        .rotation3DEffect(
                            currentAttitude
                                .quaternion.rotationAngle,
                            axis: currentAttitude
                                .quaternion.axisCGFloat)
                        .onTapGesture {
                            currentSymbol = SFSymbol.allCases.randomElement() ?? .house
                        }
                        .animation(.default, value: currentSymbol)
                }
                .onTapGesture(count: 2) {
                    needToReplaceOffset = true
                }
            } else {
                Text("No gyro for you, sorry.")
            }
        }
        .onReceive(gyroStore.$deviceMotion, perform: updateAttitudes(with:))
        .animation(.linear, value: currentAttitude)
        .statusBar(hidden: true)
    }

    private func updateAttitudes(with motion: CMDeviceMotion?) {
        guard let motion = motion else { return }
        self.currentAttitude = motion.attitude

        if needToReplaceOffset {
            offsetAttitude = motion.attitude.copy() as? CMAttitude
            needToReplaceOffset = false
        }

        if let offsetAttitude = offsetAttitude,
           let currentAttitude = currentAttitude {
            currentAttitude.multiply(byInverseOf: offsetAttitude)
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
            .environmentObject(GyroStore())
    }
}
