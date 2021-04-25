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
    @State private var toastOffset: CGSize = .zero
    
    let options: SimpleToastOptions
    let completion: (() -> Void)?
    let content: () -> SimpleToastContent
    
    private var toastDragGesture: some Gesture {
        DragGesture()
            .onChanged {
                if $0.translation.height < self.toastOffset.height {
                    self.toastOffset.height = $0.translation.height
                }
            }
            .onEnded { _ in
                if self.toastOffset.height <= -20 {
                    self.hide()
                }
                
                self.toastOffset = .zero
            }
    }
    
    func body(content: Content) -> some View {
        ZStack(alignment: options.alignment) {
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
                        .gesture(toastDragGesture)
                        .offset(toastOffset)

                case .scale:
                    self.content()
                        .modifier(SimpleToastScale(showToast: $showToast, options: options))
                        .gesture(toastDragGesture)
                        .onTapGesture { withAnimation { showToast.toggle() } }
                        .offset(toastOffset)
                    
                default:
                    self.content()
                        .modifier(SimpleToastFade(showToast: $showToast, options: options))
                        .gesture(toastDragGesture)
                }
            }
        }
        .onAppear {
            if showToast && timer == nil && options.hideAfter != nil {
                self.timer?.invalidate()

                DispatchQueue.main.async {
                    self.timer = Timer.scheduledTimer(withTimeInterval: self.options.hideAfter!, repeats: false) { _ in
                        self.hide()
                    }
                }
            }
        }
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
        @ViewBuilder content: @escaping () -> SimpleToastContent) -> some View where SimpleToastContent: View
    {
        self.modifier(
            SimpleToast(showToast: isShowing, options: options, completion: completion, content: content)
        )
    }
}

