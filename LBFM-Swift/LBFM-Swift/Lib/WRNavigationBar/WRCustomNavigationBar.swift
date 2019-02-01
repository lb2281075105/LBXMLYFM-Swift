//
//  WRCustomNavigationBar.swift
//  WRNavigationBar_swift
//
//  Created by itwangrui on 2017/11/25.
//  Copyright © 2017年 wangrui. All rights reserved.
//

import UIKit

fileprivate let WRDefaultTitleSize:CGFloat = 18
fileprivate let WRDefaultTitleColor = UIColor.black
fileprivate let WRDefaultBackgroundColor = UIColor.white
fileprivate let WRScreenWidth = UIScreen.main.bounds.size.width


// MARK: - Router
extension UIViewController
{
    //  A页面 弹出 登录页面B
    //  presentedViewController:    A页面
    //  presentingViewController:   B页面
    
    func wr_toLastViewController(animated:Bool)
    {
        if self.navigationController != nil
        {
            if self.navigationController?.viewControllers.count == 1
            {
                self.dismiss(animated: animated, completion: nil)
            } else {
                self.navigationController?.popViewController(animated: animated)
            }
        }
        else if self.presentingViewController != nil {
            self.dismiss(animated: animated, completion: nil)
        }
    }
    
    class func wr_currentViewController() -> UIViewController
    {
        if let rootVC = UIApplication.shared.delegate?.window??.rootViewController {
            return self.wr_currentViewController(from: rootVC)
        } else {
            return UIViewController()
        }
    }

    class func wr_currentViewController(from fromVC:UIViewController) -> UIViewController
    {
        if fromVC.isKind(of: UINavigationController.self) {
            let navigationController = fromVC as! UINavigationController
            return wr_currentViewController(from: navigationController.viewControllers.last!)
        }
        else if fromVC.isKind(of: UITabBarController.self) {
            let tabBarController = fromVC as! UITabBarController
            return wr_currentViewController(from: tabBarController.selectedViewController!)
        }
        else if fromVC.presentedViewController != nil {
            return wr_currentViewController(from:fromVC.presentingViewController!)
        }
        else {
            return fromVC
        }
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////
class WRCustomNavigationBar: UIView
{
    var onClickLeftButton:(()->())?
    var onClickRightButton:(()->())?
    var title:String? {
        willSet {
            titleLabel.isHidden = false
            titleLabel.text = newValue
        }
    }
    var titleLabelColor:UIColor? {
        willSet {
            titleLabel.textColor = newValue
        }
    }
    var titleLabelFont:UIFont? {
        willSet {
            titleLabel.font = newValue
        }
    }
    var barBackgroundColor:UIColor? {
        willSet {
            backgroundImageView.isHidden = true
            backgroundView.isHidden = false
            backgroundView.backgroundColor = newValue
        }
    }
    var barBackgroundImage:UIImage? {
        willSet {
            backgroundView.isHidden = true
            backgroundImageView.isHidden = false
            backgroundImageView.image = newValue
        }
    }
    
