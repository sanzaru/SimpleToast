//
//  Toast.swift
//  SwiftUI-Playground
//
//  Created by Martin Albrecht on 12.07.20.
//  Copyright © 2020 Martin Albrecht. All rights reserved.
//

import SwiftUI


public struct SimpleToastOptions {
    var alignment: Alignment = .top
    var delay: TimeInterval? = nil
    var backdrop: Bool? = true
    
    public init(alignment: Alignment = .top, delay: TimeInterval? = nil, backdrop: Bool? = true) {
        self.alignment = alignment
        self.delay = delay
        self.backdrop = backdrop
    }
}


public struct SimpleToast<SimpleToastContent>: ViewModifier where SimpleToastContent: View {
    @Binding var showToast: Bool
    
    @State private var timer: Timer? = nil
    @State private var offset = CGSize.zero
    @State private var opacity: Double = 1
    
    let options: SimpleToastOptions
    let content: () -> SimpleToastContent
    
    public func body(content: Content) -> some View {
        if showToast && timer == nil && options.delay != nil {
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(withTimeInterval: self.options.delay!, repeats: false) { _ in
                    self.hide()
                }
            }
        }
        
        return content.overlay(
            ZStack(alignment: options.alignment) {
                if options.backdrop != nil && options.backdrop! {
                    Rectangle()
                        .fill(Color.white.opacity(0.8))
                        .opacity(showToast ? 1 : 0)
                        .blur(radius: 20)
                }
                
                self.content()
                    .offset(x: 0, y: offset.height)
                    .opacity(self.opacity)
            }
            .opacity(showToast ? 1 : 0)
            .gesture(
                TapGesture()
                    .onEnded {
                        self.hide()
                    }
            )
    
            ,alignment: options.alignment
        )
    }
    
    private func hide() {
        withAnimation {
            self.timer?.invalidate()
            self.timer = nil
            self.offset = .zero
            self.showToast = false
            self.opacity = 1
        }
    }
}

extension View {
    public func simpleToast<SimpleToastContent>(isShowing: Binding<Bool>, options: SimpleToastOptions, content: @escaping () -> SimpleToastContent) -> some View where SimpleToastContent: View {
        self.modifier(
            SimpleToast(showToast: isShowing, options: options, content: content)
        )
    }
}

struct Toast_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Hello Preview")
        }
        .simpleToast(isShowing: .constant(true), options: SimpleToastOptions()) {
            HStack {
                Text("Hello Toast")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(Color.white)
            }
        }
    }
}
