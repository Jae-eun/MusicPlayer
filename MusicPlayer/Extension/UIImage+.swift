//
//  UIImage+.swift
//  MusicPlayer
//
//  Created by 이재은 on 2021/11/07.
//

import UIKit

extension UIImage {
    /// SFSymbol 이름으로 이미지 생성
    convenience init?(symbol: SFSymbol) {
        self.init(systemName: symbol.rawValue)
    }
}
