//
//  UIView+.swift
//  MusicPlayer
//
//  Created by 이재은 on 2021/11/03.
//

import UIKit

extension UIView {

    /// 둥근 모서리 설정
    func setCornerRadius(_ cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
}
