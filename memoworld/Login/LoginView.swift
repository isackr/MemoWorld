//
//  ContentView.swift
//  memoworld
//
//  Created by Isaac Rosas Camarillo on 16/10/25.
//

import SwiftUI
import SwiftData
import Combine

struct LoginView: View {
    @Environment(\.modelContext) private var context
    @ObservedObject var loginViewModel: LoginViewModel
    @State var alias: String = ""
    @State private var path = NavigationPath()
    @State var showWelcomeMessage: Bool = true
    @State private var counter = 0
    @State private var timerCancellable: AnyCancellable?
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Image("coheteBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                if showWelcomeMessage {
                    VStack {
                        VStack {
                            Text("Hey! 👋\n Vamos a iniciar RETADOR\n ¿Cuál sera tu Alias?")
                                .welcomeTextStyle(for: WelcomeTextStyleType.hey)
                            
                            TextField("Alias", text: $alias)
                                .textFieldStyle(WelcomeTextFieldStyle())
                            
                            if (alias.count > 0 && !loginViewModel.isAliasValid(alias: alias)) {
                                Text("*Debe ser de 3 a 15 caracteres")
                                    .welcomeTextStyle(for: WelcomeTextStyleType.alias)
                            }
                            Button("Continuar") {
                                if loginViewModel.isAliasValid(alias: alias) {
                                    loginViewModel.cleanModels()
                                    let newUser = User(name: alias)
                                    if loginViewModel.saveUser(newUser) {
                                        _ = loginViewModel.saveGame()
                                        showWelcomeMessage = false
                                        startCountdown()
                                    } else {
                                        print("no lo guardo")
                                    }
                                }
                            }
                            .welcomeButtonStyle()
                        }
                        .padding(20)
                    }
                    .viewContentWelcomeFrame()
                } else {
                    VStack {
                        VStack {
                            (
                                Text("MEMORAMA \nTe da la bienvenida👋 \n\n")
                                    .foregroundColor(.white)
                                + Text("\(loginViewModel.getFirstUser()?.name ?? "RETADOR") \n\n")
                                    .foregroundColor(.blue)
                                    .bold()
                                + Text("¡Disfruta de la aventura! 🚀")
                                    .foregroundColor(.white)
                            )
                            .welcomeTextStyle(for: WelcomeTextStyleType.heySecond)
                            
                            Text("\(counter)")
                                .welcomeTextStyle(for: WelcomeTextStyleType.counter)
                        }
                        .padding(20)
                    }
                    .viewContentWelcomeFrame()
                }
            }
            .navigationDestination(for: String.self) { value in
                if value == "goMemoView" {
                    MemoModule.build()
                }
            }
        }
        .onAppear {
            loginViewModel.updateContext(context)
        }
        .onDisappear {
            showWelcomeMessage = true
        }
    }
    
    func startCountdown() {
        counter = 5
        // Crea un timer que se repite cada segundo
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                counter -= 1
                if counter == 0 {
                    timerCancellable?.cancel()
                    path.append("goMemoView")
                    print("🎯 Acción al finalizar el conteo")
                }
            }
    }
}

#Preview {
    LoginModule.build()
}

