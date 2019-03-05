//
//  DNSPageTitleView.swift
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

@objc public protocol DNSPageTitleViewDelegate: class {
    
    /// pageContentView的刷新代理
    @objc optional var reloader: DNSPageReloadable? { get }
    
    func titleView(_ titleView: DNSPageTitleView, currentIndex: Int)
}

/// 如果contentView中的view需要实现某些刷新的方法，请让对应的childViewController遵守这个协议
@objc public protocol DNSPageReloadable: class {
    
    /// 如果需要双击标题刷新或者作其他处理，请实现这个方法
    @objc optional func titleViewDidSelectedSameTitle()
    
    /// 如果pageContentView滚动到下一页停下来需要刷新或者作其他处理，请实现这个方法
    @objc optional func contentViewDidEndScroll()
}


open class DNSPageTitleView: UIView {
    
    public weak var delegate: DNSPageTitleViewDelegate?
    
    /// 点击标题时调用
    public var clickHandler: TitleClickHandler?
    
    public var currentIndex: Int
    
    private (set) public lazy var titleLabels: [UILabel] = [UILabel]()
    
    public var style: DNSPageStyle
    
    public var titles: [String]
    
    
    private lazy var normalRGB: ColorRGB = self.style.titleColor.getRGB()
    private lazy var selectRGB: ColorRGB = self.style.titleSelectedColor.getRGB()
    private lazy var deltaRGB: ColorRGB = {
        let deltaR = self.selectRGB.red - self.normalRGB.red
        let deltaG = self.selectRGB.green - self.normalRGB.green
        let deltaB = self.selectRGB.blue - self.normalRGB.blue
        return (deltaR, deltaG, deltaB)
    }()
    
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    
    private lazy var bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        bottomLine.layer.cornerRadius = self.style.bottomLineRadius
        return bottomLine
    }()
    
    private (set) public lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = self.style.coverViewBackgroundColor
        coverView.alpha = self.style.coverViewAlpha
        return coverView
    }()
    
    public init(frame: CGRect, style: DNSPageStyle, titles: [String], currentIndex: Int) {
        self.style = style
        self.titles = titles
        self.currentIndex = currentIndex
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.style = DNSPageStyle()
        self.titles = [String]()
        self.currentIndex = 0
        super.init(coder: aDecoder)
        
    }
    
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = self.bounds
        
        setupLabelsLayout()
        setupBottomLineLayout()
        setupCoverViewLayout()
    }



    /// 通过代码实现点了某个位置的titleView
    ///
    /// - Parameter index: 需要点击的titleView的下标
    public func selectedTitle(inIndex index: Int) {
        if index > titles.count || index < 0 {
            print("DNSPageTitleView -- selectedTitle: 数组越界了, index的值超出有效范围");
        }

        clickHandler?(self, index)

        if index == currentIndex {
            delegate?.reloader??.titleViewDidSelectedSameTitle?()
            return
        }

        let sourceLabel = titleLabels[currentIndex]
        let targetLabel = titleLabels[index]

        sourceLabel.textColor = style.titleColor
        targetLabel.textColor = style.titleSelectedColor

        currentIndex = index

        adjustLabelPosition(targetLabel)

        delegate?.titleView(self, currentIndex: currentIndex)


        if style.isTitleScaleEnabled {
            UIView.animate(withDuration: 0.25, animations: {
                sourceLabel.transform = CGAffineTransform.identity
                targetLabel.transform = CGAffineTransform(scaleX: self.style.titleMaximumScaleFactor, y: self.style.titleMaximumScaleFactor)
            })
        }

        if style.isShowBottomLine {
            UIView.animate(withDuration: 0.25, animations: {
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLine.frame.size.width = targetLabel.frame.width
            })
        }

        if style.isShowCoverView {
            let x = style.isTitleViewScrollEnabled ? (targetLabel.frame.origin.x - style.coverMargin) : targetLabel.frame.origin.x
            let width = style.isTitleViewScrollEnabled ? (targetLabel.frame.width + style.coverMargin * 2) : targetLabel.frame.width
            UIView.animate(withDuration: 0.25, animations: {
                self.coverView.frame.origin.x = x
                self.coverView.frame.size.width = width
            })
        }

        sourceLabel.backgroundColor = nil
        targetLabel.backgroundColor = style.titleViewSelectedColor
    }
    
}


