//
//  WRNavigationBar.swift
//  WRNavigationBar_swift
//
//  Created by wangrui on 2017/4/19.
//  Copyright © 2017年 wangrui. All rights reserved.
//
//  Github地址：https://github.com/wangrui460/WRNavigationBar_swift

import UIKit

extension UINavigationBar:WRAwakeProtocol
{
    fileprivate struct AssociatedKeys {
        static var backgroundView: UIView = UIView()
        static var backgroundImageView: UIImageView = UIImageView()
    }
    
    fileprivate var backgroundView:UIView? {
        get {
            guard let bgView = objc_getAssociatedObject(self, &AssociatedKeys.backgroundView) as? UIView else {
                return nil
            }
            return bgView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.backgroundView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var backgroundImageView:UIImageView? {
        get {
            guard let bgImageView = objc_getAssociatedObject(self, &AssociatedKeys.backgroundImageView) as? UIImageView else {
                return nil
            }
            return bgImageView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.backgroundImageView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // set navigationBar backgroundImage
    fileprivate func wr_setBackgroundImage(image:UIImage)
    {
        backgroundView?.removeFromSuperview()
        backgroundView = nil
        if (backgroundImageView == nil)
        {
            // add a image(nil color) to _UIBarBackground make it clear
            setBackgroundImage(UIImage(), for: .default)
            backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: Int(bounds.width), height: WRNavigationBar.navBarBottom()))
            backgroundImageView?.autoresizingMask = .flexibleWidth
            // _UIBarBackground is first subView for navigationBar
            subviews.first?.insertSubview(backgroundImageView ?? UIImageView(), at: 0)
        }
        backgroundImageView?.image = image
    }
    
    // set navigationBar barTintColor
    fileprivate func wr_setBackgroundColor(color:UIColor)
    {
        backgroundImageView?.removeFromSuperview()
        backgroundImageView = nil
        if (backgroundView == nil)
        {
            // add a image(nil color) to _UIBarBackground make it clear
            setBackgroundImage(UIImage(), for: .default)
            backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: Int(bounds.width), height: WRNavigationBar.navBarBottom()))
            backgroundView?.autoresizingMask = .flexibleWidth
            // _UIBarBackground is first subView for navigationBar
            subviews.first?.insertSubview(backgroundView ?? UIView(), at: 0)
        }
        backgroundView?.backgroundColor = color
    }
    
    // set _UIBarBackground alpha (_UIBarBackground subviews alpha <= _UIBarBackground alpha)
    fileprivate func wr_setBackgroundAlpha(alpha:CGFloat)
    {
        if let barBackgroundView = subviews.first
        {
            if #available(iOS 11.0, *)
            {   // sometimes we can't change _UIBarBackground alpha
                for view in barBackgroundView.subviews {
                    view.alpha = alpha
                }
            } else {
                barBackgroundView.alpha = alpha
            }
        }
    }
    
    // 设置导航栏所有BarButtonItem的透明度
    func wr_setBarButtonItemsAlpha(alpha:CGFloat, hasSystemBackIndicator:Bool)
    {
        for view in subviews
        {
            if (hasSystemBackIndicator == true)
            {
                // _UIBarBackground/_UINavigationBarBackground对应的view是系统导航栏，不需要改变其透明度
                if let _UIBarBackgroundClass = NSClassFromString("_UIBarBackground")
                {
                    if view.isKind(of: _UIBarBackgroundClass) == false {
                        view.alpha = alpha
                    }
                }
                
                if let _UINavigationBarBackground = NSClassFromString("_UINavigationBarBackground")
                {
                    if view.isKind(of: _UINavigationBarBackground) == false {
                        view.alpha = alpha
                    }
                }
            }
            else
            {
                // 这里如果不做判断的话，会显示 backIndicatorImage(系统返回按钮)
                if let _UINavigationBarBackIndicatorViewClass = NSClassFromString("_UINavigationBarBackIndicatorView"),
                    view.isKind(of: _UINavigationBarBackIndicatorViewClass) == false
                {
                    if let _UIBarBackgroundClass = NSClassFromString("_UIBarBackground")
                    {
                        if view.isKind(of: _UIBarBackgroundClass) == false {
                            view.alpha = alpha
                        }
                    }
                    
                    if let _UINavigationBarBackground = NSClassFromString("_UINavigationBarBackground")
                    {
                        if view.isKind(of: _UINavigationBarBackground) == false {
                            view.alpha = alpha
                        }
                    }
                }
            }
        }
    }
    
