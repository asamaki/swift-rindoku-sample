//
//  BookmarkService.swift
//  swift-rindoku-sample
//
//  Created by SCI01254 on 2019/02/07.
//  Copyright © 2019 hicka04. All rights reserved.
//

import RealmSwift

class BookmarkService {
    let MAX_COUNT = 50
    let realm = try! Realm()
    
    func findAll() -> [Bookmark]{
        return Array(findAllRealmObject())
    }
    private func findAllRealmObject() -> Results<Bookmark>{
        return realm.objects(Bookmark.self).sorted(byKeyPath: "createdAt", ascending: false)
    }
    func append(repository: Repository) {
        let bookmark = Bookmark()
        bookmark.repository = repository
        try! realm.write() {
            realm.add(bookmark)
        }
    }
    func remove(repository: Repository) {
        guard let result = find(repository: repository) else {
            return
        }
        let bookmark = findAllRealmObject().filter("repository.id == %@", result.id)
        try! realm.write() {
            realm.delete(bookmark)
        }
    }
    func find(repository: Repository) -> Repository? {
        return realm.object(ofType: Repository.self, forPrimaryKey: repository.id)
    }
    func isBookmarked(repository: Repository) -> Bool{
        let result = find(repository: repository)
        guard let _ = result else {
            return false
        }
        return true
    }
}
