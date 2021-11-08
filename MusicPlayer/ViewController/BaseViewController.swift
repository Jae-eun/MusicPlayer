//
//  BaseViewController.swift
//  MusicPlayer
//
//  Created by 이재은 on 2021/11/08.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if PlayerService.shared.player.nowPlayingItem != nil {
            showBottomPlayer()
        }
    }

    // MARK: - Setup UI
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.backgroundColor = .systemBackground
    }

    // MARK: - Function
    /// 하단 플레이어 표시
     func showBottomPlayer() {
        let player = BottomPlayerView()
        view.addSubview(player)
        player.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(120)
        }

        player.delegate = self
    }
}

// MARK: - BottomPlayerViewDelegate
extension BaseViewController: BottomPlayerViewDelegate {

    func didTappedBottomPlayer() {
        let naviCon = UINavigationController(rootViewController: PlayingViewController())
        present(naviCon, animated: true)
    }
}
