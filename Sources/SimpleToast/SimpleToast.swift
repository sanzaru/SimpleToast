//
//  Toast.swift
//  SwiftUI-Playground
//
//  Created by Martin Albrecht on 12.07.20.
//  Copyright © 2020 Martin Albrecht. All rights reserved.
//

import SwiftUI


public struct ToastOptions {
    var alignment: Alignment = .top
    var delay: TimeInterval? = nil
}


struct Toast<ToastContent>: ViewModifier where ToastContent: View {
    @Binding var showToast: Bool
    
    @State private var timer: Timer? = nil
    @State private var offset = CGSize.zero
    @State private var opacity: Double = 1
    
    let options: ToastOptions
    let content: () -> ToastContent
    
    func body(content: Content) -> some View {
        if showToast && timer == nil && options.delay != nil {
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(withTimeInterval: self.options.delay!, repeats: false) { _ in
                    self.hide()
                }
            }
        }
        
        return content.overlay(
            ZStack(alignment: options.alignment) {
                Rectangle()
                    .fill(Color.white.opacity(0.8))
                    .opacity(showToast ? 1 : 0)
                    .blur(radius: 20)
                
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
    func toast<ToastContent>(isShowing: Binding<Bool>, options: ToastOptions, content: @escaping () -> ToastContent) -> some View where ToastContent: View {
        self.modifier(
            Toast(showToast: isShowing, options: options, content: content)
        )
    }
}

struct Toast_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Hello Preview")
        }
        .toast(isShowing: .constant(true), options: ToastOptions()) {
            HStack {
                Text("Hello Toast")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(Color.white)
            }
        }
    }
}
