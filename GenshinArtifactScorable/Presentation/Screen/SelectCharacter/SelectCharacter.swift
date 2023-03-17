//
//  SelectCharacter.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/03/17.
//

import UIKit

final class SelectCharacterViewController: UIViewController {
    
    private var uid: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(uid!)
    }
}

extension SelectCharacterViewController: Storyboardable {
    func inject(_ dependency: String) {
        uid = dependency
    }
}
