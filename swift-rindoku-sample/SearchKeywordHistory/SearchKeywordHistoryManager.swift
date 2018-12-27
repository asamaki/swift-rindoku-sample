//
//  SearchKeywordHistoryManager.swift
//  swift-rindoku-sample
//
//  Created by SCI01254 on 2018/12/06.
//  Copyright © 2018 hicka04. All rights reserved.
//

//import Foundation
//
//enum UserDefaulsKey: String {
//    case SearchKeywordHistory
//}
//
//struct SearchKeywordHistoryManager {
//
//    private let userDefaults = UserDefaults.standard
//
//    func load() -> SearchKeywordHistory? {
//        guard let data = userDefaults.data(forKey: UserDefaulsKey.SearchKeywordHistory.rawValue) else {
//            return nil
//        }
//        return try? JSONDecoder().decode(SearchKeywordHistory.self, from: data)
//    }
//
//    func append(searchKeywordHistory:SearchKeywordHistory){
//        let data = try? JSONEncoder().encode(searchKeywordHistory)
//        userDefaults.set(data, forKey: UserDefaulsKey.SearchKeywordHistory.rawValue)
//    }
//}
