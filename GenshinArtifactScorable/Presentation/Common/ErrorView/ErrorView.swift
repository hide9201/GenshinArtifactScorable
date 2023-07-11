//
//  ErrorView.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/07/05.
//

import UIKit

final class ErrorView: UIView {
    
    // MARK: - Private
    
    private var refreshButtonHandler: (() -> Void)?
    
    // MARK: - Public
    
    func setRefreshButtonHandler(handler: @escaping () -> Void) {
        self.refreshButtonHandler = handler
    }
    
    // MARK: - Action
    
    @IBAction func refreshButtonDidTap(_ sender: Any) {
        refreshButtonHandler?()
    }
}

extension ErrorView: NibInstantiatable {
    func inject(_ dependency: ()) {
    }
}
