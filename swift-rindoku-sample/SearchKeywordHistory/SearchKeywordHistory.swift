//
//  SearchKeywordHistory.swift
//  swift-rindoku-sample
//
//  Created by SCI01254 on 2018/12/06.
//  Copyright © 2018 hicka04. All rights reserved.
//

import RealmSwift

class SearchKeywordHistory: Object{
    @objc dynamic var keyword: String = ""
    @objc dynamic var createdAt: Date = Date()
}
