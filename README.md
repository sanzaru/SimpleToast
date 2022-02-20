# SimpleToast for SwiftUI

[![Build Status](https://travis-ci.com/sanzaru/SimpleToast.svg?branch=develop)](https://travis-ci.com/sanzaru/SimpleToast)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsanzaru%2FSimpleToast%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/sanzaru/SimpleToast)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsanzaru%2FSimpleToast%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/sanzaru/SimpleToast)

SimpleToast is a **simple**, **lightweight** and **easy to use** library to show toasts / popup notifications inside your iOS or MacOS application in SwiftUI.

You decide the content, the library takes care about the rest.

> ⚠️ **Note:** The current version is still in an early development stage. There can and will be breaking changes in version updates.

## 🚨 Breaking changes:
> **0.6.0:** 
> * The options struct is modified and the parameters `showBackdrop` and `backdropColor` are replaced by a single optional Color definition `backdrop`. See [Options](#options) for more information

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
| *.skew* | <img src="https://raw.githubusercontent.com/sanzaru/SimpleToast.assets/master/video/modifier-skew.gif" width="300" align="center"> |



## Installation

### Swift Package Manager
```swift
dependencies: [
    .package(url: "https://github.com/sanzaru/SimpleToast.git", from: "0.0.1")
]
```


## Usage:

There are different ways of attaching a toast notification to your view. The usage is very similar to well know view modifiers (e.g. alert or sheet). If you are familiar with them, using SimpleToast should be quiet easy.

> **Note:** The toast respects the frame of the view it is attached to. Make sure the view has enough room to render the toast. Preferably the toast should be attached to the most outer view or the navigation view, if available.

### Attach via boolean
You can attach the toast to a view and show it via binding to a boolean:

```swift
import SwiftUI
import SimpleToast

struct ToastTestView: View {
    @State var showToast: Bool = false

    private let toastOptions = SimpleToastOptions(
        hideAfter: 5
    )

    VStack(spacing: 20) {
        Button("Show toast") {
            withAnimation {
                showToast.toggle()
            }
        }
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

### Attach via optional object

You can trigger the toast via an instance to an optional object, which conforms to the protocol Identifiable. If the value is not nil the toast will be shown. 

The following example is based on the previous one and also shows the toast, but this time based on a value on an item.

```swift
import SwiftUI
import SimpleToast

struct ToastTestView: View {
    @State var showToast: DummyItem? = nil

    private struct DummyItem: Identifiable {
        var foo: String = "Bar"
    }

    private let toastOptions = SimpleToastOptions(
        hideAfter: 5
    )

    VStack(spacing: 20) {
        Button("Show toast") {
            withAnimation {
                // Toggle the item
                showToast = showToast == nil ? DummyItem() : nil
            }
        }
    }
    .simpleToast(item: $showToast, options: toastOptions) {
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

> &nbsp;<br>
> ℹ️ This functionality is similar to the one of the SwiftUI [sheet(item:onDismiss:content:)](https://developer.apple.com/documentation/swiftui/view/sheet(item:ondismiss:content:))
> <br>&nbsp;

### Run code after dismiss

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
        Button("Show toast") {
            withAnimation {
                showToast.toggle()
            }
        }
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

| Option | Type | Description | Default |
| -------- | ---- | ------------- | -------- |
| **alignment** | [Alignment](https://developer.apple.com/documentation/swiftui/alignment) | Defines the alignment of the toast. | .top |
| **hideAfter** | [TimeInterval?](https://developer.apple.com/documentation/foundation/timeinterval) | Defines when the toast disappears. If nil is given the toast won't disappear. | nil |
| **backdrop** | [Color?](https://developer.apple.com/documentation/swiftui/color) | Defines the backdrop color | nil |
| **animation** | [Animation](https://developer.apple.com/documentation/swiftui/animation) | Defines the animation type. | .linear |
| **modifierType** | [ModifierType](#Demo) | Defines the type of toast animation. Possible values(.slide, .fade) | .fade |
