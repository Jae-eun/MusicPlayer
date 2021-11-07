//
//  UITableView+.swift
//  MusicPlayer
//
//  Created by 이재은 on 2021/11/03.
//

import UIKit

extension UITableView {

    /// 새로운 테이블뷰셀을 만드는 데에 사용할 클래스 등록
    func registerCell(withType type: UITableViewCell.Type) {
        let identifier = String(describing: type)
        register(type, forCellReuseIdentifier: identifier)
    }

    /// 지정된 재사용 식별자에 대해 재사용 가능한 테이블뷰셀을 반환하고 테이블뷰에 추가
    func dequeueCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        guard let cell = dequeueReusableCell(withIdentifier: identifier,
                                             for: indexPath) as? T
        else {
            fatalError("Unable Dequeue Reusable TableViewCell")
        }
        return cell
    }
}
