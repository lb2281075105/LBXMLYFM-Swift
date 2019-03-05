//
//  DNSPageStyle.swift
//  DNSPageView
//
//  Created by Daniels on 2018/2/24.
//  Copyright © 2018年 Daniels. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

public class DNSPageStyle {
    
    /// titleView
    public var titleViewHeight: CGFloat = 44
    public var titleColor: UIColor = UIColor.black
    public var titleSelectedColor: UIColor = UIColor.blue
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 15)
    public var titleViewBackgroundColor: UIColor = UIColor.white
    public var titleMargin: CGFloat = 30
    public var titleViewSelectedColor: UIColor?

    
    /// titleView滑动
    public var isTitleViewScrollEnabled: Bool = false
    
    /// title下划线
    public var isShowBottomLine: Bool = false
    public var bottomLineColor: UIColor = UIColor.blue
    public var bottomLineHeight: CGFloat = 2
    public var bottomLineRadius: CGFloat = 1

    
    /// title缩放
    public var isTitleScaleEnabled: Bool = false
    public var titleMaximumScaleFactor: CGFloat = 1.2
    
    /// title遮罩
    public var isShowCoverView: Bool = false
    public var coverViewBackgroundColor: UIColor = UIColor.black
    public var coverViewAlpha: CGFloat = 0.4
    public var coverMargin: CGFloat = 8
    public var coverViewHeight: CGFloat = 25
    public var coverViewRadius: CGFloat = 12
    
    
    /// contentView
    public var isContentScrollEnabled : Bool = true
    public var contentViewBackgroundColor = UIColor.white
    
    
    public init() {
        
    }
}
