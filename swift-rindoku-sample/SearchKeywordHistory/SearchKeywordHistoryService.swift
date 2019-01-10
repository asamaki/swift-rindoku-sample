//
//  SearchKeywordHistoryService.swift
//  swift-rindoku-sample
//
//  Created by SCI01254 on 2018/12/20.
//  Copyright © 2018 hicka04. All rights reserved.
//

import Foundation
import RealmSwift

class SearchKeywordHistoryService {
    let MAX_HISTORY_COUNT = 50
    let realm = try! Realm()

    func findAll() -> [SearchKeywordHistory]{
        return Array(realm.objects(SearchKeywordHistory.self).sorted(byKeyPath: "createdAt", ascending: false))
    }
    func findRecent() -> SearchKeywordHistory? {
        return realm.objects(SearchKeywordHistory.self).sorted(byKeyPath: "createdAt", ascending: false).first
    }
    func findAllCreatedAtSortAsc() -> [SearchKeywordHistory]{
        return Array(realm.objects(SearchKeywordHistory.self).sorted(byKeyPath: "createdAt", ascending: true))
    }
    func append(keyword: String) {
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
