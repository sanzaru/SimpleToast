# SimpleToast Usage

There are various ways to attach a toast notification to your views. The basic usage is similar to popular SwiftUI view
modifiers, such as alert or sheet. If you’re familiar with those, using SimpleToast will be straightforward.

> [!NOTE]
> The toast always appears at the edges of the view it is attached to. Ensure the view has enough space to render the
> toast properly. Preferably, the toast should be attached to the outermost view or the navigation view, if available.
>
> ⚠️ Sheets need their own notification handler as they overlap all content.

**In this article**
- [SimpleToast Usage](#simpletoast-usage)
  - [Attach via boolean](#attach-via-boolean)
  - [Attach via optional object](#attach-via-optional-object)
  - [Run code after dismissal](#run-code-after-dismissal)
  - [Using the SimpleToastNotificationPublisher](#using-the-simpletoastnotificationpublisher)
  - [Usage with `edgesIgnoringSafeArea(_:edges:)` / `ignoresSafeArea(_:edges:)`](#usage-with-edgesignoringsafearea_edges--ignoressafearea_edges)


## Attach via boolean
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
> [!TIP]
> This functionality is similar to the one of the SwiftUI [sheet(isPresented:onDismiss:content:)](https://developer.apple.com/documentation/swiftui/view/sheet(ispresented:ondismiss:content:))

## Attach via optional object

You can trigger the toast via an instance to an optional object, which conforms to the protocol Identifiable. If the
value is not nil the toast will be shown.

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

## Run code after dismissal

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

## Using the SimpleToastNotificationPublisher

The `SimpleToastNotificationPublisher` provides a convenient way to trigger toast notifications throughout your app.
A typical example would be using the `NavigationSplitView`, where you can trigger notifications inside the sidebar view
and display them in the details view.

To use the `SimpleToastNotificationPublisher` for your toast notifications, you first need to create a data structure
that conforms to the `Identifiable` protocol.

Here’s a simple example of a toast notification with a text element:

```swift
import Foundation

struct ToastNotification: Identifiable {
    let id = UUID()
    let text: String
}
```
The following example demonstrates a simple example view for showing the notification. This view is not responsible for
triggering the notification. This is done by the view below this example.

```swift
import SwiftUI
import SimpleToast

struct ToastTestView: View {
    @State private var notification: ToastNotification?

    VStack(spacing: 20) {
        Text("Some view content")
    }
    .onToastNotification {
        notification = $0
    }
    .simpleToast(item: $notification, options: optionsSkew) {
        HStack {
            Image(systemName: "exclamationmark.triangle")
            Text(notification?.message ?? "Default message")
        }
        .padding()
        .background(Color.red.opacity(0.8))
        .foregroundColor(Color.white)
        .cornerRadius(10)
    }
}
```

The following demonstrates a simple view triggering the toast notification.

```swift
import SwiftUI
import SimpleToast

struct ExampleSecondView: View {
    var body: some View {
        VStack {
            Text("External Second View")

            TestButton("Trigger Toast (Publisher)", identifier: "ButtonPublisher") {
                withAnimation {
                    SimpleToastNotificationPublisher.publish(
                        notification: ToastNotification(text: "Toast from publisher")
                    )
                }
            }
        }
        .padding()
        .background(Color.orange.opacity(0.3))
    }
}
```

> [!IMPORTANT]
> Ensure that the view displaying the toast notification is visible. If you use sheets or other full-screen content,
> you'll need to handle the notification separately within them, as they will overlay all other views.

## Usage with `edgesIgnoringSafeArea(_:edges:)` / `ignoresSafeArea(_:edges:)`

If the view you're attaching the toast to is ignoring a safe area, make sure to apply the SimpleToast modifier **after**
the modifier for ignoring the safe area:

```swift
VStack {
    Text("Some view")
}
.ignoresSafeArea(.all)
.simpleToast(
    ...
```