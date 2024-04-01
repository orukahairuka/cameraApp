//
//  UIImageExtension.swift
//  camera12345
//
//  Created by 櫻井絵理香 on 2024/04/01.
//

import Foundation
import UIKit

extension UIImage {
    func resized() -> UIImage? {
        let rate = 1024.0 / self.size.width
        let rect = CGRect(x: 0, y: 0, width: self.size.width * rate, height: self.size.height * rate)

        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()

UIGraphicsEndImageContext()
        return image
    }
}
