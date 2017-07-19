# WKNavigationWebController

[![CI Status](http://img.shields.io/travis/DiegoQuimbo/WKNavigationWebController.svg?style=flat)](https://travis-ci.org/DiegoQuimbo/WKNavigationWebController)
[![Version](https://img.shields.io/cocoapods/v/WKNavigationWebController.svg?style=flat)](http://cocoapods.org/pods/WKNavigationWebController)
[![License](https://img.shields.io/cocoapods/l/WKNavigationWebController.svg?style=flat)](http://cocoapods.org/pods/WKNavigationWebController)
[![Platform](https://img.shields.io/cocoapods/p/WKNavigationWebController.svg?style=flat)](http://cocoapods.org/pods/WKNavigationWebController)

## Example

To push a WKWebView onto your UINavigationController, do:

```swift
import WKNavigationWebController

let url = URL(string: "https://github.com/")
let navigationWebController = NavigationWebViewController(url: url!)

self.navigationController?.pushViewController(navigationWebController, animated: true)
```

Remember config "App Transport Security Settings" in your Info.plist

## Requirements

WebKit, UIKit

## Installation

WKNavigationWebController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'WKNavigationWebController'
```

## Author

DiegoQuimbo, dquimbo22@gmail.com

## License

WKNavigationWebController is available under the MIT license. See the LICENSE file for more info.
