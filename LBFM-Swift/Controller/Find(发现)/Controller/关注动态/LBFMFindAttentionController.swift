//
//  LBFMFindAttentionController.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/28.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit
import LTScrollView

class LBFMFindAttentionController: UIViewController , LTTableViewProtocal{
    
    private let LBFMFindAttentionCellID = "LBFMFindAttentionCell"
    
    private lazy var tableView: UITableView = {
        let tableView = tableViewConfig(CGRect(x: 0, y: 0, width:LBFMScreenWidth, height: LBFMScreenHeight - LBFMNavBarHeight - LBFMTabBarHeight), self, self, nil)
        tableView.register(LBFMFindAttentionCell.self, forCellReuseIdentifier: LBFMFindAttentionCellID)
        return tableView
    }()
    
    // 懒加载
    lazy var viewModel: LBFMFindAttentionViewModel = {
        return LBFMFindAttentionViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(tableView)
        glt_scrollView = tableView
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        setupLoadData()
    }
    // 加载数据
    func setupLoadData() {
        // 加载数据
        viewModel.updataBlock = { [unowned self] in
            // 更新列表数据
            self.tableView.reloadData()
        }
        viewModel.refreshDataSource()
    }
    
}

extension LBFMFindAttentionController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRowAt(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LBFMFindAttentionCell = tableView.dequeueReusableCell(withIdentifier: LBFMFindAttentionCellID, for: indexPath) as! LBFMFindAttentionCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.eventInfosModel = viewModel.eventInfos?[indexPath.row]
        return cell
    }
}

