# JXMarqueeView  

[![languages](https://img.shields.io/badge/language-swift-FF69B4.svg?style=plastic)](https://developer.apple.com/swift) 
[![platform](https://img.shields.io/badge/platform-iOS-blue.svg?style=plastic)](#)
[![cocoapods](https://img.shields.io/badge/cocoapods-supported-4BC51D.svg?style=plastic)](https://cocoapods.org/pods/JXMarqueeView)

A powerful and easy to use marquee view.

[中文博客介绍](https://www.jianshu.com/p/835ba205453d)

# Features

- Automatically start marquee. (When the content beyond size, marquee start automatically.)
- Support UIView an its subclasses. (More than just UILabel, you can customize the view to turn on the marquee effect.)

# Preview

`JXMarqueeType.left`：From right to left

![left.gif](https://upload-images.jianshu.io/upload_images/1085173-712f04ce62c1a3bc.gif?imageMogr2/auto-orient/strip)

`JXMarqueeType.right`：From left to right

![right.gif](https://upload-images.jianshu.io/upload_images/1085173-5d21ffa924ec2afa.gif?imageMogr2/auto-orient/strip)

`JXMarqueeType.reverse`：reverse

![reverse.gif](https://upload-images.jianshu.io/upload_images/1085173-acffb41b6479bf1a.gif?imageMogr2/auto-orient/strip)

# Requirements

- XCode 9.0+ 
- Swift 4.0+

# Installation

1. Manually
    - Download source code, drag JXMarqueeView.swift file into your project.
2. Cocoapods
```ruby
use_frameworks!
target '<Your Target Name>' do
    pod 'JXMarqueeView'
end
```

# Usage

- **contentMargin**

The interval between two views,default is 12.

- **frameInterval**

Assiagned to CADisplayLink frameInterval property,default is 1.

- **pointsPerFrame**

How many points each time for callback of CADisplayLink.The bigger the faster.

- **contentView**

The view your need to marquee.

- **SizeToFit**

When you customize complex content view, you need override `func sizeThatFits(_ size: CGSize) -> CGSize`,and return you correct content size.

## Use case 
```swift
//text
let label = UILabel()
label.textColor = UIColor.red
label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
label.text = "abcdefghijklmnopqrstuvwxyz"

marqueeView.contentView = label
marqueeView.contentMargin = 50
marqueeView.marqueeType = .left
self.view.addSubview(marqueeView)

//picture
let imageView = UIImageView(image: UIImage(named: "haizeiwang.jpeg"))
imageView.contentMode = .scaleAspectFill

marqueeView.contentView = imageView
marqueeView.marqueeType = .reverse
self.view.addSubview(marqueeView)
```

## Customize

The default implementation of contentView's copy using code:
```
let archivedData = NSKeyedArchiver.archivedData(withRootObject: self)
let copyView = NSKeyedUnarchiver.unarchiveObject(with: archivedData) as! UIView
```
But if the view has cornerRadius、shadow, the copyView will lose it. So you should implement `protocol JXMarqueeViewCopyable` function `func copyMarqueeView() -> UIView`. Just return a new instance UIView.
Just checkout `CustomCopyView.swift` in example.

### Picture case preview
![picture.gif](https://github.com/pujiaxin33/JXMarqueeView/blob/master/JXMarqueeView/Assets/picture.gif?raw=true)

### Custom case preview
![poetry.gif](https://upload-images.jianshu.io/upload_images/1085173-c197188ee4e4fb44.gif?imageMogr2/auto-orient/strip)
