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
    var alignment: Alignment = .top
    var delay: TimeInterval? = nil
    var backdrop: Bool? = true
    var backdropColor: Color = Color.white.opacity(0.9)
    var animation: Animation = .linear
    var modifierType: SimpleToastModifierType = .fade
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
        if showToast && timer == nil && options.delay != nil {
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(withTimeInterval: self.options.delay!, repeats: false) { _ in
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
                        .opacity(options.backdrop != nil && options.backdrop! && showToast ? 1 : 0)
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