// MARK: - 设置UI界面
extension DNSPageTitleView {
    public func setupUI() {
        addSubview(scrollView)
        
        scrollView.backgroundColor = style.titleViewBackgroundColor
        
        setupTitleLabels()
        setupBottomLine()
        setupCoverView()
    }
    
    private func setupTitleLabels() {
        for (i, title) in titles.enumerated() {
            let label = UILabel()
            
            label.tag = i
            label.text = title
            label.textColor = i == currentIndex ? style.titleSelectedColor : style.titleColor
            label.backgroundColor = i == currentIndex ? style.titleViewSelectedColor : nil;
            label.textAlignment = .center
            label.font = style.titleFont
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            label.addGestureRecognizer(tapGes)
            label.isUserInteractionEnabled = true
            
            scrollView.addSubview(label)
    
            titleLabels.append(label)
        }
    }
    
    private func setupBottomLine() {
        guard style.isShowBottomLine else { return }
        
        scrollView.addSubview(bottomLine)
    }
    
    
    private func setupCoverView() {
        
        guard style.isShowCoverView else { return }
        
        scrollView.insertSubview(coverView, at: 0)
        
        coverView.layer.cornerRadius = style.coverViewRadius
        coverView.layer.masksToBounds = true
    }
    
}


// MARK: - Layout
extension DNSPageTitleView {
    private func setupLabelsLayout() {
        
        var x: CGFloat = 0
        let y: CGFloat = 0
        var width: CGFloat = 0
        let height = frame.size.height
        
        let count = titleLabels.count
        for (i, titleLabel) in titleLabels.enumerated() {
            if style.isTitleViewScrollEnabled {
                width = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : titleLabel.font], context: nil).width
                x = i == 0 ? style.titleMargin * 0.5 : (titleLabels[i - 1].frame.maxX + style.titleMargin)
            } else {
                width = bounds.width / CGFloat(count)
                x = width * CGFloat(i)
            }
            
            titleLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        }
        
        if style.isTitleScaleEnabled {
            titleLabels.first?.transform = CGAffineTransform(scaleX: style.titleMaximumScaleFactor, y: style.titleMaximumScaleFactor)
        }
        
        if style.isTitleViewScrollEnabled {
            guard let titleLabel = titleLabels.last else { return }
            scrollView.contentSize.width = titleLabel.frame.maxX + style.titleMargin * 0.5
        }
    }
    
    private func setupCoverViewLayout() {
        guard titleLabels.count - 1 >= currentIndex  else { return }
        let label = titleLabels[currentIndex]
        var width = label.bounds.width
        let height = style.coverViewHeight
        var x = label.frame.origin.x
        let y = (label.frame.height - height) * 0.5
        if style.isTitleViewScrollEnabled {
            x -= style.coverMargin
            width += 2 * style.coverMargin
        }
        coverView.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    private func setupBottomLineLayout() {
        guard titleLabels.count - 1 >= currentIndex else { return }
        let label = titleLabels[currentIndex]
        
        bottomLine.frame.origin.x = label.frame.origin.x
        bottomLine.frame.origin.y = self.bounds.height - self.style.bottomLineHeight
        bottomLine.frame.size.width = label.frame.width
        bottomLine.frame.size.height = self.style.bottomLineHeight
    }
}

