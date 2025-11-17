//
//  Splash.swift
//  memoworld
//
//  Created by Isaac Rosas Camarillo on 29/10/25.
//

import SwiftUI

struct RootView: View {
    @State private var showSplash = true
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
                    .transition(.opacity) // 👈 Fade out
            } else {
                LoginModule.build()
                    .transition(.opacity)
            }
        }
        .onAppear {
            // ⏱️ Tiempo visible del splash (2.5 seg)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeOut(duration: 0.8)) {
                    showSplash = false
                }
            }
        }
    }
}

struct SplashView: View {
    @State private var scale: CGFloat = 0.6
    @State private var opacity = 0.0
    
    var body: some View {
        ZStack {
            // 🎨 Fondo con gradiente
            LinearGradient(
                colors: [.blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // 🐦 Logo animado
                Image("badKid")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .frame(width: 400, height: 400)
                    .foregroundColor(.white)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeOut(duration: 2)) {
                            scale = 1.0
                            opacity = 1.0
                        }
                    }
                
                // ✨ Nombre de la app
                Text("M E M O W O R L D")
                    .font(.title.bold())
                    .foregroundColor(.cyan)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.5).delay(0.3)) {
                            opacity = 1.0
                        }
                    }
            }
        }
    }
}
