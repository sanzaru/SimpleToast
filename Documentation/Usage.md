# SimpleToast Usage

There are different ways to attach a toast notification to your views. The usage is similar to well-known SwiftUI view modifiers (e.g., alert or sheet). If you are familiar with these, using SimpleToast will be very straightforward.

> [!NOTE]
> The toast always appears at the edges of the view it is attached to. Ensure the view has enough space to render the toast properly. Preferably, the toast should be attached to the outermost view or the navigation view, if available.
> Sheets need their own notification handler as they overlap all content.

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
    .simpleToast(isPresented: $showToast, options: toastOptions) {
        Label("This is some simple toast message.", systemImage: "exclamationmark.triangle")
        .padding()
        .background(Color.red.opacity(0.8))
        .foregroundColor(Color.white)
        .cornerRadius(10)
        .padding(.top)
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

> [!TIP]
> This functionality is similar to the one of the SwiftUI [sheet(item:onDismiss:content:)](https://developer.apple.com/documentation/swiftui/view/sheet(item:ondismiss:content:))

### Run code after dismissal

To run custom code after the toast disappeared you just have to pass a function to the `onDismiss` parameter:
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

### Usage with edgesIgnoringSafeArea(_:edges:) / ignoresSafeArea(_:edges:)

If the view you're attaching the toast to is ignoring a safe area, make sure to apply the SimpleToast modifier **after** the modifier for ignoring the safe area:

```swift
VStack {
    Text("Some view")
}
.ignoresSafeArea(.all)
.simpleToast(
    ...
```