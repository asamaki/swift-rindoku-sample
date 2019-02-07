//
//  SearchKeywordHistoryResultsController.swift
//  swift-rindoku-sample
//
//  Created by SCI01254 on 2019/01/10.
//  Copyright © 2019 hicka04. All rights reserved.
//

import UIKit

protocol SearchKeywordHistoryResultsDelegate {
    func search(searchText: String)
}

class SearchKeywordHistoryResultsController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    var delegate: SearchKeywordHistoryResultsDelegate?
    let searchKeywordHistoryService = SearchKeywordHistoryService()
    let cellId = "SearchKeywordCellId"
    var data: [SearchKeywordHistory] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        data = searchKeywordHistoryService.findAll()
    }
}

extension SearchKeywordHistoryResultsController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 配列の要素数を返す
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        if(data.count == 0){
            return cell
        }
        cell.textLabel?.text = data[indexPath.row].keyword
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セル選択後に呼ばれる
        // 押されたセルの場所(indexPath)などに応じて処理を変えることができるが
        // 今回は必ずDetailViewControllerに遷移するように実装
        let historyKeyword = data[indexPath.row].keyword
        delegate?.search(searchText: historyKeyword)
        //let detailView = DetailViewController(repository: repository)
        
        // navigationController:画面遷移を司るクラス
        // pushViewController(_:animated:)で画面遷移できる
        // navigationController?.pushViewController(detailView, animated: true)
    }


}
