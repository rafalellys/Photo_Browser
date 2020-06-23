//
//  UIImage+Extension.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-23.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import UIKit

extension UIImage {
    func renderWith(newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let image = renderer.image { _ in
            self.draw(in: CGRect.init(origin: CGPoint.zero, size: newSize))
        }
        return image.withRenderingMode(self.renderingMode)
    }
}
