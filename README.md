# SimpleToast for SwiftUI

[![Build Status](https://travis-ci.com/sanzaru/SimpleToast.svg?branch=develop)](https://travis-ci.com/sanzaru/SimpleToast)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsanzaru%2FSimpleToast%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/sanzaru/SimpleToast)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsanzaru%2FSimpleToast%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/sanzaru/SimpleToast)

SimpleToast is a **simple**, **lightweight** and **easy to use** library to show toasts / popup notifications inside your iOS or MacOS application in SwiftUI.

You decide the content, the library takes care about the rest.

> ⚠️ **Note:** The current version is still in an early development stage. There can and will be breaking changes in version updates.

## Table of contents
- [Features:](#features)
- [Demo](#demo)
- [Installation](#installation)
    + [Swift Package Manager](#swift-package-manager)
    + [Manual](#manual-installation)
- [Usage:](#usage)
- [Options](#options)
- [Changelog](#changelog)

## Features:

* Custom toast content support: You can show whatever you want inside the toast.
* Custom positioning: Place the toast where you want it to be.
* Timeout functionality: You decide if and when the toast should disappear.
* Callback functionality: Run code when the toast disappeared.
* Multiple, customizable animations

## Demo

| Modifier | Demo |
| -------- | ---- |
| *.slide* | <img src="https://raw.githubusercontent.com/sanzaru/SimpleToast.assets/master/video/modifier-slide.gif" width="300" align="center"> |
| *.fade* | <img src="https://raw.githubusercontent.com/sanzaru/SimpleToast.assets/master/video/modifier-fade.gif" width="300" align="center"> |
| *.scale* | <img src="https://raw.githubusercontent.com/sanzaru/SimpleToast.assets/master/video/modifier-scale.gif" width="300" align="center"> |



## Installation

### Swift Package Manager
```swift
dependencies: [
    .package(url: "https://github.com/sanzaru/SimpleToast.git", from: "0.0.1")
]
```

### Manual installation

> **ℹ️ Manual installation is not advised anymore. Please use the package version instead.**

## Usage:

Simply attach the toast to a view and show it via binding with a 5 sec. delay:

```swift
import SwiftUI
import SimpleToast

struct ToastTestView: View {
    @State var showToast: Bool = false

    private let toastOptions = SimpleToastOptions(
        hideAfter: 5
    )

    VStack(spacing: 20) {
        Button(
            action: {
                withAnimation {
                    self.showToast.toggle()
                }
            },
            label: { Text("Show toast") }
        )
    }
    .simpleToast(isShowing: $showToast, options: toastOptions) {
        HStack {
            Image(systemName: "exclamationmark.triangle")
            Text("This is some simple toast message.")
        }
        .padding()
        .background(Color.red.opacity(0.8))
        .foregroundColor(Color.white)
        .cornerRadius(10)
    }
}
```

> **Note:** The toast respects the frame of the view it is attached to. Make sure the view has enough room to render the toast. Preferably the toast should be attached to the most outer view or the navigation view, if available.


To run custom code after the toast disappeared you just simply have to pass a function to the onDismiss parameter:
```swift
import SwiftUI
import SimpleToast

struct ToastTestView: View {
    @State var showToast: Bool = false

    private let toastOptions = SimpleToastOptions(
        hideAfter: 5
    )

    VStack(spacing: 20) {
        Button(
            action: {
                withAnimation {
                    self.showToast.toggle()
                }
            },
            label: { Text("Show toast") }
        )
    }
    .simpleToast(isShowing: $showToast, options: toastOptions, onDismiss: onToastComplete) {
        HStack {
            Image(systemName: "exclamationmark.triangle")
            Text("This is some simple toast message.")
        }
        .padding()
        .background(Color.red.opacity(0.8))
        .foregroundColor(Color.white)
        .cornerRadius(10)
    }

    // This will be called on toast completion
    func onToastComplete() -> Void {
        print("The toast did disappear")
    }
}
```


## Options

The toast can be configured via an optional SimpleToastOptions object. You can simply pass an empty object to configure the toast with default values.

> &nbsp;<br>
> 📌 All parameters inside the options are optional. If not set, the default value will be taken.
> <br>&nbsp;

| Option | Description | Default |
| -------- | ------------- | -------- |
| **alignment** | Defines the alignment of the toast. See [https://developer.apple.com/documentation/swiftui/alignment](https://developer.apple.com/documentation/swiftui/alignment) for more information. | .top |
| **hideAfter** | Defines when the toast disappears. If nil is given the toast won't disappear. | nil |
| **showBackdrop** | Defines if the toast is rendered over a backdrop. | true |
| **backdropColor** | Defines the backdrop color |  Color.white.opacity(0.9) |
| **animation** |  Defines the animation type. See [https://developer.apple.com/documentation/swiftui/animation](https://developer.apple.com/documentation/swiftui/animation) for more information. | .linear |
| **modifierType** |  Defines the type of toast animation. Possible values(.slide, .fade) | .fade |


### The struct has the following signature:

```swift
public struct SimpleToastOptions {
    var alignment: Alignment = .top
    var hideAfter: TimeInterval? = nil
    var showBackdrop: Bool? = true
    var backdropColor: Color = Color.white.opacity(0.9)
    var animation: Animation = .linear
    var modifierType: SimpleToastModifierType = .fade
}
```


## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a overview of changes
