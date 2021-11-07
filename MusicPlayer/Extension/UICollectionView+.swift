//
//  UICollectionView+.swift
//  MusicPlayer
//
//  Created by 이재은 on 2021/11/03.
//

import UIKit

extension UICollectionView {

    /// 새로운 컬렉션뷰셀을 만드는 데에 사용할 클래스 등록
    func registerCell(withType type: UICollectionViewCell.Type) {
        let identifier = String(describing: type)
        register(type, forCellWithReuseIdentifier: identifier)
    }

    /// 지정된 재사용 식별자에 대해 재사용 가능한 컬렉션뷰셀을 반환하고 컬렉션뷰에 추가
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier,
                                             for: indexPath) as? T
        else {
            fatalError("Unable Dequeue Reusable CollectionViewCell")
        }
        return cell
    }
}
