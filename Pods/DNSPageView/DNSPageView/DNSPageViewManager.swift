//
//  DNSPageViewManager.swift
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

/*
 通过这个类创建的pageView，titleView和contentView的frame是不确定的，适合于titleView和contentView分开布局的情况
 需要给titleView和contentView布局，可以用frame或者Autolayout布局
 */
open class DNSPageViewManager: NSObject {
        
    private (set) public var style: DNSPageStyle
    private (set) public var titles: [String]
    private (set) public var childViewControllers: [UIViewController]
    private (set) public var startIndex: Int
    private (set) public lazy var titleView = DNSPageTitleView(frame: .zero, style: style, titles: titles, currentIndex: startIndex)
    private (set) public lazy var contentView = DNSPageContentView(frame: .zero, style: style, childViewControllers: childViewControllers, startIndex: startIndex)

    public init(style: DNSPageStyle, titles: [String], childViewControllers: [UIViewController], startIndex: Int = 0) {
        self.style = style
        self.titles = titles
        self.childViewControllers = childViewControllers
        self.startIndex = startIndex
        super.init()
        
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension DNSPageViewManager {
    private func setupUI() {
        
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
}
