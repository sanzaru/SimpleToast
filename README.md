# SimpleToast for SwiftUI

SimpleToast is a simple, lightweight and easy to use library to show toasts / pop-ups inside your iOS application in SwiftUI. 

You decide the content, the library takes care about the rest.

## Features: 

* Custom toast content support: You can show whatever you want inside the toast.
* Timeout functionality: You decide if and when the toast should disappear.
* Callback functionality: Run code when the toast disappeared.

## Installation

### Swift Package Manager

```
dependencies: [
    .package(url: "https://github.com/sanzaru/SimpleToast.git", from: "0.0.1")
]
```


## Usage:


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

## Options

The toast can be configured via a SimpleToastOptions object. The struct has the following signature:

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


## Legal

SwiftUI, Apple and the Apple logo are trademarks of Apple Inc., registered in the U.S. and other countries.
App Store is a service mark of Apple Inc.