    // fileprivate UI variable
    fileprivate lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = WRDefaultTitleColor
        label.font = UIFont.systemFont(ofSize: WRDefaultTitleSize)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    fileprivate lazy var leftButton:UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .center
        button.isHidden = true
        button.addTarget(self, action: #selector(clickBack), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var rightButton:UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .center
        button.isHidden = true
        button.addTarget(self, action: #selector(clickRight), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var bottomLine:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: (218.0/255.0), green: (218.0/255.0), blue: (218.0/255.0), alpha: 1.0)
        return view
    }()
    
    fileprivate lazy var backgroundView:UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate lazy var backgroundImageView:UIImageView = {
        let imgView = UIImageView()
        imgView.isHidden = true
        return imgView
    }()
    
    // fileprivate other variable
    fileprivate static var isIphoneX:Bool {
        get {
            return UIScreen.main.bounds.equalTo(CGRect(x: 0, y: 0, width: 375, height: 812))
        }
    }
    fileprivate static var navBarBottom:Int {
        get {
            return isIphoneX ? 88 : 64
        }
    }
    
    // init
    class func CustomNavigationBar() -> WRCustomNavigationBar {
        let frame = CGRect(x: 0, y: 0, width: WRScreenWidth, height: CGFloat(navBarBottom))
        return WRCustomNavigationBar(frame: frame)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView()
    {
        addSubview(backgroundView)
        addSubview(backgroundImageView)
        addSubview(leftButton)
        addSubview(titleLabel)
        addSubview(rightButton)
        addSubview(bottomLine)
        updateFrame()
        backgroundColor = UIColor.clear
        backgroundView.backgroundColor = WRDefaultBackgroundColor
    }
    func updateFrame()
    {
        let top:CGFloat = WRCustomNavigationBar.isIphoneX ? 44 : 20
        let margin:CGFloat = 0
        let buttonHeight:CGFloat = 44
        let buttonWidth:CGFloat = 44
        let titleLabelHeight:CGFloat = 44
        let titleLabelWidth:CGFloat = 180
        
        backgroundView.frame = self.bounds
        backgroundImageView.frame = self.bounds
        leftButton.frame = CGRect(x: margin, y: top, width: buttonWidth, height: buttonHeight)
        rightButton.frame = CGRect(x: WRScreenWidth-buttonWidth-margin, y: top, width: buttonWidth, height: buttonHeight)
        titleLabel.frame = CGRect(x: (WRScreenWidth-titleLabelWidth)/2.0, y: top, width: titleLabelWidth, height: titleLabelHeight)
        bottomLine.frame = CGRect(x: 0, y: bounds.height-0.5, width: WRScreenWidth, height: 0.5)
    }
}


extension WRCustomNavigationBar
{
    func wr_setBottomLineHidden(hidden:Bool) {
        bottomLine.isHidden = hidden
    }
    func wr_setBackgroundAlpha(alpha:CGFloat) {
        backgroundView.alpha = alpha
        backgroundImageView.alpha = alpha
        bottomLine.alpha = alpha
    }
    func wr_setTintColor(color:UIColor) {
        leftButton.setTitleColor(color, for: .normal)
        rightButton.setTitleColor(color, for: .normal)
        titleLabel.textColor = color
    }
    
    // 左右按钮共有方法
    func wr_setLeftButton(normal:UIImage, highlighted:UIImage) {
        wr_setLeftButton(normal: normal, highlighted: highlighted, title: nil, titleColor: nil)
    }
    func wr_setLeftButton(image:UIImage) {
        wr_setLeftButton(normal: image, highlighted: image, title: nil, titleColor: nil)
    }
    func wr_setLeftButton(title:String, titleColor:UIColor) {
        wr_setLeftButton(normal: nil, highlighted: nil, title: title, titleColor: titleColor)
    }
    
    func wr_setRightButton(normal:UIImage, highlighted:UIImage) {
        wr_setRightButton(normal: normal, highlighted: highlighted, title: nil, titleColor: nil)
    }
    func wr_setRightButton(image:UIImage) {
        wr_setRightButton(normal: image, highlighted: image, title: nil, titleColor: nil)
    }
    func wr_setRightButton(title:String, titleColor:UIColor) {
        wr_setRightButton(normal: nil, highlighted: nil, title: title, titleColor: titleColor)
    }
    
    
    // 左右按钮私有方法
    private func wr_setLeftButton(normal:UIImage?, highlighted:UIImage?, title:String?, titleColor:UIColor?) {
        leftButton.isHidden = false
        leftButton.setImage(normal, for: .normal)
        leftButton.setImage(highlighted, for: .highlighted)
        leftButton.setTitle(title, for: .normal)
        leftButton.setTitleColor(titleColor, for: .normal)
    }
    private func wr_setRightButton(normal:UIImage?, highlighted:UIImage?, title:String?, titleColor:UIColor?) {
        rightButton.isHidden = false
        rightButton.setImage(normal, for: .normal)
        rightButton.setImage(highlighted, for: .highlighted)
        rightButton.setTitle(title, for: .normal)
        rightButton.setTitleColor(titleColor, for: .normal)
    }
}


// MARK: - 导航栏左右按钮事件
extension WRCustomNavigationBar
{
    @objc func clickBack() {
        if let onClickBack = onClickLeftButton {
            onClickBack()
        } else {
            let currentVC = UIViewController.wr_currentViewController()
            currentVC.wr_toLastViewController(animated: true)
        }
    }
    @objc func clickRight() {
        if let onClickRight = onClickRightButton {
            onClickRight()
        }
    }
}
























