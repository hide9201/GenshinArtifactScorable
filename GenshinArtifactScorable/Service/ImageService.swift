//
//  ImageService.swift
//  GenshinArtifactScorable
//
//  Created by hide on 2023/04/14.
//

import PromiseKit

struct ImageService {
    
    func fetchUIImage(imageName: String) -> Promise<UIImage> {
        return ImageAPI.shared.call(ImageTarget.fetchUIImage(imageName: imageName))
    }
}
