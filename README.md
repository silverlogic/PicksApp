# BaseApp iOS V2 #

![BaseApp.png](https://bitbucket.org/repo/b8rny4/images/460357771-BaseApp.png)

[![Build Status](https://www.bitrise.io/app/3bcc27059d1191f9.svg?token=HNXmVRGxQUKeosWxMx6fmA&branch=master)](https://www.bitrise.io/app/3bcc27059d1191f9)
[![codecov](https://codecov.io/bb/silverlogic/baseapp-ios-v2/branch/master/graph/badge.svg?token=ViORN1O4IA)](https://codecov.io/bb/silverlogic/baseapp-ios-v2)

BaseApp iOS V2 is a template app that has all the necessary features needed for rapid app development. 

* [Features](https://bitbucket.org/silverlogic/baseapp-ios-v2/overview#markdown-header-features)
* [Requirements](https://bitbucket.org/silverlogic/baseapp-ios-v2/overview#markdown-header-requirements)
* [Communication](https://bitbucket.org/silverlogic/baseapp-ios-v2/overview#markdown-header-communication)
* [Installation](https://bitbucket.org/silverlogic/baseapp-ios-v2/overview#markdown-header-installation)
* [Authors](https://bitbucket.org/silverlogic/baseapp-ios-v2/overview#markdown-header-authors)

## Features ##

* Networking with [Raccoon](https://github.com/ManueGE/Raccoon)
* Auto mapping to Core Data with [Groot](https://github.com/gonzalezreal/Groot)
* Local storage with Core Data
* App logging with [SwiftyBeaver](https://github.com/SwiftyBeaver/SwiftyBeaver)
* OAuth1 Authentication support for Twitter
* OAuth2 Authentication support for Facebook and LinkedIn
* Email login
* Email signup
* Session management
* Handles switching between application flow and authentication flow
* Basic settings view that can be customized
* Basic profile view that can be customized
* Show progress indicators with [SVProgressHUD](https://github.com/SVProgressHUD/SVProgressHUD)
* Show navigation bar progress with [KYNavigationProgress](https://github.com/ykyouhei/KYNavigationProgress)
* Show alerts with [Dodo](https://github.com/marketplacer/Dodo) or [SCLAlertView](https://github.com/vikmeup/SCLAlertView-Swift)
* Keyboard management with [IQKeyboardManager](https://github.com/hackiftekhar/IQKeyboardManager)
* Dynamic binding of values for real time updates without the need for using `Notification` or KVO
* Unit tests for app logic used.
* MVVM (Model-View-View Model) Architecture for easy maintenance and scalability.

## Requirements ##

* iOS 9.0+
* Xcode 8.2+
* Cocoapods 1.2.0
* Swift 3.0+

## Communication ##

* If you have general questions, use [Slack](https://silverlogic.slack.com/messages/C4AE7FTPV)
* For immediate help, contact one of our [Authors](https://bitbucket.org/silverlogic/baseapp-ios-v2/overview#markdown-header-authors)

## Installation ##

### CocoaPods ###
[CocoaPods](https://cocoapods.org/) is a dependency manager for Cocoa projects. You can install it with the following command:
```
$ gem install cocoapods
```

### Setup ###
After installing Cocoapods, use the following command to clone the repo:
```
$ git clone git@bitbucket.org:silverlogic/baseapp-ios-v2.git
```
Then run the following command to install the dependencies used:
```
$ pod install
```
Then run the following command to open the project and start coding:
```
$ open BaseAppV2.xcworkspace
```

## Authors ##

* [Manny Guerrero](https://silverlogic.slack.com/team/eg)
* [David Hartmann](https://silverlogic.slack.com/messages/@dh)
* [Manuel García-Estañ](https://silverlogic.slack.com/messages/@mm)