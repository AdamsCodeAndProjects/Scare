//
//  OnBoardingView.swift
//  RestartApp
//
//  Created by adam janusewski on 5/2/22.
//

import SwiftUI

struct OnBoardingView: View {
    @AppStorage("onboarding") var isOnBoardingViewActive: Bool = true
    
    @State private var buttonWidth: Double = UIScreen.main.bounds.width - 80 // The screens width - 80 points
    @State private var buttonOffset: CGFloat = 0 // representing the slide button value
    @State private var isAnimating: Bool = false
    @State private var imageOffset: CGSize = .zero
    @State private var indicatorOpacity: Double = 1.0
    @State private var textTitle: String = "Scare."
    
    let hapticFeedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        ZStack {
            Color("ColorBlue")
                .ignoresSafeArea(.all, edges: .all)
            VStack(spacing: 20) {
                // MARK: - HEADER
                
//                Spacer()
                VStack(spacing: 0) {
                    Text(textTitle)
                        .font(.system(size: 60))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .transition(.opacity)
                        .id(textTitle) // Give text a new id, causing an animation in the text
                    
                    Text("""
                    Monsters are real.  Ghosts are real too.  They live inside us, and sometimes, they win.
                    """)
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                }
                // Animation for text brings it down when app begins
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : -40)
                .animation(.easeOut(duration: 1), value: isAnimating)
                
                // MARK: - CENTER
                
                ZStack {
                    CircleGroupView(ShapeColor: .white, ShapeOpacity: 0.2)
                    //  Moving the ring when the image moves in the opposite direction
                        .offset(x: imageOffset.width * -1)
                        .blur(radius: abs(imageOffset.width / 5))
                        .animation(.easeOut, value: imageOffset)
                    
                    Image("SadOpera")   // Place the Image here.....
                        .resizable()
                        .scaledToFit()
                        .offset(x: 50)
                        .opacity(isAnimating ? 1 : 0)
                        .offset(x: imageOffset.width * 1.2, y: 0)
                        .rotationEffect(.degrees(Double(imageOffset.width / 20)))
                    // Rotates image slightly
                        .animation(.easeOut(duration: 0.5), value: isAnimating)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if abs(imageOffset.width) <= 150 {
                                        imageOffset = gesture.translation
                                        
                                        // Hides the arrow
                                        withAnimation(.linear(duration: 0.25)) {
                                            indicatorOpacity = 0
                                            textTitle = "ME!"
                                        }
                                    }
                                }
                            // brings image back to original position
                                .onEnded { _ in
                                    imageOffset = .zero
                                    
                                    // Making arrow visible again
                                    withAnimation(.linear(duration: 0.25)) {
                                        indicatorOpacity = 1
                                        textTitle = "Scare."
                                    }
                                }
                        )
                    // Will go back to its original position in 1 second
                        .animation(.easeOut(duration: 1), value: imageOffset)
                }
                // Displaying the Circle / Arrow image
                .overlay(
                    Image(systemName: "arrow.left.and.right.circle")
                        .font(.system(size: 44, weight: .ultraLight))
                        .foregroundColor(.white)
                        .offset(y: 40)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeOut(duration: 1).delay(2), value: isAnimating)
                        .opacity(indicatorOpacity)
                    , alignment: .bottom
                )
                
                Spacer()
                
                // MARK: - FOOTER
                
                ZStack {
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                        .padding(8)
                    
                    Text("Get Started")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(x: 20)
                    
                    HStack {
                        Capsule()
                            .fill(Color("ColorRed"))
                            .frame(width: buttonOffset + 80)  //  Keeps the color behind the slide
                        
                        Spacer()
                    }
                    
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color("ColorRed"))
                            Circle()
                                .fill(.black.opacity(0.15))
                                .padding(8)
                            Image(systemName: "chevron.right.2")
                                .font(.system(size: 24, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80, alignment: .center)
                        .offset(x: buttonOffset)
                        // Creates the dragging
                        .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                // Ensuring the button cannot leave the slide bar
                                if gesture.translation.width > 0 && buttonOffset <= buttonWidth - 80 {
                                    buttonOffset = gesture.translation.width
                                }
                            }
                        //  When we stop dragging, go to 100 if > 50%.  else 0%
                            .onEnded { _ in
                                // When changing from OnBoarding to Home, animate
                                withAnimation(Animation.easeOut(duration: 0.8)) {
                                    hapticFeedback.notificationOccurred(.success)
                                    if buttonOffset > buttonWidth / 2 {
                                        playSound(sound: "", type: "mp3")  // Place in audio file here
                                        buttonOffset = buttonWidth - 80
                                        isOnBoardingViewActive = false
                                    } else {
                                        hapticFeedback.notificationOccurred(.warning)
                                        buttonOffset = 0
                                    }
                                }
                            }
                        ) // Gesture
                        
                        Spacer()
                    }
                }
                .frame(width: buttonWidth, height: 80, alignment: .center)
                .padding()
                
                //  Slider animates up and fades in
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 40)
                .animation(.easeOut(duration: 1), value: isAnimating)
            }
        }
        .onAppear(perform: {
            isAnimating = true
        })
        .preferredColorScheme(.dark)
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}
