# DNSPageView

[![Version](https://img.shields.io/cocoapods/v/DNSPageView.svg?style=flat)](http://cocoapods.org/pods/DNSPageView)
[![License](https://img.shields.io/cocoapods/l/DNSPageView.svg?style=flat)](http://cocoapods.org/pods/DNSPageView)
[![Platform](https://img.shields.io/cocoapods/p/DNSPageView.svg?style=flat)](http://cocoapods.org/pods/DNSPageView)

DNSPageView一个纯Swift的轻量级、灵活且易于使用的pageView框架，titleView和contentView可以布局在任意地方，可以纯代码初始化，也可以使用xib或者storyboard初始化，并且提供了常见样式属性进行设置。

如果你使用的开发语言是Objective-C，请使用[DNSPageView-ObjC](https://github.com/Danie1s/DNSPageView-ObjC)

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Example](#example)
- [Usage](#usage)
  - [直接使用DNSPageView初始化](#直接使用dnspageview初始化)
  - [使用xib或者storyboard初始化](#使用xib或者storyboard初始化)
  - [使用DNSPageViewManager初始化，再分别对titleView和contentView进行布局](#使用dnspageviewmanager初始化，再分别对titleview和contentview进行布局)
  - [样式](#样式)
  - [事件监听](#事件监听)
- [License](#license)

## Features:

- [x] 使用简单
- [x] 多种初始化方式
- [x] 灵活布局
- [x] 常见的样式
- [x] 双击titleView的回调
- [x] contentView滑动监听

## Requirements

- iOS 8.0+

- Xcode 9.0+

- Swift 4.0+


## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1+ is required to build DNSPageView.

To integrate DNSPageView into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'DNSPageView'
end
```

Then, run the following command:

```bash
$ pod install
```


### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate DNSPageView into your project manually.



## Example

To run the example project, clone the repo, and run `DNSPageView.xcodeproj` .

<img src="https://github.com/Danie1s/DNSPageView/blob/master/Images/1.gif" width="30%" height="30%">

<img src="https://github.com/Danie1s/DNSPageView/blob/master/Images/2.gif" width="30%" height="30%">

<img src="https://github.com/Danie1s/DNSPageView/blob/master/Images/3.gif" width="30%" height="30%">

<img src="https://github.com/Danie1s/DNSPageView/blob/master/Images/4.gif" width="30%" height="30%">





## Usage

### 直接使用DNSPageView初始化

```swift
// 创建DNSPageStyle，设置样式
let style = DNSPageStyle()
style.isTitleScrollEnable = true
style.isScaleEnable = true

// 设置标题内容
let titles = ["头条", "视频", "娱乐", "要问", "体育" , "科技" , "汽车" , "时尚" , "图片" , "游戏" , "房产"]

// 创建每一页对应的controller
let childViewControllers: [ContentViewController] = titles.map { _ -> ContentViewController in
    let controller = ContentViewController()
    controller.view.backgroundColor = UIColor.randomColor
    return controller
}

let size = UIScreen.main.bounds.size

// 创建对应的DNSPageView，并设置它的frame
// titleView和contentView会连在一起
let pageView = DNSPageView(frame: CGRect(x: 0, y: 64, width: size.width, height: size.height), style: style, titles: titles, childViewControllers: childViewControllers)
view.addSubview(pageView)
```



### 使用xib或者storyboard初始化

 在xib或者storyboard中拖出2个UIView，让它们分别继承DNSPageTitleView和DNSPageContentView，拖线到代码中

```swift
@IBOutlet weak var titleView: DNSPageTitleView!

@IBOutlet weak var contentView: DNSPageContentView!
```

对DNSPageTitleView和DNSPageContentView进行设置

```swift
// 创建DNSPageStyle，设置样式
let style = DNSPageStyle()
style.titleViewBackgroundColor = UIColor.red
style.isShowCoverView = true

// 设置标题内容
let titles = ["头条", "视频", "娱乐", "要问", "体育"]

// 设置默认的起始位置
let startIndex = 2

// 对titleView进行设置
titleView.titles = titles
titleView.style = style
titleView.currentIndex = startIndex

// 最后要调用setupUI方法
titleView.setupUI()


// 创建每一页对应的controller
let childViewControllers: [ContentViewController] = titles.map { _ -> ContentViewController in
    let controller = ContentViewController()
    controller.view.backgroundColor = UIColor.randomColor
    return controller
}

// 对contentView进行设置
contentView.childViewControllers = childViewControllers
contentView.startIndex = startIndex
contentView.style = style

// 最后要调用setupUI方法
contentView.setupUI()

// 让titleView和contentView进行联系起来
titleView.delegate = contentView
contentView.delegate = titleView
```



### 使用DNSPageViewManager初始化，再分别对titleView和contentView进行布局

创建DNSPageViewManager

```swift
private lazy var pageViewManager: DNSPageViewManager = {
    // 创建DNSPageStyle，设置样式
    let style = DNSPageStyle()
    style.isShowBottomLine = true
    style.isTitleScrollEnable = true
    style.titleViewBackgroundColor = UIColor.clear

    // 设置标题内容
    let titles = ["头条", "视频", "娱乐", "要问", "体育"]

    // 创建每一页对应的controller
    let childViewControllers: [ContentViewController] = titles.map { _ -> ContentViewController in
        let controller = ContentViewController()
        controller.view.backgroundColor = UIColor.randomColor
        return controller
    }

    return DNSPageViewManager(style: style, titles: titles, childViewControllers: childViewControllers)
}()
```

布局titleView和contentView

```swift
// 单独设置titleView的frame
navigationItem.titleView = pageViewManager.titleView
pageViewManager.titleView.frame = CGRect(x: 0, y: 0, width: 180, height: 44)

// 单独设置contentView的大小和位置，可以使用autolayout或者frame
let contentView = pageViewManager.contentView
view.addSubview(pageViewManager.contentView)
contentView.snp.makeConstraints { (maker) in
    maker.edges.equalToSuperview()
}
```



### 样式

DNSPageStyle中提供了常见样式的属性，可以按照不同的需求进行设置，包括可以设置初始显示的页面



### 事件监听

DNSPageView提供了常见事件监听的代理，它属于DNSPageTitleViewDelegate的中的可选属性

```swift
/// 如果contentView中的view需要实现某些刷新的方法，请让对应的childViewController遵守这个协议
@objc public protocol DNSPageReloadable: class {
    
    /// 如果需要双击标题刷新或者作其他处理，请实现这个方法
    @objc optional func titleViewDidSelectedSameTitle()
    
    /// 如果pageContentView滚动到下一页停下来需要刷新或者作其他处理，请实现这个方法
    @objc optional func contentViewDidEndScroll()
}
```



## License

DNSPageView is available under the MIT license. See the LICENSE file for more info.


