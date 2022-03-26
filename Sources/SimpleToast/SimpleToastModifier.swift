//
//  SimpleToastModifier.swift
//
//  This file is part of the SimpleToast Swift library: https://github.com/sanzaru/SimpleToast
//  Created by Martin Albrecht on 17.08.20.
//  Licensed under Apache License v2.0
//

import SwiftUI

/// Protocol defining the structure of a SimpleToast view modifier
/// The basic building blocks are a boolean value determining whether to show the toast or not and an instance of a SimpleToastOptions object, which is optional.
protocol SimpleToastModifier: ViewModifier {
    var showToast: Bool { get set }
    var options: SimpleToastOptions? { get }
}
