//
//  SimpleToast.swift
//
//  Created by Martin Albrecht on 12.07.20.
//  Copyright © 2020 Martin Albrecht. All rights reserved.
//
//  Licensed under Apache License v2.0
//

import SwiftUI


struct SimpleToast<SimpleToastContent: View>: ViewModifier {
    @Binding var showToast: Bool
    
    @State private var timer: Timer? = nil    
    @State private var offset: CGSize = .zero
    
    let options: SimpleToastOptions
    let completion: (() -> Void)?
    
    let content: () -> SimpleToastContent
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { [self] in
                if $0.translation.height < offset.height {
                    offset.height = $0.translation.height
                }
            }
            .onEnded { [self] _ in
                if offset.height <= -20 {
                    hide()
                }
                
                offset = .zero
            }
    }
    
    func body(content: Content) -> some View {
        if showToast && options.hideAfter != nil {
            hideAfterTimeout()
        }

        return ZStack(alignment: options.alignment) {
            content
                // Backdrop
                .overlay(
                    Group { EmptyView() }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(options.backdropColor.edgesIgnoringSafeArea(.all))
                        .opacity(options.showBackdrop != nil && options.showBackdrop! && showToast ? 1 : 0)
                        .onTapGesture { self.hide() }
                )

            // Toast Content
            if showToast {                
                switch options.modifierType {
                case .slide:
                    self.content()
                        .modifier(SimpleToastSlide(showToast: $showToast, options: options))
                        .gesture(dragGesture)
                        .offset(offset)

                case .scale:
                    self.content()
                        .modifier(SimpleToastScale(showToast: $showToast, options: options))
                        .gesture(dragGesture)
                        .onTapGesture { withAnimation { showToast.toggle() } }
                        .offset(offset)
                    
                default:
                    self.content()
                        .modifier(SimpleToastFade(showToast: $showToast, options: options))
                        .gesture(dragGesture)
                }
            }
        }
    }


    private func hideAfterTimeout() {
        if let timeout = options.hideAfter {
            DispatchQueue.main.async { [self] in
                timer?.invalidate()
                timer = Timer.scheduledTimer(withTimeInterval: timeout, repeats: false, block: { _ in hide() })
            }
        }
    }
    
    private func hide() {
        withAnimation {
            timer?.invalidate()
            timer = nil
            showToast = false
            offset = .zero
            
            completion?()
        }
    }
}


extension View {
    public func simpleToast<SimpleToastContent>(
        isShowing: Binding<Bool>, options: SimpleToastOptions,
        completion: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> SimpleToastContent) -> some View where SimpleToastContent: View
    {
        self.modifier(
            SimpleToast(showToast: isShowing, options: options, completion: completion, content: content)
        )
    }
}