    /// 设置导航栏在垂直方向上平移多少距离
    func wr_setTranslationY(translationY:CGFloat)
    {
        transform = CGAffineTransform.init(translationX: 0, y: translationY)
    }
    
    func wr_getTranslationY() -> CGFloat
    {
        return transform.ty
    }
    
    // call swizzling methods active 主动调用交换方法
    private static let onceToken = UUID().uuidString
    public static func wrAwake()
    {
        DispatchQueue.once(token: onceToken)
        {
            let needSwizzleSelectorArr = [
                #selector(setter: titleTextAttributes)
            ]
            
            for selector in needSwizzleSelectorArr {
                let str = ("wr_" + selector.description)
                if let originalMethod = class_getInstanceMethod(self, selector),
                   let swizzledMethod = class_getInstanceMethod(self, Selector(str)) {
                    method_exchangeImplementations(originalMethod, swizzledMethod)
                }
            }
        }
    }
    
    //==========================================================================
    // MARK: swizzling pop
    //==========================================================================
    @objc func wr_setTitleTextAttributes(_ newTitleTextAttributes:[String : Any]?)
    {
        guard var attributes = newTitleTextAttributes else {
            return
        }
        
        guard let originTitleTextAttributes = titleTextAttributes else {
            wr_setTitleTextAttributes(attributes)
            return
        }
        
        var titleColor:UIColor?
        for attribute in originTitleTextAttributes {
            if attribute.key == NSAttributedString.Key.foregroundColor {
                titleColor = attribute.value as? UIColor
                break
            }
        }
        
        guard let originTitleColor = titleColor else {
            wr_setTitleTextAttributes(attributes)
            return
        }

        if attributes[NSAttributedString.Key.foregroundColor.rawValue] == nil {
            attributes.updateValue(originTitleColor, forKey: NSAttributedString.Key.foregroundColor.rawValue)
        }
        wr_setTitleTextAttributes(attributes)
    }
}

