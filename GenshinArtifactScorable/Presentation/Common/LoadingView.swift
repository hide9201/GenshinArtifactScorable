//
//  LoadingView.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/06/20.
//

import UIKit

final class LoadingView: UIView {
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    func startLoading() {
        isUserInteractionEnabled = false
        indicatorView.startAnimating()
    }
    
    func stopLoading() {
        isUserInteractionEnabled = true
        indicatorView.stopAnimating()
    }
}

extension LoadingView: NibInstantiatable {
    func inject(_ dependency: ()) {
    }
}
