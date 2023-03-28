//
//  UIImage+.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/03/23.
//

import UIKit

extension UIImage {
    public convenience init(url: String) {
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            self.init(data: data)!
            return
        } catch let error {
            print("Error : \(error.localizedDescription)")
        }
        self.init()
    }
}
