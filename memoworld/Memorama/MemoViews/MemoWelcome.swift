//
//  MemoWelcomes.swift
//  memoworld
//
//  Created by Isaac Rosas Camarillo on 07/11/25.
//

import SwiftUI

struct MemoWelcome: View {
    @ObservedObject var loginViewModel: MemoViewModel
    @Binding var showWelcomeMessage: Bool
    @Binding var showSoundButton: Bool
    
    var body: some View {
        VStack{
            VStack {
                VStack{
                    Text("Hey Niño \n Bad Kid te saluda!")
                        .memoTextStyle(for: .hey)
                    Text("Debes terminar antes de 60 segundos o perderas.")
                        .memoTextStyle(for: .instruction)
                    Button("Comenzar") {
                        showWelcomeMessage = false
                        showSoundButton = true
                        loginViewModel.startSoundWaiting()
                    }
                    .memoTextStyle(for: .buttonStart)
                    Text("¡Suerte, si la encuentras.! 🚀")
                        .memoTextStyle(for: .lucky)
                }
            }
            .memoTextStyle(for: .viewFirst)
            
            VStack {
                Image("badKid")
                    .memoImageBadkidStyle(size: 200)
            }
        }
    }
}

#Preview {
    // MARK: - Mock data para el preview
    let mockViewModel = MemoViewModel() 
    
    MemoWelcome(
        loginViewModel: mockViewModel,
        showWelcomeMessage: .constant(true),
        showSoundButton: .constant(false)
    )
}
