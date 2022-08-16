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
            ContentView(viewModel: CodeChallengeViewModel())
        }
    }
}