//==========================================================================
// MARK: - UINavigationController
//==========================================================================
extension UINavigationController: WRFatherAwakeProtocol
{
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.statusBarStyle ?? WRNavigationBar.defaultStatusBarStyle
    }
    
    fileprivate func setNeedsNavigationBarUpdate(backgroundImage: UIImage)
    {
        navigationBar.wr_setBackgroundImage(image: backgroundImage)
    }
    
    fileprivate func setNeedsNavigationBarUpdate(barTintColor: UIColor)
    {
        navigationBar.wr_setBackgroundColor(color: barTintColor)
    }

    fileprivate func setNeedsNavigationBarUpdate(barBackgroundAlpha: CGFloat)
    {
        navigationBar.wr_setBackgroundAlpha(alpha: barBackgroundAlpha)
    }

    fileprivate func setNeedsNavigationBarUpdate(tintColor: UIColor) {
        navigationBar.tintColor = tintColor
    }
    
    fileprivate func setNeedsNavigationBarUpdate(hideShadowImage: Bool)
    {
        navigationBar.shadowImage = (hideShadowImage == true) ? UIImage() : nil
    }

    fileprivate func setNeedsNavigationBarUpdate(titleColor: UIColor)
    {
        guard let titleTextAttributes = navigationBar.titleTextAttributes else {
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:titleColor]
            return
        }
        
        var newTitleTextAttributes = titleTextAttributes
        newTitleTextAttributes.updateValue(titleColor, forKey: NSAttributedString.Key.foregroundColor)
        navigationBar.titleTextAttributes = newTitleTextAttributes
    }
    
    fileprivate func updateNavigationBar(fromVC: UIViewController?, toVC: UIViewController?, progress: CGFloat)
    {
        // change navBarBarTintColor
        let fromBarTintColor = fromVC?.navBarBarTintColor ?? WRNavigationBar.defaultNavBarBarTintColor
        let toBarTintColor   = toVC?.navBarBarTintColor ?? WRNavigationBar.defaultNavBarBarTintColor
        let newBarTintColor  = WRNavigationBar.middleColor(fromColor: fromBarTintColor, toColor: toBarTintColor, percent: progress)
        setNeedsNavigationBarUpdate(barTintColor: newBarTintColor)
        
        // change navBarTintColor
        let fromTintColor = fromVC?.navBarTintColor ?? WRNavigationBar.defaultNavBarTintColor
        let toTintColor = toVC?.navBarTintColor ?? WRNavigationBar.defaultNavBarTintColor
        let newTintColor = WRNavigationBar.middleColor(fromColor: fromTintColor, toColor: toTintColor, percent: progress)
        setNeedsNavigationBarUpdate(tintColor: newTintColor)
        
        // change navBarTitleColor
//        let fromTitleColor = fromVC?.navBarTitleColor ?? WRNavigationBar.defaultNavBarTitleColor
//        let toTitleColor = toVC?.navBarTitleColor ?? WRNavigationBar.defaultNavBarTitleColor
//        let newTitleColor = WRNavigationBar.middleColor(fromColor: fromTitleColor, toColor: toTitleColor, percent: progress)
//        setNeedsNavigationBarUpdate(titleColor: newTitleColor)
        
        // change navBar _UIBarBackground alpha
        let fromBarBackgroundAlpha = fromVC?.navBarBackgroundAlpha ?? WRNavigationBar.defaultBackgroundAlpha
        let toBarBackgroundAlpha = toVC?.navBarBackgroundAlpha ?? WRNavigationBar.defaultBackgroundAlpha
        let newBarBackgroundAlpha = WRNavigationBar.middleAlpha(fromAlpha: fromBarBackgroundAlpha, toAlpha: toBarBackgroundAlpha, percent: progress)
        setNeedsNavigationBarUpdate(barBackgroundAlpha: newBarBackgroundAlpha)
    }
    
    // call swizzling methods active 主动调用交换方法
    private static let onceToken = UUID().uuidString
    public static func fatherAwake()
    {
        DispatchQueue.once(token: onceToken)
        {
            let needSwizzleSelectorArr = [
                NSSelectorFromString("_updateInteractiveTransition:"),
                #selector(popToViewController),
                #selector(popToRootViewController),
                #selector(pushViewController)
            ]

            for selector in needSwizzleSelectorArr {
                // _updateInteractiveTransition:  =>  wr_updateInteractiveTransition:
                let str = ("wr_" + selector.description).replacingOccurrences(of: "__", with: "_")
                if let originalMethod = class_getInstanceMethod(self, selector),
                    let swizzledMethod = class_getInstanceMethod(self, Selector(str)) {
                    method_exchangeImplementations(originalMethod, swizzledMethod)
                }
            }
        }
    }
    
    //==========================================================================
    // MARK: swizzling pop
    //==========================================================================
    struct popProperties {
        fileprivate static let popDuration = 0.13
        fileprivate static var displayCount = 0
        fileprivate static var popProgress:CGFloat {
            let all:CGFloat = CGFloat(60.0 * popDuration)
            let current = min(all, CGFloat(displayCount))
            return current / all
        }
    }
    
    // swizzling system method: popToViewController
    @objc func wr_popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]?
    {
        setNeedsNavigationBarUpdate(titleColor: viewController.navBarTitleColor)
        var displayLink:CADisplayLink? = CADisplayLink(target: self, selector: #selector(popNeedDisplay))
        // UITrackingRunLoopMode: 界面跟踪 Mode，用于 ScrollView 追踪触摸滑动，保证界面滑动时不受其他 Mode 影响
        // NSRunLoopCommonModes contains kCFRunLoopDefaultMode and UITrackingRunLoopMode
//        displayLink?.add(to: RunLoop.main, forMode: .RunLoop.Mode.common)
        displayLink?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)

        CATransaction.setCompletionBlock {
            displayLink?.invalidate()
            displayLink = nil
            popProperties.displayCount = 0
        }
        CATransaction.setAnimationDuration(popProperties.popDuration)
        CATransaction.begin()
        let vcs = wr_popToViewController(viewController, animated: animated)
        CATransaction.commit()
        return vcs
    }
    
    // swizzling system method: popToRootViewControllerAnimated
    @objc func wr_popToRootViewControllerAnimated(_ animated: Bool) -> [UIViewController]?
    {
        var displayLink:CADisplayLink? = CADisplayLink(target: self, selector: #selector(popNeedDisplay))
//        displayLink?.add(to: RunLoop.main, forMode: .RunLoop.Mode.common)
        displayLink?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)

        CATransaction.setCompletionBlock {
            displayLink?.invalidate()
            displayLink = nil
            popProperties.displayCount = 0
        }
        CATransaction.setAnimationDuration(popProperties.popDuration)
        CATransaction.begin()
        let vcs = wr_popToRootViewControllerAnimated(animated)
        CATransaction.commit()
        return vcs;
    }
    
    // change navigationBar barTintColor smooth before pop to current VC finished
    @objc fileprivate func popNeedDisplay()
    {
        guard let topViewController = topViewController,
            let coordinator       = topViewController.transitionCoordinator else {
                return
        }
        
        popProperties.displayCount += 1
        let popProgress = popProperties.popProgress
        // print("第\(popProperties.displayCount)次pop的进度：\(popProgress)")
        let fromVC = coordinator.viewController(forKey: .from)
        let toVC = coordinator.viewController(forKey: .to)
        updateNavigationBar(fromVC: fromVC, toVC: toVC, progress: popProgress)
    }
    
    
    //==========================================================================
    // MARK: swizzling push
    //==========================================================================
    struct pushProperties {
        fileprivate static let pushDuration = 0.13
        fileprivate static var displayCount = 0
        fileprivate static var pushProgress:CGFloat {
            let all:CGFloat = CGFloat(60.0 * pushDuration)
            let current = min(all, CGFloat(displayCount))
            return current / all
        }
    }
    
    // swizzling system method: pushViewController
    @objc func wr_pushViewController(_ viewController: UIViewController, animated: Bool)
    {
        var displayLink:CADisplayLink? = CADisplayLink(target: self, selector: #selector(pushNeedDisplay))
//        displayLink?.add(to: RunLoop.main.run.Mode.common .commonModes, forMode: RunLoop.Mode.default)
        displayLink?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)

        CATransaction.setCompletionBlock {
            displayLink?.invalidate()
            displayLink = nil
            pushProperties.displayCount = 0
            viewController.pushToCurrentVCFinished = true
        };
        CATransaction.setAnimationDuration(pushProperties.pushDuration)
        CATransaction.begin()
        wr_pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    // change navigationBar barTintColor smooth before push to current VC finished or before pop to current VC finished
    @objc fileprivate func pushNeedDisplay()
    {
        guard let topViewController = topViewController,
              let coordinator       = topViewController.transitionCoordinator else {
                return
        }
        
        pushProperties.displayCount += 1
        let pushProgress = pushProperties.pushProgress
        // print("第\(pushProperties.displayCount)次push的进度：\(pushProgress)")
        let fromVC = coordinator.viewController(forKey: .from)
        let toVC = coordinator.viewController(forKey: .to)
        updateNavigationBar(fromVC: fromVC, toVC: toVC, progress: pushProgress)
    }
}

