# HyBid - iOS MoPub Adapter (Header Bidding & Mediation)
> Header Bidding & Mediation adapters to be used in conjunction with MoPub iOS SDK to deliver HyBid Ads on iOS devices.

If you want to display HyBid Ads in your iOS application through MoPub, you’re at the right place.

## Requirements

- ![Platform: iOS 9.0+](https://img.shields.io/badge/Platform-iOS%209.0%2B-blue.svg?style=flat)
- ![Xcode: 12.0+](https://img.shields.io/badge/Xcode-12.0+-blue.svg?style=flat)

## Features

- [x] Displaying HyBid Ads

## Installation

#### CocoaPods

If your project is managing dependencies through [CocoaPods](https://cocoapods.org/), you just need to add this pod in your `Podfile`.

It will install HyBid Adapters, as well as HyBid iOS SDK and MoPub iOS SDK (If not installed already).

1. Add pod named `MoPub-HyBid-Adapters` in your Podfile:

```ruby
platform :ios, '10.0'
pod 'MoPub-HyBid-Adapters', '0.1.0'
```

2. Run `pod install --repo-update` to install the pod in your project.
3. Integrate latest version of HyBid iOS SDK to your project using [HyBid Setup Guide](https://github.com/pubnative/pubnative-hybid-ios-sdk/wiki/Setup-HyBid).
4. If needed, implement [MoPub iOS SDK](https://developers.mopub.com/docs/ios/) in your application.
5. Based on your needs, define custom events using [Header Bidding](https://github.com/pubnative/pubnative-hybid-ios-sdk/wiki/Setup-MoPub) and/or [Mediation](https://github.com/pubnative/pubnative-hybid-ios-sdk/wiki/MoPub-Mediation) pages to finish the integration.
6. You’re done.

#### Manually

1. Integrate latest version of HyBid iOS SDK to your project using [HyBid Setup Guide](https://github.com/pubnative/pubnative-hybid-ios-sdk/wiki/Setup-HyBid).
2. If needed, implement [MoPub iOS SDK](https://developers.mopub.com/docs/ios/) in your application.
3. Download the desired release of [MoPub HyBid Adapters](https://github.com/pubnative/mopub-hybid-adapters-ios/releases).
4. Drag & Drop adapter files in your iOS project.
5. Based on your needs, define custom events using [Header Bidding](https://github.com/pubnative/pubnative-hybid-ios-sdk/wiki/Setup-MoPub) and/or [Mediation](https://github.com/pubnative/pubnative-hybid-ios-sdk/wiki/MoPub-Mediation) pages to finish the integration.
6. You’re done.

## Integration Documentation

Integration instructions are available on [HyBid iOS SDK Documentation](https://github.com/pubnative/pubnative-hybid-ios-sdk/wiki) GitHub Wiki page.
