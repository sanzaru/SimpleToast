//
//  SimpleToastOptions.swift
//
//  Created by Martin Albrecht on 24.04.21.
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
        showBackdrop: Bool? = true,
        backdropColor: Color = Color.white.opacity(0.9),
        animation: Animation = .linear,
        modifierType: SimpleToastModifierType = .fade
    ) {
        self.alignment = alignment
        self.hideAfter = hideAfter
        self.showBackdrop = showBackdrop
        self.backdropColor = backdropColor
        self.animation = animation
        self.modifierType = modifierType
    }
}
