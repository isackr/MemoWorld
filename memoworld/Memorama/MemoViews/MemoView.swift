//
//  MemoView.swift
//  memoworld
//
//  Created by Isaac Rosas Camarillo on 16/10/25.
//

import SwiftUI
import SwiftData
import Combine

struct MemoView: View {
    @ObservedObject var memoViewModel: MemoViewModel
    @Binding var path: NavigationPath
    @State private var alias: String = ""
    @State private var showWelcomeMessage: Bool = true
    @State private var isMuted = false
    @State private var showSoundButton = false
    
    init(memoViewModel: MemoViewModel, path: Binding<NavigationPath> = .constant(NavigationPath())) {
        self.memoViewModel = memoViewModel
        _path = path
    }
    
    var body: some View {
        VStack {
            ZStack {
                Image("planetsBackground")
                    .memoImageStyle()
                
                if showWelcomeMessage {
                    MemoWelcome(memoViewModel: memoViewModel,
                                showWelcomeMessage: $showWelcomeMessage,
                                showSoundButton: $showSoundButton)
                } else {
                    MemoPlay(memoViewModel: memoViewModel,
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
                                memoViewModel.startSoundWaiting()
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
    let memoModel = MemoModel()
    let mockViewModel = MemoViewModel(memoModel: memoModel)
    MemoView(memoViewModel: mockViewModel)
}