//==========================================================================
// MARK: - deal the gesture of return
//==========================================================================
extension UINavigationController: UINavigationBarDelegate
{
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool
    {
        if let topVC = topViewController,
           let coor = topVC.transitionCoordinator, coor.initiallyInteractive {
            if #available(iOS 10.0, *) {
                coor.notifyWhenInteractionChanges({ (context) in
                    self.dealInteractionChanges(context)
                })
            } else {
                coor.notifyWhenInteractionEnds({ (context) in
                    self.dealInteractionChanges(context)
                })
            }
            return true
        }
        
        let itemCount = navigationBar.items?.count ?? 0
        let n = viewControllers.count >= itemCount ? 2 : 1
        let popToVC = viewControllers[viewControllers.count - n]
        
        popToViewController(popToVC, animated: true)
        return true
    }
    
    // deal the gesture of return break off
    private func dealInteractionChanges(_ context: UIViewControllerTransitionCoordinatorContext)
    {
        let animations: (UITransitionContextViewControllerKey) -> () = {
            let curColor = context.viewController(forKey: $0)?.navBarBarTintColor ?? WRNavigationBar.defaultNavBarBarTintColor
            let curAlpha = context.viewController(forKey: $0)?.navBarBackgroundAlpha ?? WRNavigationBar.defaultBackgroundAlpha
            
            self.setNeedsNavigationBarUpdate(barTintColor: curColor)
            self.setNeedsNavigationBarUpdate(barBackgroundAlpha: curAlpha)
        }
        
        // after that, cancel the gesture of return
        if context.isCancelled
        {
            let cancelDuration: TimeInterval = context.transitionDuration * Double(context.percentComplete)
            UIView.animate(withDuration: cancelDuration) {
                animations(.from)
            }
        }
        else
        {
            // after that, finish the gesture of return
            let finishDuration: TimeInterval = context.transitionDuration * Double(1 - context.percentComplete)
            UIView.animate(withDuration: finishDuration) {
                animations(.to)
            }
        }
    }
    
    // swizzling system method: _updateInteractiveTransition
    @objc func wr_updateInteractiveTransition(_ percentComplete: CGFloat)
    {
        guard let topViewController = topViewController,
            let coordinator       = topViewController.transitionCoordinator else {
                wr_updateInteractiveTransition(percentComplete)
                return
        }
        
        let fromVC = coordinator.viewController(forKey: .from)
        let toVC = coordinator.viewController(forKey: .to)
        updateNavigationBar(fromVC: fromVC, toVC: toVC, progress: percentComplete)
        
        wr_updateInteractiveTransition(percentComplete)
    }
}

