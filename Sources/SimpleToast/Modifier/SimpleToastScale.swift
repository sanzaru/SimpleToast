//
//  SimpleToastScale.swift
//  
//  This file is part of the SimpleToast Swift library: https://github.com/sanzaru/SimpleToast
//  Created by Martin Albrecht on 04.10.21.
//  Licensed under Apache License v2.0
//

import SwiftUI

/// Modifier for the scale animation
struct SimpleToastScale: SimpleToastModifier {
    @Binding var showToast: Bool
    let options: SimpleToastOptions?

    func body(content: Content) -> some View {
        content
            .transition(AnyTransition.scale.animation(options?.animation ?? .linear))
            .opacity(showToast ? 1 : 0)
            .zIndex(1)
    }
}
