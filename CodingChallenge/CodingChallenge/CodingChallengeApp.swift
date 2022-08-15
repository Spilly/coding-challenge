//
//  CodingChallengeApp.swift
//  CodingChallenge
//
//  Created by Aaron McDaniel on 8/11/22.
//

import SwiftUI

@main
struct CodingChallengeApp: App {
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { (newScenePhase) in
            switch newScenePhase {
            case .active:
                // The scene is in the foreground and interactive.
                print("active")
            case .inactive:
                // The scene is in the foreground but should pause its work.
                print("inactive")
            case .background:
                // The scene isn’t currently visible in the UI.
                print("background")
            @unknown default:
                break
            }
        }
    }
}
