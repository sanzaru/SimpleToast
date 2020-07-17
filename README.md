# SimpleToast for SwiftUI

SimpleToast is a simple, lightweight and easy to use swift package to show toasts / popup notifications inside your iOS or MacOS application in SwiftUI. 

You decide the content, the library takes care about the rest.

## Features: 

* Custom toast content support: You can show whatever you want inside the toast.
* Timeout functionality: You decide if and when the toast should disappear.
* Callback functionality: Run code when the toast disappeared.

## Installation

### Swift Package Manager
```swift
dependencies: [
    .package(url: "https://github.com/sanzaru/SimpleToast.git", from: "0.0.1")
]
```

### Manual
Simply drag the SimpleToast.swift file into your project.


## Usage:

Simply attach the toast to a view and show it via binding with a 5 sec. delay:

```swift
import SwiftUI
import SimpleToast

struct ToastTestView: View {
    @State var showToast: Bool = false

    private let toastOptions = SimpleToastOptions(
        delay: 5
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

> **NOTE:** The toast respects the frame of the view it is attached to. Make sure the view has enough room to render the toast. Preferably the view should be attached to the most outer view or the navigation view, if available.


To run custom code after the toast did disappear you just simply have to pass the function:
```swift
import SwiftUI
import SimpleToast

struct ToastTestView: View {
    @State var showToast: Bool = false

    private let toastOptions = SimpleToastOptions(
        delay: 5
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
    .simpleToast(isShowing: $showToast, options: toastOptions, completion: onToastComplete) {
        HStack {
            Image(systemName: "exclamationmark.triangle")
            Text("This is some simple toast message.")                        
        }
        .padding()
        .background(Color.red.opacity(0.8))
        .foregroundColor(Color.white)
        .cornerRadius(10)
    }

    func onToastComplete() -> Void {
	print("The toast did disappear")
    }
}
```


## Options

The toast can be configured via an optional SimpleToastOptions object. If nil is given the default values are taken. 

The struct has the following signature:

```swift
public struct SimpleToastOptions {
    var alignment: Alignment = .top
    var delay: TimeInterval? = nil
    var backdrop: Bool? = true
}
```

**alignment:** Defines the alignment of the toast. See [https://developer.apple.com/documentation/swiftui/alignment](https://developer.apple.com/documentation/swiftui/alignment) for more information.

**delay:** Optional parameter to define when the toast disappears. If nil is given the toast won't disappear.

**backdrop:** Optional parameter to define if the toast is rendered over a backdrop. 

