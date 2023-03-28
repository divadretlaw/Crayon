# Crayon

![Swift](https://img.shields.io/badge/Swift-5.4_5.5_5.6-orange?style=flat-square)
![Platforms](https://img.shields.io/badge/Platforms-macOS_iOS_tvOS_watchOS-informational?style=flat-square)

## Usage

In the example SwiftUI `Color` is used but it also works with `UIColor`, `NSColor` and `CGColor`.

### Init

```swift
let white = Color(hex: "#FFFFFF")
let red = Color(hex: "#FF0000")
let blue = Color(hex: "#0000FF")
let green = Color(hex: "#00FF00")
let yellow = Color(hex: "#FFFF00")
let black = Color(hex: "#000000")
```

### `isDark` & `isLight`

Check whether a color is dark or light

```swift
Color.white.isDark // false
Color.black.isDark // true
Color.white.isLight // true
Color.black.isLight // false
```

Calculate the contrast and check if there is good (≥ 7:1) contrast

```swift
Color.black.contrast(to: Color.white) // 21
Color.black.hasContrast(with: Color.white) // true
```

Convert the color via `lighten`, `darken`, `saturate`, `desaturate`, `inverted` and `negative`

```swift
Color.red.negative(withOpacity: false)
Color.red.inverted()

Color.red.saturated()
Color.red.desaturated()

Color.red.ligthened()
Color.red.darkened()
```

You can also do basic calculations with colors

```swift
Color(.red) + Color(.green) = Color(.yellow)
Color(.yellow) - Color(.red) = Color(.green)
```

## Install

### SwiftPM

```
https://github.com/divadretlaw/Crayon.git
```

## License

See [LICENSE](LICENSE)

Copyright © 2022 David Walter (www.davidwalter.at)
