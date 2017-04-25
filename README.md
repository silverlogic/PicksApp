# **PicksApp iOS** #

![BaseApp.png](https://bitbucket.org/repo/b8rny4/images/460357771-BaseApp.png)

[![Build Status](https://www.bitrise.io/app/a037eabb6e35a90f.svg?token=2aNO4w3qO3JDdJgD_WbhCA&branch=master)](https://www.bitrise.io/app/a037eabb6e35a90f)
[![codecov](https://codecov.io/bb/silverlogic/picks-ios/branch/master/graph/badge.svg?token=2VzkUcNZRw)](https://codecov.io/bb/silverlogic/picks-ios)

Picks iOS is a fork off of BaseApp iOS V2 that has all the necessary features needed for rapid app development.

* [Features](https://bitbucket.org/silverlogic/baseapp-ios-v2/overview#markdown-header-features)
* [Requirements](https://bitbucket.org/silverlogic/baseapp-ios-v2/overview#markdown-header-requirements)
* [Communication](https://bitbucket.org/silverlogic/baseapp-ios-v2/overview#markdown-header-communication)
* [Installation](https://bitbucket.org/silverlogic/baseapp-ios-v2/overview#markdown-header-installation)
* [Authors](https://bitbucket.org/silverlogic/baseapp-ios-v2/overview#markdown-header-authors)

## **Features** ##

* Networking with [Raccoon](https://github.com/ManueGE/Raccoon)
* Keychain support with [Keychain Access](https://github.com/kishikawakatsumi/KeychainAccess)
* Reachability status for checking network connectivity
* Auto mapping to Core Data with [Groot](https://github.com/gonzalezreal/Groot)
* Local storage with Core Data
* App logging with [SwiftyBeaver](https://github.com/SwiftyBeaver/SwiftyBeaver)
* OAuth1 Authentication support for Twitter
* OAuth2 Authentication support for Facebook and LinkedIn
* Deep Link support for forgot password, change email and confirm email using [BranchIO](https://github.com/BranchMetrics/ios-branch-deep-linking)
* Pagination
* Push Notification registration and management
* Email login
* Email signup
* Change password
* Session management
* Handles switching between application flow and authentication flow
* Basic user feed that can be customized
* Basic settings view that can be customized
* Basic profile view that can be customized
* Basic update profile view that can be customized
* Show basic tutorial flow to new users that can be customized with [Onboard](https://github.com/mamaral/Onboard)
* Show progress indicators with [SVProgressHUD](https://github.com/SVProgressHUD/SVProgressHUD)
* Show navigation bar progress with [KYNavigationProgress](https://github.com/ykyouhei/KYNavigationProgress)
* Show alerts with [Dodo](https://github.com/marketplacer/Dodo) or [SCLAlertView](https://github.com/vikmeup/SCLAlertView-Swift)
* Keyboard management with [IQKeyboardManager](https://github.com/hackiftekhar/IQKeyboardManager)
* Dynamic binding of values for real time updates without the need for using `Notification` or KVO
* Unit tests for app logic used
* Integration tests for testing view controllers using [KIF](https://github.com/kif-framework/KIF) (Still in progress...)
* MVVM (Model-View-View Model) Architecture for easy maintenance, scalability, and testing
* Auto deployment to [Fabric](https://fabric.io/) and iTunes Connect using [Fastlane](https://fastlane.tools/)

## **Requirements** ##

* iOS 9.0+
* Xcode 8.3+
* CocoaPods 1.2.1
* Swift 3.1+
* Ruby 2.3.1
* Fastlane 2.27+

## **Communication** ##

* If you have general questions, use [Slack](https://silverlogic.slack.com/messages/C4AE7FTPV)
* For immediate help, contact one of our [Authors](https://bitbucket.org/silverlogic/baseapp-ios-v2/overview#markdown-header-authors)

## **Installation** ##

### Ruby ###
Before installing Fastlane and CocoaPods, you will need the correct version of Ruby. For installing and managing different versions of Ruby on your local machine, we recommend using [Ruby Version Manager (RVM)](https://rvm.io/). Begin with the following command:
```
$ gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
```
Then run the following command to install RVM:
```
$ \curl -sSL https://get.rvm.io | bash -s stable
```
If the previous step is successful, run the following command to install Ruby 2.3.1:
```
$ rvm install ruby-2.3.1
```
Now run the following command to check that the correct version is being used:
```
$ ruby -v
```
The version reported should look like this:
```
ruby 2.3.1p112 (2016-04-26 revision 54768) [x86_64-darwin15]
```

### Fastlane ###
You will need Fastlane installed in order to test sending out builds locally and generating push certificates. You can install it with the following command:
```
$ gem install fastlane
```

### CocoaPods ###
[CocoaPods](https://cocoapods.org/) is a dependency manager for Cocoa projects. You can install it with the following command:
```
$ gem install cocoapods
```

### Setup ###
After installing CocoaPods, use the following command to clone the repo:
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

## **Authors** ##

* [Manny Guerrero](https://silverlogic.slack.com/team/eg)
* [David Hartmann](https://silverlogic.slack.com/messages/@dh)
* [Manuel García-Estañ](https://silverlogic.slack.com/messages/@mm)
