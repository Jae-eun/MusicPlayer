//
//  UIAlertController+.swift
//  MusicPlayer
//
//  Created by 이재은 on 2021/11/07.
//

import UIKit

extension UIAlertController {

  static func alert(title: String?,
                    message: String?,
                    style: UIAlertController.Style = .alert) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: style)
    return alert
  }

  func action(title: String?,
              style: UIAlertAction.Style = .default,
              completion: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
      let action = UIAlertAction(title: title, style: style) { completion?($0) }
      addAction(action)
      return self
  }

  func present(to viewController: UIViewController?,
               animated: Bool = true,
               completion: (() -> Void)? = nil) {
    DispatchQueue.main.async {
        viewController?.present(self, animated: animated, completion: completion)
    }
  }
}
