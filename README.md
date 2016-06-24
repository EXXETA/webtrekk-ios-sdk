About
=====

The Webtrekk SDK allows you to track user activities, screen flow and media usage for an App. All data is send to the Webtrekk tracking system for further analysis.

Requirements
============

| Plattform | supported Version  |
|-----------|-------------------:|
| `iOS`     |             `8.0+` |
| `tvOS`    | planned for `9.0+` |
| `watchOs` | planned for `2.0+` |

Xcode 7.3+

Installation
============

Using [CocoaPods](htttp://cocoapods.org) the installation of the Webtrekk SDK is simply done by adding it to the project `Podfile`

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'CryptoSwift'
```

or for the newest version

```ruby
  pod 'Webtrekk', :git => 'https://github.com/webtrekk/Webtrekk.git'
```

Usage - Basic
=============

```swift
import Webtrekk
```

The minimal required configuration parameters for a valid Webtrekk instance are the `serverUrl` and the `webtrekkId`. The below code snippet shows a common way to integrate and configure a Webtrekk instance.

```swift
extension WebtrekkTracking {

	static let sharedTracker: Tracker = {

    var configuration = TrackerConfiguration(
			webtrekkId: "289053685367929",
			serverUrl:  NSURL(string: "https://q3.webtrekk.net")!
		)

		return WebtrekkTracking.tracker(configuration: configuration)
	}()
}
```

Page View Tracking
------------------

To track page views from the different screens of an App it is common to do this when a screen appeared. The below code snippet demonstrates this by creating a `tracker` variable with the name under which this specific screen of the App should be tracked. When the `UITableViewController` calls `viewDidAppear` the Screen is definitely visible to the user and can safely be tracked by calling `trackPageView()` on the previously assigned variable.

```swift
class ProductListViewController: UITableViewController {

	private let tracker = WebtrekkTracking.sharedTracker.trackPage("Product Details")

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)

		tracker.trackPageView()
	}
}

```

Action Tracking
---------------

The user interaction on a screen can be tracked by done in two different ways either by using a previously assigned `tracker` variable of the screen or by utilizing the Webtrekk instance. The code snippet demonstrates the recommended way by using the `tracker` variable within an `IBAction` call from a button.

```swift
@IBAction func productTapped(sender: UIButton) {
  tracker.trackAction("Product tapped")
}
```

As an alternate to the previous code snippet there is always the possibility to use the Webtrekk instance. This is shown in the below code snippet.

```swift
@IBAction func productTapped(sender: UIButton) {
  WebtrekkTracking.sharedTracker.trackAction("Product tapped", inPage: "Product Details")
}
```

Media Tracking
--------------

The Webtrekk SDK offers a simple integration to track different states of you media playback. There are two approaches to make use of that. The first code snippet shows the recommended way by using the previously assigned `tracker`variable.

```swift
@IBAction func productTapped(sender: UIButton) {
  let player = AVPlayer(URL: videoUrl)
  tracker.trackMedia("product-video-productId", byAttachingToPlayer: player)
  playerViewController.player = player

  player.play()
}
```

The second code snippet shows the integration using the Webtrekk instace directly.

```swift
@IBAction func productTapped(sender: UIButton) {
  let player = AVPlayer(URL: videoUrl)
  WebtrekkTracking.sharedTracker.trackMedia("product-video-productId", pageName: "Product Details",  byAttachingToPlayer: player)
  playerViewController.player = player

  player.play()
}
```

SSL Notice
==========

As of iOS 9 Apple is more strictly forcing the usage of the SSL for network connections. Webtrekk highly recommend and offers the usage of a valid serverUrl with SSL support. In case there is a need to circumvent this the App needs an exception entry within the info.plis this and the regulation Apple bestows upon that are well documented within the [iOS Developer Library](https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW33)

\`\`\`
