//
//  MemoPlay.swift
//  memoworld
//
//  Created by Isaac Rosas Camarillo on 07/11/25.
//

import SwiftUI
import Combine

struct MemoPlay: View {
    @Environment(\.modelContext) private var context
    @ObservedObject var memoViewModel: MemoViewModel
    
    @Binding var path: NavigationPath
    @Binding var showWelcomeMessage: Bool
    @Binding var showSoundButton: Bool
    
    @State var beganToPlay: Bool = false
    @State var indexButtonSelectedOne: Int = 100
    @State var indexButtonSelectedTwo: Int = 100
    
    @State private var showAlertWin = false
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
    
    var body: some View {
        VStack {
            // MARK: Game Grid
            ZStack {
                Color.black.opacity(0.3)
                    .cornerRadius(20)
                
                VStack {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(0..<12) { index in
                            let card = memoViewModel.cardButtonsArray[index]
                            
                            CardCircleView(card: card)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        memoViewModel.revealCard(at: index)
                                        
                                        // Validar si ganó
                                        showAlertWin = memoViewModel.validateWinner()
                                        
                                        if showAlertWin {
                                            SoundManager.shared.stopAll()
                                            memoViewModel.stopCoutdown()
                                        }
                                    }
                                }
                        }
                    }
                    .padding()
                    
                    Text("\(memoViewModel.counter)")
                        .memoTextStyle(for: .counter)
                }
                .disabled(memoViewModel.isInteractionDisabled)
            }
            .memoTextStyle(for: .viewSecond)
            
            
            // MARK: Score Section
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
                        Rectangle().memoRectangleStyle()
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
            memoViewModel.startCountdown(timeSeconds: 60)
            memoViewModel.updateContext(context)
        }
        .onDisappear {
            memoViewModel.stopCoutdown()
            SoundManager.shared.stopAll()
        }
        
        // MARK: - Alert de Ganador
        if showAlertWin {
            CustomAlertView(
                isPresented: $showAlertWin,
                title: "\(memoViewModel.getFirstUser()?.name ?? "") \n\n Eres un Ganador! 🚀",
                message: "💠 Disfruta tus nuevos puntos 💠",
                icon: Image(systemName: "sparkles"),
                style: .warning,
                primaryAction: {
                    memoViewModel.saveGamePlayed(isWinner: true)
                    memoViewModel.startAgain()
                    memoViewModel.startCountdown(timeSeconds: 60)
                    memoViewModel.playSoundBackground()
                    showAlertWin = false
                },
                primaryLabel: { Text("Continuar 🚀") },
                secondaryAction: {
                    memoViewModel.saveGamePlayed(isWinner: true)
                    memoViewModel.startAgain()
                    showWelcomeMessage = true
                    showSoundButton = false
                },
                secondaryLabel: { Text("❌ Cancelar") }
            )
        }
        
        // MARK: - Alert de Perdedor
        if memoViewModel.showAlertLose {
            CustomAlertView(
                isPresented: $memoViewModel.showAlertLose,
                title: "\(memoViewModel.getFirstUser()?.name ?? "")! \n\n Perdiste! 👎",
                message: "💠 Lo siento! inténtalo de nuevo 💠",
                icon: Image(systemName: "sparkles"),
                style: .warning,
                primaryAction: {
                    memoViewModel.saveGamePlayed(isWinner: false)
                    memoViewModel.startAgain()
                    memoViewModel.startCountdown(timeSeconds: 60)
                    memoViewModel.playSoundBackground()
                },
                primaryLabel: { Text("Continuar 🚀") },
                secondaryAction: {
                    memoViewModel.startAgain()
                    showWelcomeMessage = true
                    showSoundButton = false
                },
                secondaryLabel: { Text("❌ Cancelar") }
            )
        }
    }
}


#Preview {
    // MARK: - Mock data para el preview
    let memoModel = MemoModel()
    let mockViewModel = MemoViewModel(memoModel: memoModel)
    
    MemoPlay(
        memoViewModel: mockViewModel,
        path: .constant(NavigationPath()),
        showWelcomeMessage: .constant(false),
        showSoundButton: .constant(true)
    )
}
