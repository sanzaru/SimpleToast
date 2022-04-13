//
//  SimpleToastSlide.swift
//
//  This file is part of the SimpleToast Swift library: https://github.com/sanzaru/SimpleToast
//  Created by Martin Albrecht on 04.10.21.
//  Licensed under Apache License v2.0
//

import SwiftUI

/// Modifier foe the slide animation
struct SimpleToastSlide: SimpleToastModifier {
    @Binding var showToast: Bool
    let options: SimpleToastOptions?

    private var transitionEdge: Edge {
        if let pos = options?.alignment ?? nil {
            switch pos {
            case .top, .topLeading, .topTrailing:
                return .top

            case .bottom, .bottomLeading, .bottom:
                return .bottom

            default:
                return .top
            }
        }

        return .top
    }

    func body(content: Content) -> some View {
        return content
            .transition(AnyTransition.move(edge: transitionEdge).combined(with: .opacity))
            .animation(options?.animation ?? .default)
            .zIndex(1)
    }
}
