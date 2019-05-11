//
//  LBFMListenSubscibeController.swift
//  LBFM-Swift
//
//  Created by liubo on 2019/2/22.
//  Copyright © 2019 刘博. All rights reserved.
//

import UIKit
import LTScrollView
class LBFMListenSubscibeController: UIViewController , LTTableViewProtocal{
    private lazy var footerView:LBFMListenFooterView = {
        let view = LBFMListenFooterView.init(frame: CGRect(x:0, y:0, width:LBFMScreenWidth, height:100))
        view.listenFooterViewTitle = "➕添加订阅"
        return view
    }()
    
    private let LBFMListenSubscibeCellID = "LBFMListenSubscibeCell"
    
    private lazy var tableView: UITableView = {
        let tableView = tableViewConfig(CGRect(x: 0, y: 0, width:LBFMScreenWidth, height: LBFMScreenHeight - 64), self, self, nil)
        tableView.register(LBFMListenSubscibeCell.self, forCellReuseIdentifier: LBFMListenSubscibeCellID)
        tableView.backgroundColor = UIColor.init(r: 240, g: 241, b: 244)
        //  tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.tableFooterView = self.footerView
        return tableView
    }()
    
    lazy var viewModel: LBFMListenSubscibeViewModel = {
        return LBFMListenSubscibeViewModel()
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

extension LBFMListenSubscibeController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LBFMListenSubscibeCell = tableView.dequeueReusableCell(withIdentifier: LBFMListenSubscibeCellID, for: indexPath) as! LBFMListenSubscibeCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.albumResults = viewModel.albumResults?[indexPath.row]
        return cell
    }
}