//=============================================================================
// MARK: - store navigationBar barTintColor and tintColor every viewController
//=============================================================================
extension UIViewController: WRAwakeProtocol
{
    fileprivate struct AssociatedKeys
    {
        static var pushToCurrentVCFinished: Bool = false
        static var pushToNextVCFinished:Bool = false
        
        static var navBarBackgroundImage: UIImage = UIImage()
        
        static var navBarBarTintColor: UIColor = WRNavigationBar.defaultNavBarBarTintColor
        static var navBarBackgroundAlpha:CGFloat = 1.0
        static var navBarTintColor: UIColor = WRNavigationBar.defaultNavBarTintColor
        static var navBarTitleColor: UIColor = WRNavigationBar.defaultNavBarTitleColor
        static var statusBarStyle: UIStatusBarStyle = UIStatusBarStyle.default
        static var navBarShadowImageHidden: Bool = false
        
        static var customNavBar: UINavigationBar = UINavigationBar()
    }
    
    // navigationBar barTintColor can not change by currentVC before fromVC push to currentVC finished
    fileprivate var pushToCurrentVCFinished:Bool {
        get {
            guard let isFinished = objc_getAssociatedObject(self, &AssociatedKeys.pushToCurrentVCFinished) as? Bool else {
                return false
            }
            return isFinished
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.pushToCurrentVCFinished, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    // navigationBar barTintColor can not change by currentVC when currentVC push to nextVC finished
    fileprivate var pushToNextVCFinished:Bool {
        get {
            guard let isFinished = objc_getAssociatedObject(self, &AssociatedKeys.pushToNextVCFinished) as? Bool else {
                return false
            }
            return isFinished
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.pushToNextVCFinished, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    // you can set navigationBar backgroundImage
    var navBarBackgroundImage: UIImage?
    {
        get {
            guard let bgImage = objc_getAssociatedObject(self, &AssociatedKeys.navBarBackgroundImage) as? UIImage else {
                return WRNavigationBar.defaultNavBarBackgroundImage
            }
            return bgImage
        }
//        set {
//            if customNavBar.isKind(of: UINavigationBar.self) {
//                let navBar = customNavBar as! UINavigationBar
//                navBar.wr_setBackgroundImage(image: newValue!)
//            }
//            else {
//                objc_setAssociatedObject(self, &AssociatedKeys.navBarBackgroundImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//            }
//        }
    }
    
    // navigationBar barTintColor
    var navBarBarTintColor: UIColor {
        get {
            guard let barTintColor = objc_getAssociatedObject(self, &AssociatedKeys.navBarBarTintColor) as? UIColor else {
                return WRNavigationBar.defaultNavBarBarTintColor
            }
            return barTintColor
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.navBarBarTintColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            if customNavBar.isKind(of: UINavigationBar.self) {
//                let navBar = customNavBar as! UINavigationBar
//                navBar.wr_setBackgroundColor(color: newValue)
            }
            else {
                if canUpdateNavBarBarTintColorOrBackgroundAlpha == true {
                    navigationController?.setNeedsNavigationBarUpdate(barTintColor: newValue)
                }
            }
        }
    }

    // navigationBar _UIBarBackground alpha
    var navBarBackgroundAlpha:CGFloat {
        get {
            guard let barBackgroundAlpha = objc_getAssociatedObject(self, &AssociatedKeys.navBarBackgroundAlpha) as? CGFloat else {
                return 1.0
            }
            return barBackgroundAlpha
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.navBarBackgroundAlpha, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            if customNavBar.isKind(of: UINavigationBar.self) {
//                let navBar = customNavBar as! UINavigationBar
//                navBar.wr_setBackgroundAlpha(alpha: newValue)
            }
            else {
                if canUpdateNavBarBarTintColorOrBackgroundAlpha == true {
                    navigationController?.setNeedsNavigationBarUpdate(barBackgroundAlpha: newValue)
                }
            }
        }
    }
    private var canUpdateNavBarBarTintColorOrBackgroundAlpha:Bool {
        get {
            let isRootViewController = self.navigationController?.viewControllers.first == self
            if (pushToCurrentVCFinished == true || isRootViewController == true) && pushToNextVCFinished == false {
                return true
            } else {
                return false
            }
        }
    }
    
    // navigationBar tintColor
    var navBarTintColor: UIColor {
        get {
            guard let tintColor = objc_getAssociatedObject(self, &AssociatedKeys.navBarTintColor) as? UIColor else {
                return WRNavigationBar.defaultNavBarTintColor
            }
            return tintColor
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.navBarTintColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            if customNavBar.isKind(of: UINavigationBar.self) {
//                let navBar = customNavBar as! UINavigationBar
//                navBar.tintColor = newValue
            }
            else
            {
                if pushToNextVCFinished == false {
                    navigationController?.setNeedsNavigationBarUpdate(tintColor: newValue)
                }
            }
        }
    }
    
    // navigationBar titleColor
    var navBarTitleColor: UIColor {
        get {
            guard let titleColor = objc_getAssociatedObject(self, &AssociatedKeys.navBarTitleColor) as? UIColor else {
                return WRNavigationBar.defaultNavBarTitleColor
            }
            return titleColor
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.navBarTitleColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            if customNavBar.isKind(of: UINavigationBar.self) {
//                let navBar = customNavBar as! UINavigationBar
//                navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:newValue]
            }
            else
            {
                if pushToNextVCFinished == false {
                    navigationController?.setNeedsNavigationBarUpdate(titleColor: newValue)
                }
            }
        }
    }

    // statusBarStyle
    var statusBarStyle: UIStatusBarStyle {
        get {
            guard let style = objc_getAssociatedObject(self, &AssociatedKeys.statusBarStyle) as? UIStatusBarStyle else {
                return WRNavigationBar.defaultStatusBarStyle
            }
            return style
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.statusBarStyle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    // if you want shadowImage hidden,you can via hideShadowImage = true
    var navBarShadowImageHidden:Bool {
        get {
            guard let isHidden = objc_getAssociatedObject(self, &AssociatedKeys.navBarShadowImageHidden) as? Bool else {
                return WRNavigationBar.defaultShadowImageHidden
            }
            return isHidden
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.navBarShadowImageHidden, newValue, .OBJC_ASSOCIATION_ASSIGN)
            navigationController?.setNeedsNavigationBarUpdate(hideShadowImage: newValue)
        }
    }
    
    // custom navigationBar
    var customNavBar: UIView {
        get {
            guard let navBar = objc_getAssociatedObject(self, &AssociatedKeys.customNavBar) as? UINavigationBar else {
                return UIView()
            }
            return navBar
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.customNavBar, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // swizzling two system methods: viewWillAppear(_:) and viewWillDisappear(_:)
    private static let onceToken = UUID().uuidString
    @objc public static func wrAwake()
    {
        DispatchQueue.once(token: onceToken)
        {
            let needSwizzleSelectors = [
                #selector(viewWillAppear(_:)),
                #selector(viewWillDisappear(_:)),
                #selector(viewDidAppear(_:))
            ]

            for selector in needSwizzleSelectors
            {
                let newSelectorStr = "wr_" + selector.description
                if let originalMethod = class_getInstanceMethod(self, selector),
                    let swizzledMethod = class_getInstanceMethod(self, Selector(newSelectorStr)) {
                    method_exchangeImplementations(originalMethod, swizzledMethod)
                }
            }
        }
    }
    
    @objc func wr_viewWillAppear(_ animated: Bool)
    {
        if canUpdateNavigationBar() == true {
            pushToNextVCFinished = false
            navigationController?.setNeedsNavigationBarUpdate(tintColor: navBarTintColor)
            navigationController?.setNeedsNavigationBarUpdate(titleColor: navBarTitleColor)
        }
        wr_viewWillAppear(animated)
    }
    
    @objc func wr_viewWillDisappear(_ animated: Bool)
    {
        if canUpdateNavigationBar() == true {
            pushToNextVCFinished = true
        }
        wr_viewWillDisappear(animated)
    }
    
    @objc func wr_viewDidAppear(_ animated: Bool)
    {
        
        if self.navigationController?.viewControllers.first != self {
            self.pushToCurrentVCFinished = true
        }
        if canUpdateNavigationBar() == true
        {
            if let navBarBgImage = navBarBackgroundImage {
                navigationController?.setNeedsNavigationBarUpdate(backgroundImage: navBarBgImage)
            } else {
                navigationController?.setNeedsNavigationBarUpdate(barTintColor: navBarBarTintColor)
            }
            navigationController?.setNeedsNavigationBarUpdate(barBackgroundAlpha: navBarBackgroundAlpha)
            navigationController?.setNeedsNavigationBarUpdate(tintColor: navBarTintColor)
            navigationController?.setNeedsNavigationBarUpdate(titleColor: navBarTitleColor)
            navigationController?.setNeedsNavigationBarUpdate(hideShadowImage: navBarShadowImageHidden)
        }
        wr_viewDidAppear(animated)
    }
    
    func canUpdateNavigationBar() -> Bool
    {
        let viewFrame = view.frame
        let maxFrame = UIScreen.main.bounds
        let middleFrame = CGRect(x: 0, y: WRNavigationBar.navBarBottom(), width: WRNavigationBar.screenWidth(), height: WRNavigationBar.screenHeight()-WRNavigationBar.navBarBottom())
        let minFrame = CGRect(x: 0, y: WRNavigationBar.navBarBottom(), width: WRNavigationBar.screenWidth(), height: WRNavigationBar.screenHeight()-WRNavigationBar.navBarBottom()-WRNavigationBar.tabBarHeight())
        // 蝙蝠🦇
        let isBat = viewFrame.equalTo(maxFrame) || viewFrame.equalTo(middleFrame) || viewFrame.equalTo(minFrame)
        if self.navigationController != nil && isBat == true {
            return true
        } else {
            return false
        }
    }
    
}

//====================================================================================
// MARK: - Swizzling会改变全局状态,所以用 DispatchQueue.once 来确保无论多少线程都只会被执行一次
//====================================================================================
extension DispatchQueue {
    
    private static var onceTracker = [String]()
    
    //Executes a block of code, associated with a unique token, only once.  The code is thread safe and will only execute the code once even in the presence of multithreaded calls.
    public class func once(token: String, block: () -> Void)
    {   // 保证被 objc_sync_enter 和 objc_sync_exit 包裹的代码可以有序同步地执行
        objc_sync_enter(self)
        defer { // 作用域结束后执行defer中的代码
            objc_sync_exit(self)
        }
        
        if onceTracker.contains(token) {
            return
        }
        
        onceTracker.append(token)
        block()
    }
}


//===========================================================================================
// MARK: - default navigationBar barTintColor、tintColor and statusBarStyle YOU CAN CHANGE!!!
//===========================================================================================
class WRNavigationBar
{
    fileprivate struct AssociatedKeys
    {   // default is system attributes
        static var defNavBarBarTintColor: UIColor = UIColor.white
        static var defNavBarBackgroundImage: UIImage = UIImage()
        static var defNavBarTintColor: UIColor = UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1.0)
        static var defNavBarTitleColor: UIColor = UIColor.black
        static var defStatusBarStyle: UIStatusBarStyle = UIStatusBarStyle.default
        static var defShadowImageHidden: Bool = false
    }
    
    class var defaultNavBarBarTintColor: UIColor {
        get {
            guard let def = objc_getAssociatedObject(self, &AssociatedKeys.defNavBarBarTintColor) as? UIColor else {
                return AssociatedKeys.defNavBarBarTintColor
            }
            return def
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.defNavBarBarTintColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    class var defaultNavBarBackgroundImage: UIImage? {
        get {
            guard let def = objc_getAssociatedObject(self, &AssociatedKeys.defNavBarBackgroundImage) as? UIImage else {
                return nil
            }
            return def
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.defNavBarBackgroundImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    class var defaultNavBarTintColor: UIColor {
        get {
            guard let def = objc_getAssociatedObject(self, &AssociatedKeys.defNavBarTintColor) as? UIColor else {
                return AssociatedKeys.defNavBarTintColor
            }
            return def
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.defNavBarTintColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    class var defaultNavBarTitleColor: UIColor {
        get {
            guard let def = objc_getAssociatedObject(self, &AssociatedKeys.defNavBarTitleColor) as? UIColor else {
                return AssociatedKeys.defNavBarTitleColor
            }
            return def
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.defNavBarTitleColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    class var defaultStatusBarStyle: UIStatusBarStyle {
        get {
            guard let def = objc_getAssociatedObject(self, &AssociatedKeys.defStatusBarStyle) as? UIStatusBarStyle else {
                return .default
            }
            return def
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.defStatusBarStyle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    class var defaultShadowImageHidden: Bool {
        get {
            guard let def = objc_getAssociatedObject(self, &AssociatedKeys.defShadowImageHidden) as? Bool else {
                return false
            }
            return def
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.defShadowImageHidden, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    class var defaultBackgroundAlpha: CGFloat {
        get {
            return 1.0
        }
    }
    
    // Calculate the middle Color with translation percent
    class fileprivate func middleColor(fromColor: UIColor, toColor: UIColor, percent: CGFloat) -> UIColor
    {
        // get current color RGBA
        var fromRed: CGFloat = 0
        var fromGreen: CGFloat = 0
        var fromBlue: CGFloat = 0
        var fromAlpha: CGFloat = 0
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        
        // get to color RGBA
        var toRed: CGFloat = 0
        var toGreen: CGFloat = 0
        var toBlue: CGFloat = 0
        var toAlpha: CGFloat = 0
        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        // calculate middle color RGBA
        let newRed = fromRed + (toRed - fromRed) * percent
        let newGreen = fromGreen + (toGreen - fromGreen) * percent
        let newBlue = fromBlue + (toBlue - fromBlue) * percent
        let newAlpha = fromAlpha + (toAlpha - fromAlpha) * percent
        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: newAlpha)
    }
    
    // Calculate the middle alpha
    class fileprivate func middleAlpha(fromAlpha: CGFloat, toAlpha: CGFloat, percent: CGFloat) -> CGFloat
    {
        let newAlpha = fromAlpha + (toAlpha - fromAlpha) * percent
        return newAlpha
    }
}

extension WRNavigationBar
{
    class func isIphoneX() -> Bool {
        return UIScreen.main.bounds.equalTo(CGRect(x: 0, y: 0, width: 375, height: 812))
    }
    class func navBarBottom() -> Int {
        return self.isIphoneX() ? 88 : 64;
    }
    class func tabBarHeight() -> Int {
        return self.isIphoneX() ? 83 : 49;
    }
    class func screenWidth() -> Int {
        return Int(UIScreen.main.bounds.size.width)
    }
    class func screenHeight() -> Int {
        return Int(UIScreen.main.bounds.size.height)
    }
}











////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 1. 定义 WRAwakeProtocol 协议
public protocol WRAwakeProtocol: class {
    static func wrAwake()
}
public protocol WRFatherAwakeProtocol: class
{   // 1.1 定义 WRFatherAwakeProtocol ()
    static func fatherAwake()
}

class NothingToSeeHere
{
    static func harmlessFunction(){
//        let typeCount = Int(objc_getClassList(nil, 0))
//        let  types = UnsafeMutablePointer<AnyClass?>.allocate(capacity: typeCount)
//        let autoreleaseintTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
//        objc_getClassList(autoreleaseintTypes, Int32(typeCount)) //获取所有的类
//        for index in 0 ..< typeCount {
//            (types[index] as? WRAwakeProtocol.Type)?.wrAwake() //如果该类实现了SelfAware协议，那么调用 awake 方法
//            (types[index] as? WRFatherAwakeProtocol.Type)?.fatherAwake()
//        }
//        types.deallocate(capacity: typeCount)
        UINavigationBar.wrAwake()
        UIViewController.wrAwake()
        UINavigationController.fatherAwake()
    }
}

// 2. 让APP启动时只执行一次 harmlessFunction 方法
extension UIApplication
{
    private static let runOnce:Void = { //使用静态属性以保证只调用一次(该属性是个方法)
        NothingToSeeHere.harmlessFunction()
    }()
    
    open override var next: UIResponder?{ //重写next属性
        UIApplication.runOnce
        return super.next
    }
}

// 3. 自定义类实现 WRAwakeProtocol 协议，重写 wrAwake 方法
//    自定义类实现 WRFatherAwakeProtocol 协议，重写 fatherAwake 方法

