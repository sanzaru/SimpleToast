//
//  SimpleToast.swift
//
//  This file is part of the SimpleToast Swift library: https://github.com/sanzaru/SimpleToast
//  Created by Martin Albrecht on 12.07.20.
//  Licensed under Apache License v2.0
//

import SwiftUI

struct SimpleToastDragGestureModifier: ViewModifier {
    @Binding var offset: CGSize
    let options: SimpleToastOptions
    var onCompletion: () -> Void

    @State private var delta: CGFloat = 0

    #if !os(tvOS)
    private let maxGestureDelta: CGFloat = 20

    /// Dimiss the toast on drag
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { [self] in
                if options.disableDragGesture { return }

                delta = 0

                switch options.alignment {
                case .top, .topLeading, .topTrailing:
                    if $0.translation.height <= offset.height {
                        offset.height = $0.translation.height
                    }
                    delta += abs(offset.height)

                case .bottom, .bottomLeading, .bottomTrailing:
                    if $0.translation.height >= offset.height {
                        offset.height = $0.translation.height
                    }
                    delta += abs(offset.height)

                case .leading:
                    if $0.translation.width <= offset.width {
                        offset.width = $0.translation.width
                    }
                    delta += abs(offset.width)

                case .trailing:
                    if $0.translation.width >= offset.width {
                        offset.width = $0.translation.width
                    }
                    delta += abs(offset.width)

                default:
                    if $0.translation.height < offset.height {
                        offset.height = $0.translation.height
                    }
                    delta += abs(offset.height)
                }
            }
            .onEnded { [self] _ in
                if options.disableDragGesture { return }

                if delta >= maxGestureDelta {
                    return onCompletion()
                }

                offset = .zero
            }
    }
    #endif

    func body(content: Content) -> some View {
        content
            #if !os(tvOS)
            .gesture(dragGesture)
            #endif
    }
}
