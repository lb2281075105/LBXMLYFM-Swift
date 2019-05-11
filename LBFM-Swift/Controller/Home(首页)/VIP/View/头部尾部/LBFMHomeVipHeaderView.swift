//
//  LBFMHomeVipHeaderView.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/25.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit

class LBFMHomeVipHeaderView: UITableViewHeaderFooterView {
    // 标题
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private var moreBtn:UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setTitle("更多 >", for: UIControl.State.normal)
        button.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUpLayout()
        self.tintColor = UIColor.red
    }
    
    func setUpLayout(){
        self.addSubview(self.titleLabel)
        self.titleLabel.text = "最热有声读物"
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(10)
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        
        self.addSubview(self.moreBtn)
        self.moreBtn.snp.makeConstraints { (make) in
            make.right.equalTo(15)
            make.top.equalTo(10)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
    }
    
    var titStr: String? {
        didSet{
            guard let string = titStr else {return}
            self.titleLabel.text = string
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
