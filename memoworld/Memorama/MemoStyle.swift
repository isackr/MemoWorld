//
//  MemoStyle.swift
//  memoworld
//
//  Created by Isaac Rosas Camarillo on 07/11/25.
//

import SwiftUI

struct AnyViewModifier: ViewModifier {
    private let bodyClosure: (Content) -> AnyView
    
    init<M: ViewModifier>(_ modifier: M) {
        bodyClosure = { content in AnyView(content.modifier(modifier)) }
    }
    
    func body(content: Content) -> some View {
        bodyClosure(content)
    }
}

enum MemoTextStyleType: String, CaseIterable {
    case hey
    case instruction
    case lucky
    case buttonStart
    case counter
    case score
    case scoreBottom
    case viewFirst
    case viewSecond
    case viewThird
    
    func modifier() -> AnyViewModifier {
        switch self {
        case .hey:
            return AnyViewModifier(MemoHeyTextStyle())
        case .instruction:
            return AnyViewModifier(MemoInstructionTextStyle())
        case .lucky:
            return AnyViewModifier(MemoLuckyTextStyle())
        case .buttonStart:
            return AnyViewModifier(MemoButtonStyle())
        case .counter:
            return AnyViewModifier(MemoCounterTextStyle())
        case .score:
            return AnyViewModifier(MemoScoreTextStyle())
        case .scoreBottom:
            return AnyViewModifier(MemoScoreBottomTextStyle())
        case .viewFirst:
            return AnyViewModifier(MemoViewFirstStyle())
        case .viewSecond:
            return AnyViewModifier(MemoViewSecondStyle())
        case .viewThird:
            return AnyViewModifier(MemoViewThirdStyle())
        }
    }
}

struct MemoHeyTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .foregroundColor(.orange)
            .bold()
            .multilineTextAlignment(.center)
    }
}

struct MemoInstructionTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .multilineTextAlignment(.center)
            .padding(20)
            .foregroundStyle(.black)
    }
}

struct MemoLuckyTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .multilineTextAlignment(.center)
            .foregroundColor(.gray)
            .padding()
            .bold()
    }
}

struct MemoButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .foregroundStyle(Color.white)
            .padding(10)
            .bold()
            .background(.orange)
            .cornerRadius(12)
    }
}

struct MemoCounterTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.title)
            .bold()
            .padding(20)
            .background(Circle().fill(Color.black))
    }
}

struct MemoScoreTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.white)
            .padding(.top, 6)
            .padding([.leading, .trailing], 16)
    }
}

struct MemoScoreBottomTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color.white)
            .padding([.leading, .trailing], 16)
            .padding(.bottom, 6)
    }
}

struct MemoViewFirstStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: UIScreen.screenWidth - 40, height: 350)
            .background(Color.white.opacity(0.7))
            .cornerRadius(12)
            .padding(.bottom, 60)
    }
}

struct MemoViewSecondStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding([.leading, .trailing], 16)
            .padding(.top, 75)
    }
}

struct MemoViewThirdStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.purple.opacity(0.1))
            .cornerRadius(20)
            .padding()
    }
}

//Mark: Extensions

extension View {
    func memoTextStyle(for style: MemoTextStyleType) -> some View {
        self.modifier(style.modifier())
    }
}

extension Image {
    func memoImageStyle() -> some View {
        self
            .resizable()
            .scaledToFill()
            .frame(width: UIScreen.main.bounds.width,
                   height: UIScreen.main.bounds.height)
            .ignoresSafeArea()
    }
    func memoImageBadkidStyle(size: CGFloat) -> some View {
        self
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(Circle())
            .shadow(radius: 10)
    }
    func memoImageNavStyle() -> some View {
        self
            .font(.system(size: 20))
            .foregroundColor(.gray)
    }
}

extension Shape {
    func memoRectangleStyle() -> some View {
        self
            .fill(Color.orange.opacity(0.3))
            .frame(height: 1)
            .cornerRadius(20)
    }
}
