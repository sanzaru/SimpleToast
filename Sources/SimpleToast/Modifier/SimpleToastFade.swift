//
//  SimpleToastFade.swift
//  
//  This file is part of the SimpleToast Swift library: https://github.com/sanzaru/SimpleToast
//  Created by Martin Albrecht on 04.10.21.
//  Licensed under Apache License v2.0
//

import SwiftUI

/// Modifier for the fade animation
struct SimpleToastFade<Item: Identifiable>: SimpleToastModifier {
    @Binding var presentationState: PresentationState<Item>

    let options: SimpleToastOptions?

    func body(content: Content) -> some View {
        content
            .transition(AnyTransition.opacity.animation(options?.animation ?? .linear))
            .opacity(presentationState.isPresented ? 1 : 0)
            .zIndex(1)
    }
}
