//
//  LBFMCustomLabel.swift
//  XMLYFM
//
//  Created by JCSON on 2018/8/21.
//  Copyright © 2018年 liubo. All rights reserved.
//

import UIKit
// label 文字从坐上角开始显示
class LBFMCustomLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var textRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        textRect.origin.y = bounds.origin.y
        return textRect
    }
    
    override func drawText(in rect: CGRect) {
        let actualRect = self.textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawText(in: actualRect)
    }
}
