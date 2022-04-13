//
//  SimpleToastSkew.swift
//  
//  This file is part of the SimpleToast Swift library: https://github.com/sanzaru/SimpleToast
//  Created by Martin Albrecht on 04.10.21.
//  Licensed under Apache License v2.0
//

import SwiftUI

private struct RotationModifier: ViewModifier {
    let amount: Double

    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                Angle(degrees: amount),
                axis: (x: 1.0, y: 0.01, z: 0.01),
                anchor: .top,
                perspective: 1.0
            )
    }
}

extension AnyTransition {
    static var skew: AnyTransition {
        .modifier(
            active: RotationModifier(amount: 90),
            identity: RotationModifier(amount: 0)
        )
    }
}

/// Modifier for the skewing animation
struct SimpleToastSkew: SimpleToastModifier {
    @Binding var showToast: Bool
    let options: SimpleToastOptions?

    func body(content: Content) -> some View {
        content
            .transition(
                AnyTransition.skew
                    .combined(with: .scale(scale: 0.01, anchor: .top))
                    .animation(options?.animation ?? .linear)
            )
            .zIndex(1)
    }
}
