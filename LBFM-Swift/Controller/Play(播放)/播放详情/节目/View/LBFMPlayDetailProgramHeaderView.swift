//
//  LBFMPlayDetailProgramHeaderView.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/3/8.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit

class LBFMPlayDetailProgramHeaderView: UIView {
    private lazy var playBtn:UIButton = {
        // 收听全部
        let button = UIButton.init(type: UIButtonType.custom)
        button.setTitle("收听全部", for: UIControlState.normal)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setImage(UIImage(named: "play"), for: UIControlState.normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(2, 5, 2, 0)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        button.backgroundColor = LBFMButtonColor
        button.isHidden = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    
    func setUpLayout(){
        self.addSubview(self.playBtn)
        self.playBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.width.equalTo(80)
            make.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