// MARK: - 监听label的点击
extension DNSPageTitleView {
    @objc private func titleLabelClick(_ tapGes : UITapGestureRecognizer) {
        guard let targetIndex = tapGes.view?.tag else { return }
        selectedTitle(inIndex: targetIndex)

    }


    
    private func adjustLabelPosition(_ targetLabel : UILabel) {
        guard style.isTitleViewScrollEnabled else { return }
        
        var offsetX = targetLabel.center.x - bounds.width * 0.5
        
        if offsetX < 0 {
            offsetX = 0
        }
        if offsetX > scrollView.contentSize.width - scrollView.bounds.width {
            offsetX = scrollView.contentSize.width - scrollView.bounds.width
        }
        
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        
    }
}



extension DNSPageTitleView : DNSPageContentViewDelegate {
    public func contentView(_ contentView: DNSPageContentView, inIndex: Int) {
        
        let sourceLabel = titleLabels[currentIndex]
        let targetLabel = titleLabels[inIndex]

        sourceLabel.backgroundColor = nil
        targetLabel.backgroundColor = style.titleViewSelectedColor
        
        currentIndex = inIndex
                
        adjustLabelPosition(targetLabel)
        
        fixUI(targetLabel)
    }
    
    public func contentView(_ contentView: DNSPageContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        if sourceIndex > titleLabels.count - 1 || sourceIndex < 0 {
            return
        }
        if targetIndex > titleLabels.count - 1 || targetIndex < 0 {
            return
        }
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        sourceLabel.textColor = UIColor(r: selectRGB.red - progress * deltaRGB.red, g: selectRGB.green - progress * deltaRGB.green, b: selectRGB.blue - progress * deltaRGB.blue)
        targetLabel.textColor = UIColor(r: normalRGB.red + progress * deltaRGB.red, g: normalRGB.green + progress * deltaRGB.green, b: normalRGB.blue + progress * deltaRGB.blue)
        
        if style.isTitleScaleEnabled {
            let deltaScale = style.titleMaximumScaleFactor - 1.0
            sourceLabel.transform = CGAffineTransform(scaleX: style.titleMaximumScaleFactor - progress * deltaScale, y: style.titleMaximumScaleFactor - progress * deltaScale)
            targetLabel.transform = CGAffineTransform(scaleX: 1.0 + progress * deltaScale, y: 1.0 + progress * deltaScale)
        }
        
        if style.isShowBottomLine {
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            let deltaW = targetLabel.frame.width - sourceLabel.frame.width
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + progress * deltaX
            bottomLine.frame.size.width = sourceLabel.frame.width + progress * deltaW
        }
        
        if style.isShowCoverView {
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            let deltaW = targetLabel.frame.width - sourceLabel.frame.width
            coverView.frame.size.width = style.isTitleViewScrollEnabled ? (sourceLabel.frame.width + 2 * style.coverMargin + deltaW * progress) : (sourceLabel.frame.width + deltaW * progress)
            coverView.frame.origin.x = style.isTitleViewScrollEnabled ? (sourceLabel.frame.origin.x - style.coverMargin + deltaX * progress) : (sourceLabel.frame.origin.x + deltaX * progress)
        }
        
    }
    
    private func fixUI(_ targetLabel: UILabel) {
        UIView.animate(withDuration: 0.05) {
            targetLabel.textColor = self.style.titleSelectedColor
            
            if self.style.isTitleScaleEnabled {
                targetLabel.transform = CGAffineTransform(scaleX: self.style.titleMaximumScaleFactor, y: self.style.titleMaximumScaleFactor)
            }
            
            if self.style.isShowBottomLine {
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLine.frame.size.width = targetLabel.frame.width
            }
            
            if self.style.isShowCoverView {
                
                self.coverView.frame.size.width = self.style.isTitleViewScrollEnabled ? (targetLabel.frame.width + 2 * self.style.coverMargin) : targetLabel.frame.width
                self.coverView.frame.origin.x = self.style.isTitleViewScrollEnabled ? (targetLabel.frame.origin.x - self.style.coverMargin) : targetLabel.frame.origin.x
            }
        }
        
    }
    
}



