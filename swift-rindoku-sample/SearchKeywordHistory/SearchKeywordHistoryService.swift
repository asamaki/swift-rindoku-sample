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

    func findAll() -> Results<SearchKeywordHistory>{
        return realm.objects(SearchKeywordHistory.self).sorted(byKeyPath: "createdAt", ascending: false)
    }
    func findRecent() -> SearchKeywordHistory? {
        return realm.objects(SearchKeywordHistory.self).sorted(byKeyPath: "createdAt", ascending: false).first
    }
    func findAllCreatedAtSortAsc() -> Results<SearchKeywordHistory>{
        return realm.objects(SearchKeywordHistory.self).sorted(byKeyPath: "createdAt", ascending: true)
    }
    func append(searchKeywordHistory: SearchKeywordHistory) {
        let histories = findAllCreatedAtSortAsc()
        if histories.count >= MAX_HISTORY_COUNT {
            let deleteTarget = histories.first!
            try! realm.write() {
                realm.delete(deleteTarget)
                realm.add(searchKeywordHistory)
            }
        } else {
            try! realm.write() {
                realm.add(searchKeywordHistory)
            }
        }
    }
}
