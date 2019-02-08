//
//  RepositoryCell.swift
//  swift-rindoku-sample
//
//  Created by SCI01552 on 2018/10/04.
//  Copyright © 2018年 hicka04. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {

    // カスタムViewの中に置いているSubViewはprivateにするのがおすすめ
    // 外から触れるとどこで見た目の変化を行っているのかの影響範囲が広くなってしまうため
    @IBOutlet private weak var label: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    var bookmarkService = BookmarkService()
    var isBookmarked: Bool = false {
        didSet {
            if isBookmarked {
                bookmarkButton.setImage(UIImage(named: "favorites-series-color.png"), for: .normal)
            } else {
                bookmarkButton.setImage(UIImage(named: "favorites-series-gray.png"), for: .normal)
            }
        }
    }
    var repository: Repository?
    
    @IBAction func buttonTapped(sender:AnyObject) {
        if isBookmarked == false {
            isBookmarked = true
            bookmarkService.append(repository: repository!)
        } else {
            isBookmarked = false
            bookmarkService.remove(repository: repository!)
        }
        let list = bookmarkService.findAll()
        print(list)
    }
    
    func set(repository : Repository) {
        label.text = repository.fullName
        self.repository = repository
        if bookmarkService.isBookmarked(repository: repository) {
            isBookmarked = true
        } else {
            isBookmarked = false
        }
        
    }
}
