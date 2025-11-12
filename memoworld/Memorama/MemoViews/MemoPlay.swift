//
//  MemoPlay.swift
//  memoworld
//
//  Created by Isaac Rosas Camarillo on 07/11/25.
//

import SwiftUI
import Combine

struct MemoPlay: View {
    @ObservedObject var loginViewModel: MemoViewModel
    @Binding var path: NavigationPath
    @Binding var showWelcomeMessage: Bool
    @Binding var showSoundButton: Bool
    @State var beganToPlay: Bool = false
    @State var indexButtonSelectedOne: Int = 100
    @State var indexButtonSelectedTwo: Int = 100
    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
    @State private var showAlertWin = false

    var body: some View {
        VStack {
            ZStack {
                Color.black.opacity(0.3)
                    .cornerRadius(20)
                VStack {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(0..<12) { index in
                            let card = loginViewModel.cardButtonsArray[index]
                           
                            CardCircleView(card: card)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        loginViewModel.revealCard(at: index)
                                        showAlertWin = loginViewModel.validateWinner()
                                        if showAlertWin {
                                            SoundManager.shared.stopAll()
                                            loginViewModel.stopCoutdown()
                                        }
                                    }
                                }
                        }
                    }
                    .padding()
                    Text("\(loginViewModel.counter)")
                        .memoTextStyle(for: .counter)
                }
                .disabled(loginViewModel.isInteractionDisabled)
            }
            .memoTextStyle(for: .viewSecond)
            
            VStack {
                VStack {
                    HStack {
                        Text("🏆 win: 0")
                            .memoTextStyle(for: .score)
                        Spacer()
                        Text("🚀 Points: 0")
                            .memoTextStyle(for: .score)
                    }
                    HStack {
                        Rectangle()
                            .memoRectangleStyle()
                        
                    }
                    HStack {
                        Text("💀 Losses: 0")
                            .memoTextStyle(for: .scoreBottom)
                        Spacer()
                    }
                }
                .memoTextStyle(for: .viewThird)
            }
            .padding(.bottom, 40)
        }
        .onAppear {
            loginViewModel.startCountdown(timeSeconds: 60)
        }.onDisappear {
            loginViewModel.stopCoutdown()
            SoundManager.shared.stopAll()
        }
        
        if showAlertWin {
            CustomAlertView(isPresented: $showAlertWin,
                            title: "Congratulations! \n You Are a Winner!",
                            message: "Enjoy your new points.",
                            icon: Image(systemName: "sparkles"),
                            style: .warning,
                            primaryAction: {
                loginViewModel.startAgain()
                loginViewModel.startCountdown(timeSeconds: 60)
                loginViewModel.playSoundBackground()
                showAlertWin = false
            },
                            primaryLabel: { Text("Continue") },
                            secondaryAction: {
                loginViewModel.startAgain()
                showWelcomeMessage = true
                showSoundButton = false
            },
                            secondaryLabel: { Text("Cancel")
            })
        }
        
        if loginViewModel.showAlertLose {
            CustomAlertView(isPresented: $loginViewModel.showAlertLose,
                            title: "I'm sorry! \n You have lost!",
                            message: "Try again.",
                            icon: Image(systemName: "sparkles"),
                            style: .warning,
                            primaryAction: {
                loginViewModel.startAgain()
                loginViewModel.startCountdown(timeSeconds: 60)
                loginViewModel.playSoundBackground()
            },
                            primaryLabel: { Text("Continue") },
                            secondaryAction: {
                loginViewModel.startAgain()
                showWelcomeMessage = true
                showSoundButton = false
            },
                            secondaryLabel: { Text("Cancel")
            })
        }
    }
}


#Preview {
    // MARK: - Mock data para el preview
    MemoPlay(
        loginViewModel: MemoViewModel(),
        path: .constant(NavigationPath()),
        showWelcomeMessage: .constant(false),
        showSoundButton: .constant(true)
    )
}
