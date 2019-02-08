//
//  Bookmark.swift
//  swift-rindoku-sample
//
//  Created by SCI01254 on 2019/02/07.
//  Copyright © 2019 hicka04. All rights reserved.
//

import RealmSwift

class Bookmark: Object{
    @objc dynamic var repository: Repository?
    @objc dynamic var createdAt: Date = Date()
}
