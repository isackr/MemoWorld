//
//  LoginStyle.swift
//  memoworld
//
//  Created by Isaac Rosas Camarillo on 06/11/25.
//

import SwiftUI

enum WelcomeTextStyleType: String {
    case hey = "Hey"
    case heySecond = "HeySecond"
    case alias = "Alias"
    case counter = "Counter"
}

struct WelcomeTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
        // 1️⃣ Apariencia del texto
            .font(.headline)
            .foregroundColor(.white)
            .bold()
            .multilineTextAlignment(.center)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
        // 2️⃣ Layout y espaciado
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
        // 3️⃣ Decoración visual
            .background(Color.white.opacity(0.5))
            .cornerRadius(12)
    }
}

struct WelcomeSecondTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .bold()
            .multilineTextAlignment(.center)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color.white.opacity(0.5))
            .cornerRadius(12)
    }
}

struct WelcomeAliasTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundColor(.green)
            .bold()
            .background(Color.white.opacity(0.7))
            .cornerRadius(4)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct WelcomeCounterTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.title)
            .bold()
            .padding( 15)
            .background(Circle().fill(Color.black))
    }
}

extension View {
    func welcomeTextStyle(for style: WelcomeTextStyleType) -> some View {
        switch style {
        case .hey:
            AnyView(self.modifier(WelcomeTextStyle()))
        case .alias:
            AnyView(self.modifier(WelcomeAliasTextStyle()))
        case .heySecond:
            AnyView(self.modifier(WelcomeSecondTextStyle()))
        case .counter:
            AnyView(self.modifier(WelcomeCounterTextStyle()))
        }
    }
}

struct ViewContentWelcomeFrame: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 300, height: 300)
            .background(Color.blue.opacity(0.7))
            .cornerRadius(12)
    }
}
extension View {
    func viewContentWelcomeFrame() -> some View {
        self.modifier(ViewContentWelcomeFrame())
    }
}

struct WelcomeTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.headline)
            .foregroundColor(.indigo)
            .bold()
            .padding()
            .background(Color.white.opacity(0.5))
            .cornerRadius(12)
    }
}

struct WelcomeButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.headline)
            .bold()
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Color.blue)
            .cornerRadius(12)
    }
}
extension View {
    func welcomeButtonStyle() -> some View {
        self.modifier(WelcomeButtonStyle())
    }
}
