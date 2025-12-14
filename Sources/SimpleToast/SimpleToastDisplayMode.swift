//
//  SimpleToastDisplayMode.swift
//  SimpleToast
//
//  Created by Martin Albrecht on 14.12.25.
//

/// Defines how the SimpleToast reserves space in its container.
/// - `inline`: Reserves only horizontal space for the toast.
/// - `full`: Reserves both horizontal and vertical space for the toast.
public enum SimpleToastDisplayMode {
    /// Reserves only horizontal space for the toast.
    case inline
    /// Reserves both horizontal and vertical space for the toast.
    case full
}
