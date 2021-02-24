//
//  SimpleToastModifier.swift
//  
//
//  Created by Martin Albrecht on 17.08.20.
//  Copyright © 2020 Martin Albrecht. All rights reserved.
//
//  Licensed under Apache License v2.0
//

import SwiftUI


public enum SimpleToastModifierType {
    case fade, slide
}


protocol SimpleToastModifier: ViewModifier {
    var showToast: Bool { get set }
    var options: SimpleToastOptions? { get set }
}


public struct SimpleToastSlide: SimpleToastModifier {
    @Binding var showToast: Bool
    var options: SimpleToastOptions?

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
    
    public func body(content: Content) -> some View {
        return content
            .transition(AnyTransition.move(edge: transitionEdge).combined(with: .opacity))
            .animation(options?.animation ?? .default)
            .zIndex(1)
    }
}


public struct SimpleToastFade: SimpleToastModifier {
    @Binding var showToast: Bool
    var options: SimpleToastOptions?
    
    public func body(content: Content) -> some View {
        content
            .transition(AnyTransition.opacity.animation(options?.animation ?? .linear))
            .opacity(showToast ? 1 : 0)
    }
}
