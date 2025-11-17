//
//  AlertCustom.swift
//  memoworld
//
//  Created by Isaac Rosas Camarillo on 10/11/25.
//

import SwiftUI
import Combine

public enum AlertStyle {
    case plain, success, warning, error
    var accentColor: Color {
        switch self {
        case .plain: return Color.primary
        case .success: return Color.green
        case .warning: return Color.orange
        case .error: return Color.red
        }
    }
}

public struct CustomAlertView<PrimaryButtonLabel: View, SecondaryButtonLabel: View>: View {
    @Binding var isPresented: Bool
    let title: String
    let message: String?
    let icon: Image?
    let style: AlertStyle
    // Buttons
    let primaryAction: () -> Void
    let primaryLabel: () -> PrimaryButtonLabel
    let secondaryAction: (() -> Void)?
    let secondaryLabel: (() -> SecondaryButtonLabel)?
    // Options
    var allowTapToDismiss: Bool = true
    var blurBackground: Bool = true
    // Init with optional secondary button
    public init(isPresented: Binding<Bool>,
                title: String,
                message: String? = nil,
                icon: Image? = nil,
                style: AlertStyle = .plain,
                allowTapToDismiss: Bool = true,
                blurBackground: Bool = true,
                primaryAction: @escaping () -> Void,
                @ViewBuilder primaryLabel: @escaping () -> PrimaryButtonLabel,
                secondaryAction: (() -> Void)? = nil,
                @ViewBuilder secondaryLabel: @escaping () -> SecondaryButtonLabel) {
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.icon = icon
        self.style = style
        self.allowTapToDismiss = allowTapToDismiss
        self.blurBackground = blurBackground
        self.primaryAction = primaryAction
        self.primaryLabel = primaryLabel
        self.secondaryAction = secondaryAction
        self.secondaryLabel = secondaryLabel
    }
    
    public var body: some View {
        if isPresented {
            GeometryReader { proxy in
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .allowsHitTesting(!allowTapToDismiss)
                    // Alert Card
                    VStack(spacing: 16) {
                        if let icon = icon {
                            icon
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48)
                                .foregroundColor(style.accentColor)
                        }
                        Text(title)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                        if let message = message {
                            Text(message)
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                        }
                        HStack(spacing: 12) {
                            if let secondaryAction = secondaryAction, let secondaryLabel = secondaryLabel {
                                Button(action: {
                                    withAnimation { isPresented = false }
                                    secondaryAction()
                                }) {
                                    secondaryLabel()
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.bordered)
                            }
                            Button(action: {
                                withAnimation { isPresented = false }
                                primaryAction()
                            }) {
                                primaryLabel()
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(style.accentColor)
                        }
                    }
                    .padding(20)
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .shadow(radius: 20)
                    .frame(maxWidth: min(420, proxy.size.width - 40))
                    .multilineTextAlignment(.center)
                    .transition(.scale.combined(with: .opacity))
                    .onAppear {
                        // subtle haptic or sound could be added here
                    }
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isPresented)
        } else {
            EmptyView()
        }
    }
}

// MARK: - VisualEffectBlur helper
// This small wrapper provides a UIKit blur for SwiftUI (works on iOS/macCatalyst).
struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        return view
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

// MARK: - Example usage
struct CustomAlertView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var show = true
        var body: some View {
            ZStack {
                Color(.systemBackground).ignoresSafeArea()
                VStack {
                    Text("Background content")
                    Button("Show Alert") { show = true }
                }
                
                CustomAlertView(isPresented: $show,
                                title: "Welcome!",
                                message: "You have unlocked a new achievement.",
                                icon: Image(systemName: "sparkles"),
                                style: .warning,
                                primaryAction: { print("Primary tapped") },
                                primaryLabel: { Text("OK") },
                                secondaryAction: { print("Cancel tapped") },
                                secondaryLabel: { Text("Cancel") })
            }
        }
    }
    static var previews: some View {
        PreviewWrapper()
    }
}
