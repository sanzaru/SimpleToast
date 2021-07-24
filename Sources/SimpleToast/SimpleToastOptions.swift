//
//  SimpleToastOptions.swift
//
//  This file is part of the SimpleToast Swift library: https://github.com/sanzaru/SimpleToast
//
//  Created by Martin Albrecht on 24.04.21.
//  Copyright © 2020 Martin Albrecht. All rights reserved.
//
//  Licensed under Apache License v2.0
//

import SwiftUI


/// Object for customizing the SimpleToast
public struct SimpleToastOptions {
    public var alignment: Alignment
    public var hideAfter: TimeInterval?
    public var showBackdrop: Bool?
    public var backdropColor: Color
    public var animation: Animation?
    public var modifierType: ModifierType

    public enum ModifierType {
        case fade, slide, scale
    }

    public init(
        alignment: Alignment = .top,
        hideAfter: TimeInterval? = nil,
        showBackdrop: Bool? = true,
        backdropColor: Color = Color.white.opacity(0.9),
        animation: Animation? = nil,
        modifierType: ModifierType = .fade
    ) {
        self.alignment = alignment
        self.hideAfter = hideAfter
        self.showBackdrop = showBackdrop
        self.backdropColor = backdropColor
        self.animation = animation
        self.modifierType = modifierType
    }
}
