//
//  MemoWelcomes.swift
//  memoworld
//
//  Created by Isaac Rosas Camarillo on 07/11/25.
//

import SwiftUI

struct MemoWelcome: View {
    @ObservedObject var memoViewModel: MemoViewModel
    @Binding var showWelcomeMessage: Bool
    @Binding var showSoundButton: Bool
    
    var body: some View {
        VStack{
            VStack {
                VStack{
                    Text("✨\(memoViewModel.getFirstUser()?.name ?? "")✨ \n Bad Kid te saluda!")
                        .memoTextStyle(for: .hey)
                    Text("Debes terminar antes de 60 segundos o perderas.")
                        .memoTextStyle(for: .instruction)
                    Button("Comenzar") {
                        showWelcomeMessage = false
                        showSoundButton = true
                        memoViewModel.startSoundWaiting()
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
    let memoModel = MemoModel()
    let mockViewModel = MemoViewModel(memoModel: memoModel)
    MemoWelcome(
        memoViewModel: mockViewModel,
        showWelcomeMessage: .constant(true),
        showSoundButton: .constant(false)
    )
}
