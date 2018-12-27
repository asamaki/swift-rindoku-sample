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
    let realm = try! Realm()

    func findAll() -> Results<SearchKeywordHistory>{
        return realm.objects(SearchKeywordHistory.self).sorted(byKeyPath: "createdAt", ascending: false)
    }
    func findRecent() -> SearchKeywordHistory? {
        return realm.objects(SearchKeywordHistory.self).sorted(byKeyPath: "createdAt", ascending: false).first
    }
    func append(searchKeywordHistory: SearchKeywordHistory) {
        try! realm.write() {
            realm.add(searchKeywordHistory)
        }
    }
}
