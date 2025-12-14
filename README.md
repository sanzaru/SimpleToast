# SimpleToast for SwiftUI

[![](https://travis-ci.com/sanzaru/SimpleToast.svg?branch=develop)](https://travis-ci.com/sanzaru/SimpleToast)
[![](https://tinyurl.com/3e9pprjv)](https://swiftpackageindex.com/sanzaru/SimpleToast)
[![](https://tinyurl.com/mtkte8as)](https://swiftpackageindex.com/sanzaru/SimpleToast)
[![Swift](https://github.com/sanzaru/SimpleToast/actions/workflows/swift.yml/badge.svg?branch=master)](https://github.com/sanzaru/SimpleToast/actions/workflows/swift.yml)

SimpleToast is a simple, lightweight, flexible and easy to use library to show toasts / popup notifications inside iOS or macOS applications in SwiftUI. Because of the flexibility to show any content it is also possible to use the library for showing simple modals.

You decide the content, the library takes care about the rest.

> [!IMPORTANT]
> The current version is still in development. There can and will be breaking changes in version updates until version 1.0.

## Features:

* Custom toast content support: You can show whatever you want inside the toast.
* Custom positioning: Place the toast where you want it to be.
* Timeout functionality: You decide if and when the toast should disappear.
* Callback functionality: Run code when the toast disappeared.
* Multiple, customizable animations

> [!CAUTION]
> 🚨 Breaking changes:
> * **0.12.0:**
>     * The options struct now includes a new option to modify the display mode. The default is `.inline`, which only reserves horizontal space instead of reserving both (vertical, horizontal) spaces. You should check your implementation after the update and might need to set the `displayMode` option to `.full` in your `SimpleToastOptions`.
> * **0.11.0:**
>     * ```.simpleToast(item:, options:)``` is now passing an identifiable to the closure. Closures without capturing raise an error.
>       See the [documentation](/Documentation/Usage.md) for more information.
> * **0.6.0:**
>     * The options struct is modified and the parameters `showBackdrop` and `backdropColor` are replaced by a single optional Color definition `backdrop`. See [Options](#options) for more information

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

### Cocoapods

> [!CAUTION]
> CocoaPods support will be dropped with version 1.0. Prior to that, support will be minimal. Using SPM is highly recommended.

Add the following line to your Podfile:

```
pod 'SwiftUI-SimpleToast', '~> 0.6.2'
```

and run

```
pod install
```

or

```
pod update
```

## Usage

📚  For more information on how to use SimpleToast, see the [documentation on usage](/Documentation/Usage.md).

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
| **modifierType** | [ModifierType](#Demo) | Defines the type of toast animation. Possible values: .slide, .fade | .fade |
| **dismissOnTap** | [Bool?](https://developer.apple.com/documentation/swift/bool) | Defines if the toast closes on tap. Possible values: true, false | true |
| **disableDragGesture** | [Bool](https://developer.apple.com/documentation/swift/bool) | Defines if the toast reacts to drag gestures. Possible values: true, false | false |
| **displayMode** | SimpleToastDisplayMode | Defines the toast's content display mode. `.full` reserves the maximum horizontal and vertical space while `.inline` only reserves horizontal space. Possible values: .inline, .fill | .fill |
