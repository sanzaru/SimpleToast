//
//  SimpleToastModifier.swift
//
//  This file is part of the SimpleToast Swift library: https://github.com/sanzaru/SimpleToast
//  
//  Created by Martin Albrecht on 17.08.20.
//  Copyright © 2020 Martin Albrecht. All rights reserved.
//
//  Licensed under Apache License v2.0
//

import SwiftUI


/// Protocol defining the structure of a SimpleToast view modifier
/// The basic building blocks are a boolean value determining whether to show the toast or not and an instance of a SimpleToastOptions object, which is optional.
protocol SimpleToastModifier: ViewModifier {
    var showToast: Bool { get set }
    var options: SimpleToastOptions? { get }
}


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


/// Modifier for the fade animation
struct SimpleToastFade: SimpleToastModifier {
    @Binding var showToast: Bool
    let options: SimpleToastOptions?
    
    func body(content: Content) -> some View {
        content
            .transition(AnyTransition.opacity.animation(options?.animation ?? .linear))
            .opacity(showToast ? 1 : 0)
            .zIndex(1)
    }
}


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
