//
//  WRCycleCell.swift
//  WRCycleScrollViewDemo
//
//  Created by wangrui on 2017/5/12.
//  Copyright © 2017年 wangrui. All rights reserved.
//
//  Github地址：https://github.com/wangrui460/WRCycleScrollView

import UIKit
import Kingfisher
 
class WRCycleCell: UICollectionViewCell
{
//=======================================================
// MARK: 对外提供的属性
//=======================================================
    var imgSource:ImgSource = ImgSource.LOCAL(name: "placeholder")  {
        didSet {
            switch imgSource {
            case let .SERVER(url):
                imgView.kf.setImage(with: url)
            case let .LOCAL(name):
                imgView.image = UIImage(named: name)
            }
        }
    }
    
    var descText:String? {
        didSet {
            descLabel.isHidden  = (descText == nil) ? true : false
            bottomView.isHidden = (descText == nil) ? true : false
            descLabel.text = descText
        }
    }
    
    override var frame: CGRect {
        didSet {
            bounds.size = frame.size
        }
    }
    
    var descLabelFont: UIFont = UIFont(name: "Helvetica-Bold", size: 18)! {
        didSet {
            descLabel.font = descLabelFont
        }
    }
    var descLabelTextColor: UIColor = UIColor.white {
        didSet {
            descLabel.textColor = descLabelTextColor
        }
    }
    var descLabelHeight: CGFloat = 60 {
        didSet {
            descLabel.frame.size.height = descLabelHeight
        }
    }
    var descLabelTextAlignment:NSTextAlignment = .left {
        didSet {
            descLabel.textAlignment = descLabelTextAlignment
        }
    }
    var bottomViewBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.5) {
        didSet {
            bottomView.backgroundColor = bottomViewBackgroundColor
        }
    }
 
//=======================================================
// MARK: 内部属性
//=======================================================
    fileprivate var imgView:UIImageView!
    fileprivate var descLabel:UILabel!
    fileprivate var bottomView:UIView!
    
//=======================================================
// MARK: 构造方法
//=======================================================
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        setupImgView()
        setupDescLabel()
        setupBottomView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("WRCycleCell  deinit")
    }
    
    
//=======================================================
// MARK: 内部方法（layoutSubviews）
//=======================================================
    override func layoutSubviews()
    {
        super.layoutSubviews()
        imgView.frame = self.bounds
        
        if let _ = descText
        {
            let margin:CGFloat = 16
            let labelWidth     = imgView.bounds.width - 2 * margin
            let labelHeight    = descLabelHeight
            let labelY         = bounds.height - labelHeight
            descLabel.frame    = CGRect(x: margin, y: labelY, width: labelWidth, height: labelHeight)
            bottomView.frame   = CGRect(x: 0, y: labelY, width: imgView.bounds.width, height: labelHeight)
            bringSubviewToFront(descLabel)
        }
    }
}

//=======================================================
// MARK: - 基本控件（图片、描述文字、底部view）
//=======================================================
extension WRCycleCell
{
    fileprivate func setupImgView()
    {
        imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        addSubview(imgView)
    }
    
    fileprivate func setupDescLabel()
    {
        descLabel = UILabel()
        descLabel.text = descText
        descLabel.numberOfLines = 0
        descLabel.font = descLabelFont
        descLabel.textColor = descLabelTextColor
        descLabel.frame.size.height = descLabelHeight
        descLabel.textAlignment = descLabelTextAlignment
        addSubview(descLabel)
        descLabel.isHidden = true
    }
    
    fileprivate func setupBottomView()
    {
        bottomView = UIView()
        bottomView.backgroundColor = bottomViewBackgroundColor
        addSubview(bottomView)
        bottomView.isHidden = true
    }
}

