//
//  SearchHistoryTableViewCell.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/06/04.
//

import UIKit
import ReusableKit

final class SearchHistoryTableViewCell: UITableViewCell {
    static let reusable = ReusableCell<SearchHistoryTableViewCell>(nibName: "SearchHistoryTableViewCell")
    
    @IBOutlet weak var profileIconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var uidLabel: UILabel!
}

extension SearchHistoryTableViewCell: NibInstantiatable {
    func inject(_ dependency: (shapedAccountAllInfo: ShapedAccountAllInfo, profileIcon: UIImage?)) {
        profileIconImageView.image = dependency.profileIcon
        userNameLabel.text = dependency.shapedAccountAllInfo.playerBasicInfo.playerName
        uidLabel.text = "UID \(dependency.shapedAccountAllInfo.uid)"
    }
}
