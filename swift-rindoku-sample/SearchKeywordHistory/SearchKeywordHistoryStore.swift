//
//  SearchKeywordHistoryService.swift
//  swift-rindoku-sample
//
//  Created by SCI01254 on 2018/12/20.
//  Copyright © 2018 hicka04. All rights reserved.
//

import Foundation
import RealmSwift

// https://qiita.com/KeithYokoma/items/ee21fec6a3ebb5d1e9a8#%E3%83%87%E3%83%BC%E3%82%BF%E3%82%BD%E3%83%BC%E3%82%B9%E3%82%92%E5%8F%96%E3%82%8A%E6%89%B1%E3%81%86%E3%83%AC%E3%82%A4%E3%83%A4
// SearchKeywordHistoryStoreのほうが命名適切な気がします
class SearchKeywordHistoryStore {
    private let MAX_HISTORY_COUNT = 50
    private let realm = try! Realm()

    // 今、printしかしてませんが
    // DBのラップをするならば、Realmに依存しない配列にできるといいと思います
    // 仮にDBをRealmじゃないものにするときに
    // 使っている側(今回でいうListViewController)は変更する必要がなくなります
    func findAll() -> [SearchKeywordHistory] {
        return Array(realm.objects(SearchKeywordHistory.self).sorted(byKeyPath: "createdAt", ascending: false))
    }
    // 必要なのはキーワードだけなのでStringにしてあげるといいと思います
    func findRecentKeyword() -> String? {
        return realm.objects(SearchKeywordHistory.self).sorted(byKeyPath: "createdAt", ascending: false).first?.keyword
    }
    // これはappend(_:)でしか使っていないので
    // メソッド切り出ししなくてもいい気がします
    private func findAllCreatedAtSortAsc() -> Results<SearchKeywordHistory>{
        return realm.objects(SearchKeywordHistory.self).sorted(byKeyPath: "createdAt", ascending: true)
    }
    // 必要なのはキーワードだけなのでStringを受け取るようにしたらいいとおもいます
    func append(keyword: String) {
        // 50件を超えるときだけ削除するが、保存処理は必ず行うので
        // if-elseにしないほうがそれを表現できると思います
        let histories = findAllCreatedAtSortAsc()
        if histories.count >= MAX_HISTORY_COUNT {
            let deleteTarget = histories.first!
            try! realm.write() {
                realm.delete(deleteTarget)
            }
        }
        
        let searchKeywordHistory = SearchKeywordHistory()
        searchKeywordHistory.keyword = keyword
        try! realm.write() {
            realm.add(searchKeywordHistory)
        }
    }
}
