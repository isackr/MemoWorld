//
//  MemoView.swift
//  memoworld
//
//  Created by Isaac Rosas Camarillo on 16/10/25.
//

import SwiftUI
import SwiftData
import Combine

struct MemoMainView<ViewModel: MemoViewModelProtocol>: View {
    @Environment(\.modelContext) private var context
    @ObservedObject var loginViewModel: MemoViewModel
    @Binding var path: NavigationPath
    @State private var alias: String = ""
    @State private var showWelcomeMessage: Bool = true
    @State private var isMuted = false
    @State private var showSoundButton = false
    
    init(loginViewModel: MemoViewModel, path: Binding<NavigationPath> = .constant(NavigationPath())) {
        self.loginViewModel = loginViewModel
        _path = path
    }
    
    var body: some View {
        VStack {
            ZStack {
                Image("planetsBackground")
                    .memoImageStyle()
                
                if showWelcomeMessage {
                    MemoWelcome(loginViewModel: loginViewModel,
                                showWelcomeMessage: $showWelcomeMessage,
                                showSoundButton: $showSoundButton)
                } else {
                    MemoPlay(loginViewModel: loginViewModel,
                             path: $path,
                             showWelcomeMessage: $showWelcomeMessage,
                             showSoundButton: $showSoundButton)
                }
            }
            .navigationTitle("MEMOWORLD")
            .toolbarBackground(.white, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .tint(.white)
            .toolbar {
                // Button setup
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print("Botón derecho tocado")
                    } label: {
                        Image(systemName: "gearshape")
                            .memoImageNavStyle()
                    }
                }
                // Button sound
                if showSoundButton {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            isMuted.toggle()
                            if isMuted {
                                SoundManager.shared.stopAll()
                            } else {
                                loginViewModel.startSoundWaiting()
                            }
                        } label: {
                            Image(systemName: isMuted ? "speaker.slash" : "speaker.wave.2")
                                .memoImageNavStyle()
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    MemoMainView<MemoViewModel>(loginViewModel: MemoViewModel())
}

