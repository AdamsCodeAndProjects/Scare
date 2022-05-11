//
//  Home.swift
//  RestartApp
//
//  Created by adam janusewski on 5/2/22.
//

import SwiftUI

struct Home: View {
    @AppStorage("onboarding") var isOnBoardingViewActive: Bool = false
    @State private var isAnimating: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            // MARK: - HEADER
            
            Spacer()
            
            ZStack {
                CircleGroupView(ShapeColor: .gray, ShapeOpacity: 0.1)
                Image("Skull")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .offset(y: isAnimating ? 45 : -45)
                    .animation(
                        Animation
                            .easeInOut(duration: 0.55)
                            .repeatForever()
                        , value: isAnimating
                    )
            }
            
            // MARK: - CENTER
            
            Text("Adversity makes men, and prosperity makes monsters")
                .font(.title3)
                .fontWeight(.light)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
            
            // MARK: - FOOTER
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    playSound(sound: "", type: "m4a")
                    isOnBoardingViewActive = true
                }
            }) {
                Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                    .imageScale(.large)
                
                Text("Restart")
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.large)
        } // VStack
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                isAnimating = true
            })
        })
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
