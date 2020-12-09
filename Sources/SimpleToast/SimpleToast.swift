//
//  SimpleToast.swift
//
//  Created by Martin Albrecht on 12.07.20.
//  Copyright © 2020 Martin Albrecht. All rights reserved.
//
//  Licensed under Apache License v2.0
//

import SwiftUI


public struct SimpleToastOptions {
    var alignment: Alignment
    var hideAfter: TimeInterval?
    var showBackdrop: Bool?
    var backdropColor: Color
    var animation: Animation
    var modifierType: SimpleToastModifierType
    
    public init(
        alignment: Alignment = .top,
        hideAfter: TimeInterval? = nil,
        backdrop: Bool? = true,
        backdropColor: Color = Color.white.opacity(0.9),
        animation: Animation = .linear,
        modifierType: SimpleToastModifierType = .fade
    ) {
        self.alignment = alignment
        self.hideAfter = hideAfter
        self.showBackdrop = backdrop
        self.backdropColor = backdropColor
        self.animation = animation
        self.modifierType = modifierType
    }
}


struct SimpleToast<SimpleToastContent: View>: ViewModifier {
    @Binding var showToast: Bool
    
    @State private var timer: Timer? = nil    
    @State private var toastOffset: CGSize = .zero
    
    let options: SimpleToastOptions
    let completion: (() -> Void)?
    let content: () -> SimpleToastContent
    
    private var toastDragGesture: some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .local)
            .onChanged { gesture in
                self.toastOffset.height = gesture.translation.height
            }
            .onEnded { _ in
                self.hide()
            }
    }
    
    func body(content: Content) -> some View {
        if showToast && timer == nil && options.hideAfter != nil {
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(withTimeInterval: self.options.hideAfter!, repeats: false) { _ in
                    self.hide()
                }
            }
        }
        
        return content
                .overlay(
                    // Backdrop
                    Group { EmptyView() }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(options.backdropColor.edgesIgnoringSafeArea(.all))
                        .opacity(options.showBackdrop != nil && options.showBackdrop! && showToast ? 1 : 0)
                        .onTapGesture { self.hide() }
                )
                .overlay(
                    // Toast Content
                    VStack {
                        switch options.modifierType {
                        case .slide:
                            self.content()
                                .modifier(SimpleToastSlide(showToast: $showToast, options: options))
                        default:
                            self.content()
                                .modifier(SimpleToastFade(showToast: $showToast, options: options))
                        }                        
                    }
                    .offset(toastOffset)
                    .gesture(toastDragGesture)
            
                    ,alignment: options.alignment
                )
    }
    
    private func hide() {
        withAnimation {
            self.timer?.invalidate()
            self.timer = nil
            self.showToast = false
            self.toastOffset = .zero
            
            self.completion?()
        }
    }
}


extension View {
    public func simpleToast<SimpleToastContent>(
        isShowing: Binding<Bool>, options: SimpleToastOptions,
        completion: (() -> Void)? = nil,
        content: @escaping () -> SimpleToastContent) -> some View where SimpleToastContent: View
    {
        self.modifier(
            SimpleToast(showToast: isShowing, options: options, completion: completion, content: content)
        )
    }
}

