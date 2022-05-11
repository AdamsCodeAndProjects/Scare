//
//  ContentView.swift
//  RestartApp
//
//  Created by adam janusewski on 5/2/22.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("onboarding") var isOnBoardingViewActive: Bool = true // using device storage
    
    var body: some View {
        ZStack {
            if isOnBoardingViewActive {
                OnBoardingView()
            } else {
                Home()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
