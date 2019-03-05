//
//  DNSPageContentView.swift
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

public protocol DNSPageContentViewDelegate: class {
    func contentView(_ contentView: DNSPageContentView, inIndex: Int)
    func contentView(_ contentView: DNSPageContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat)
}


private let CellID = "CellID"
open class DNSPageContentView: UIView {
    
    public weak var delegate: DNSPageContentViewDelegate?
    
    public weak var reloader: DNSPageReloadable?
    
    public var style: DNSPageStyle
    
    public var childViewControllers : [UIViewController]
    
    /// 初始化后，默认显示的页数
    public var startIndex: Int
    
    private var startOffsetX: CGFloat = 0
    
    private var isForbidDelegate: Bool = false
    
    private (set) public lazy var collectionView: UICollectionView = {
        let layout = DNSPageCollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = false
        if #available(iOS 10, *) {
            collectionView.isPrefetchingEnabled = false
        }
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CellID)
        return collectionView
    }()
    
    
    public init(frame: CGRect, style: DNSPageStyle, childViewControllers: [UIViewController], startIndex: Int) {
        self.childViewControllers = childViewControllers
        self.style = style
        self.startIndex = startIndex
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.childViewControllers = [UIViewController]()
        self.style = DNSPageStyle()
        self.startIndex = 0
        super.init(coder: aDecoder)
        
    }
    

    override open func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
        let layout = collectionView.collectionViewLayout as! DNSPageCollectionViewFlowLayout
        layout.itemSize = bounds.size
        layout.offset = CGFloat(startIndex) * bounds.size.width
    }
}


extension DNSPageContentView {
    public func setupUI() {
        addSubview(collectionView)
        
        collectionView.backgroundColor = style.contentViewBackgroundColor
        collectionView.isScrollEnabled = style.isContentScrollEnabled

    }
}


extension DNSPageContentView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childViewControllers.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID, for: indexPath)
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        let childViewController = childViewControllers[indexPath.item]

        reloader = childViewController as? DNSPageReloadable
        childViewController.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childViewController.view)
        
        return cell
    }
}


extension DNSPageContentView: UICollectionViewDelegate {
    
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidDelegate = false
        startOffsetX = scrollView.contentOffset.x
        
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateUI(scrollView)
        
    }
    
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            collectionViewDidEndScroll(scrollView)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionViewDidEndScroll(scrollView)
    }
    
    
    private func collectionViewDidEndScroll(_ scrollView: UIScrollView) {
        let inIndex = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        
        let childViewController = childViewControllers[inIndex]
        
        reloader = childViewController as? DNSPageReloadable
        
        reloader?.contentViewDidEndScroll?()
        
        delegate?.contentView(self, inIndex: inIndex)
        
    }

    
    
    private func updateUI(_ scrollView: UIScrollView) {
        if isForbidDelegate {
            return
        }
        
        var progress: CGFloat = 0
        var targetIndex = 0
        var sourceIndex = 0
        
        
        progress = scrollView.contentOffset.x.truncatingRemainder(dividingBy: scrollView.bounds.width) / scrollView.bounds.width
        if progress == 0 {
            return
        }
        
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        
        if collectionView.contentOffset.x > startOffsetX { // 左滑动
            sourceIndex = index
            targetIndex = index + 1
            if targetIndex > childViewControllers.count - 1 {
                return
            }
        } else {
            sourceIndex = index + 1
            targetIndex = index
            progress = 1 - progress
            if targetIndex < 0 {
                return
            }
        }
        
        if progress > 0.998 {
            progress = 1
        }
        
        delegate?.contentView(self, sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
    }
}


extension DNSPageContentView: DNSPageTitleViewDelegate {
    public func titleView(_ titleView: DNSPageTitleView, currentIndex: Int) {
        isForbidDelegate = true
        
        if currentIndex > childViewControllers.count - 1 {
            return
        }
        let indexPath = IndexPath(item: currentIndex, section: 0)

        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}


