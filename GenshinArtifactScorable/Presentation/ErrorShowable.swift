//
//  ErrorShowable.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/07/19.
//

import UIKit

protocol ErrorShowable: AnyObject {
}

extension ErrorShowable where Self: UIViewController {
    
    // MARK: - Public
    
    func showErrorBanner(_ error: Error) {
        
        if let apiError = error as? APIError {
            let message = apiError.message
            switch apiError {
            case .refreshTooFast(dateWhenRefreshable: _):
                MessageBanner.shared.warn(message: message)
            default:
                MessageBanner.shared.error(message: message)
            }
            return
        }
        
        if let appResourceError = error as? AppResourceError {
            let message = appResourceError.message
            MessageBanner.shared.error(message: message)
            return
        }
        
        if let dataStoreError = error as? DataStoreError {
            let message = dataStoreError.message
            MessageBanner.shared.error(message: message)
            return
        }
        
        MessageBanner.shared.error(message: "再度お試しください．繰り返し発生する場合はお問い合わせください．")
    }
}
