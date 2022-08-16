//
//  ContentView.swift
//  CodingChallenge
//
//  Created by Aaron McDaniel on 8/11/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: CodeChallengeViewModel

    var body: some View {
        VStack(spacing: 16) {
            Text("Current state: \(viewModel.codeChallengeState.displayText())")
            Button("Run Code Challenge") {
                viewModel.runCodingChallenge()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: CodeChallengeViewModel())
    }
}
