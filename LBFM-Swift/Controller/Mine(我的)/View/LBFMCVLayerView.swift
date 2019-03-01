//
//  LBFMCVLayerView.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/3/1.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit

class LBFMCVLayerView: UIView {

    var pulseLayer : CAShapeLayer!  //定义图层
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let width = self.bounds.size.width
        
        // 动画图层
        pulseLayer = CAShapeLayer()
        pulseLayer.bounds = CGRect(x: 0, y: 0, width: width, height: width)
        pulseLayer.position = CGPoint(x: width / 2, y: width / 2)
        pulseLayer.backgroundColor = UIColor.clear.cgColor
        // 用BezierPath画一个原型
        pulseLayer.path = UIBezierPath(ovalIn: pulseLayer.bounds).cgPath
        // 脉冲效果的颜色  (注释*1)
        pulseLayer.fillColor = UIColor.init(r: 213, g: 54, b: 13).cgColor
        pulseLayer.opacity = 0.0
        
        // 关键代码
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.bounds = CGRect(x: 0, y: 0, width: width, height: width)
        replicatorLayer.position = CGPoint(x: width/2, y: width/2)
        // 三个复制图层
        replicatorLayer.instanceCount = 3
        // 频率
        replicatorLayer.instanceDelay = 1
        replicatorLayer.addSublayer(pulseLayer)
        self.layer.addSublayer(replicatorLayer)
        self.layer.insertSublayer(replicatorLayer, at: 0)
    }
    
    func starAnimation() {
        // 透明
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        // 起始值
        opacityAnimation.fromValue = 1.0
        // 结束值
        opacityAnimation.toValue = 0
        
        // 扩散动画
        let scaleAnimation = CABasicAnimation(keyPath: "transform")
        let t = CATransform3DIdentity
        scaleAnimation.fromValue = NSValue(caTransform3D: CATransform3DScale(t, 0.0, 0.0, 0.0))
        scaleAnimation.toValue = NSValue(caTransform3D: CATransform3DScale(t, 1.0, 1.0, 0.0))
        
        // 给CAShapeLayer添加组合动画
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [opacityAnimation,scaleAnimation]
        // 持续时间
        groupAnimation.duration = 3
        // 循环效果
        groupAnimation.autoreverses = false
        groupAnimation.repeatCount = HUGE
        groupAnimation.isRemovedOnCompletion = false
        pulseLayer.add(groupAnimation, forKey: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
