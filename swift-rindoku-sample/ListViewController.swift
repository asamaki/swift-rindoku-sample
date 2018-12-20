//
//  ViewController.swift
//  swift-rindoku-sample
//
//  Created by hicka04 on 2018/08/11.
//  Copyright © 2018 hicka04. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    let cellId = "cellId"
    var searchController = UISearchController()
    let searchKeywordHistoryManager = SearchKeywordHistoryManager()
    
    // 配列を定義してこれを元にtableViewに表示
    // APIクライアントを作ったらそのデータに差し替え
    var data: [Repository] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableViewのカスタマイズをするためにdelegateとdataSourceを設定
        // 今回は自身をUITableViewDelegateとUITableViewDataSourceに準拠させて使う
        tableView.delegate = self
        tableView.dataSource = self
        
        // tableViewで使うセルを登録しておく
        // 登録しておくとcellForRowAtでdequeueReusableCellから取得できるようになる
        // セルの使い回しができる
        // CellReuseIdentifierは使い回し時にも使うのでプロパティに切り出すのがおすすめ
        // Xibで作ったセルを登録するときはUINib(nibBName:bundle:)を使う必要がある
        let nib = UINib(nibName: "RepositoryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        
        // 検索バー配置
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "キーワードを入力"
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        if let history = searchKeywordHistoryManager.load() {
            searchController.searchBar.text = history.keyword
            loadData(keyword: history.keyword)
        }

        definesPresentationContext = true
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 画面が表示され始めたタイミングで
        // tableViewで選択中のセルがあれば非選択状態にする
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func loadData(keyword: String) {
        let request = GitHubAPI.SearchRepositories(keyword: keyword)
        GitHubClient().send(request: request) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let value):
                self.data = value.items
            case .failure(.connectionError(let error)):
                self.showAlert(title: "ネットワークエラー", message: "ネットワークが繋がりません")
                print(error)
                break
            case .failure(.responseParseError(let error)):
                self.showAlert(title: "サーバエラー", message: "接続に問題が発生しました。")
                print(error)
                break
            case .failure(.apiError(let error)):
                self.showAlert(title: "サーバエラー", message: "接続に問題が発生しました。")
                print(error)
                break
            }
        }
    }
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text!
        loadData(keyword: searchText)
        let history = SearchKeywordHistory(keyword: searchText)
        searchKeywordHistoryManager.append(searchKeywordHistory: history)
        self.view.endEditing(true)
    }
}
// UITableViewDelegateとUITableViewDataSourceに準拠
// extensionに切り出すと可読性が上がる
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 配列の要素数を返す
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // viewDidLoadで登録しておいたセルを取得
        // カスタムセルを取り出すときはキャストが必要(強制案ラップでOK)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RepositoryCell
        cell.set(repositoryName: data[indexPath.row].fullName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セル選択後に呼ばれる
        // 押されたセルの場所(indexPath)などに応じて処理を変えることができるが
        // 今回は必ずDetailViewControllerに遷移するように実装
        let repository = data[indexPath.row]
        let detailView = DetailViewController(repository: repository)
        
        // navigationController:画面遷移を司るクラス
        // pushViewController(_:animated:)で画面遷移できる
        navigationController?.pushViewController(detailView, animated: true)
    }
}
