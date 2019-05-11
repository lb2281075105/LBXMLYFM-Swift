//
//  LBFMListenChannelController.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/24.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit
import LTScrollView

class LBFMListenChannelController: UIViewController,LTTableViewProtocal {
    
    // - footerView
    private lazy var footerView:LBFMListenFooterView = {
        let view = LBFMListenFooterView.init(frame: CGRect(x:0, y:0, width:LBFMScreenWidth, height:100))
        view.listenFooterViewTitle = "➕添加频道"
        view.delegate = self
        return view
    }()
    
    private let LBFMListenChannelCellID = "LBFMListenChannelCell"
    
    private lazy var tableView: UITableView = {
        let tableView = tableViewConfig(CGRect(x: 0, y: 5, width:LBFMScreenWidth, height: LBFMScreenHeight - 64), self, self, nil)
        tableView.register(LBFMListenChannelCell.self, forCellReuseIdentifier: LBFMListenChannelCellID)
        tableView.backgroundColor = UIColor.init(r: 240, g: 241, b: 244)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.tableFooterView = self.footerView
        return tableView
    }()
    
    lazy var viewModel: LBFMListenChannelViewModel = {
        return LBFMListenChannelViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        glt_scrollView = tableView
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        // 请求数据
        setupLoadData()
    }
    
    func setupLoadData() {
        // 加载数据
        viewModel.updataBlock = { [unowned self] in
            // 更新列表数据
            self.tableView.reloadData()
        }
        viewModel.refreshDataSource()
    }
    
}

extension LBFMListenChannelController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LBFMListenChannelCell = tableView.dequeueReusableCell(withIdentifier: LBFMListenChannelCellID, for: indexPath) as! LBFMListenChannelCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundColor = UIColor.init(r: 240, g: 241, b: 244)
        cell.channelResults = viewModel.channelResults?[indexPath.row]
        return cell
    }
}

// - 底部添加频道按钮点击delegate
extension LBFMListenChannelController : LBFMListenFooterViewDelegate {
    func listenFooterAddBtnClick() {
        let vc = LBFMListenMoreChannelController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
