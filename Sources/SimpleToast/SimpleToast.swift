//
//  SimpleToast.swift
//
//  This file is part of the SimpleToast Swift library: https://github.com/sanzaru/SimpleToast
//  Created by Martin Albrecht on 12.07.20.
//  Licensed under Apache License v2.0
//

import SwiftUI

struct SimpleToast<SimpleToastContent: View>: ViewModifier {
    @Binding var showToast: Bool
    
    let options: SimpleToastOptions
    let onDismiss: (() -> Void)?

    @State private var timer: Timer? = nil
    @State private var offset: CGSize = .zero

    private let toastContent: SimpleToastContent

    /// Dimiss the toast on drag
    /// TODO: Needs better implementation.
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { [self] in
                if $0.translation.height < offset.height {
                    offset.height = $0.translation.height
                }
            }
            .onEnded { [self] _ in
                if offset.height <= -20 {
                    dismiss()
                }
                
                offset = .zero
            }
    }

    init(
        showToast: Binding<Bool>,
        options: SimpleToastOptions,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> SimpleToastContent
    ) {
        self._showToast = showToast
        self.options = options
        self.onDismiss = onDismiss
        self.toastContent = content()
    }
    
    func body(content: Content) -> some View {
        // Main view content
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Backdrop
            .overlay(
                Group { EmptyView() }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(options.backdrop?.edgesIgnoringSafeArea(.all))
                    .opacity(options.backdrop != nil && showToast ? 1 : 0)
                    .onTapGesture(perform: dismiss)
            )
        
            // Toast content
            .overlay (
                VStack {
                    if showToast {
                        Group {
                            switch options.modifierType {
                            case .slide:
                                toastContent
                                    .modifier(SimpleToastSlide(showToast: $showToast, options: options))
                                    .gesture(dragGesture)
                                    .onTapGesture(perform: dismiss)
                                    .offset(offset)
        
                            case .scale:
                                toastContent
                                    .modifier(SimpleToastScale(showToast: $showToast, options: options))
                                    .gesture(dragGesture)
                                    .onTapGesture(perform: dismiss)
                                    .offset(offset)
        
                            case .skew:
                                toastContent
                                    .modifier(SimpleToastSkew(showToast: $showToast, options: options))
                                    //.gesture(dragGesture)
                                    .onTapGesture(perform: dismiss)
                                    .offset(offset)
        
                            default:
                                toastContent
                                    .modifier(SimpleToastFade(showToast: $showToast, options: options))
                                    .gesture(dragGesture)
                                    .onTapGesture(perform: dismiss)
                            }
                        }
                        .onAppear(perform: dismissAfterTimeout)
                    }
                }
                
                , alignment: options.alignment
            )
    }

    /// Dismiss the sheet after the timeout specified in the options
    private func dismissAfterTimeout() {
        if let timeout = options.hideAfter, showToast, options.hideAfter != nil {
            DispatchQueue.main.async { [self] in
                timer?.invalidate()
                timer = Timer.scheduledTimer(withTimeInterval: timeout, repeats: false, block: { _ in dismiss() })
            }
        }
    }

    /// Dismiss the toast and reset all nessasary parameters
    private func dismiss() {
        withAnimation {
            timer?.invalidate()
            timer = nil
            showToast = false
            offset = .zero
            
            onDismiss?()
        }
    }
}

// MARK: - View extensions

public extension View {
    /// Present the sheet based on the state of a given binding to a boolean.
    ///
    /// - NOTE: The toast will be attached to the view's frame it is attached to and not the general UIScreen.
    /// - Parameters:
    ///   - isShowing: Boolean binding as source of truth for presenting the toast
    ///   - options: Options for the toast
    ///   - onDismiss: Closure called when the toast is dismissed
    ///   - content: Inner content for the toast
    /// - Returns: The toast view
    @available(*, deprecated, renamed: "simpleToast(isPresented:options:onDismiss:content:)")
    func simpleToast<SimpleToastContent: View>(
        isShowing: Binding<Bool>, options: SimpleToastOptions,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> SimpleToastContent) -> some View
    {
        self.modifier(
            SimpleToast(showToast: isShowing, options: options, onDismiss: onDismiss, content: content)
        )
    }


    /// Present the sheet based on the state of a given binding to a boolean.
    ///
    /// - NOTE: The toast will be attached to the view's frame it is attached to and not the general UIScreen.
    /// - Parameters:
    ///   - isPresented: Boolean binding as source of truth for presenting the toast
    ///   - options: Options for the toast
    ///   - onDismiss: Closure called when the toast is dismissed
    ///   - content: Inner content for the toast
    /// - Returns: The toast view
    func simpleToast<SimpleToastContent: View>(
        isPresented: Binding<Bool>, options: SimpleToastOptions,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> SimpleToastContent) -> some View
    {
        self.modifier(
            SimpleToast(showToast: isPresented, options: options, onDismiss: onDismiss, content: content)
        )
    }


    /// Present the sheet based on the state of a given optional item.
    /// If the item is non-nil the toast will be shown, otherwise it is dimissed.
    ///
    /// - NOTE: The toast will be attached to the view's frame it is attached to and not the general UIScreen.
    /// - Parameters:
    ///   - item: Optional item as source of truth for presenting the toast
    ///   - options: Options for the toast
    ///   - onDismiss: Closure called when the toast is dismissed
    ///   - content: Inner content for the toast
    /// - Returns: The toast view
    func simpleToast<SimpleToastContent: View, Item: Identifiable>(
        item: Binding<Item?>?, options: SimpleToastOptions,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> SimpleToastContent
    ) -> some View {
        let bindingProxy = Binding<Bool>(
            get: { item?.wrappedValue != nil },
            set: {
                if !$0 {
                    item?.wrappedValue = nil
                }
            }
        )

        return self.modifier(
            SimpleToast(showToast: bindingProxy, options: options, onDismiss: onDismiss, content: content)
        )
    }
}
