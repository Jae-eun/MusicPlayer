//
//  PlayerProtocol.swift
//  MusicPlayer
//
//  Created by 이재은 on 2021/11/09.
//

import UIKit
import MediaPlayer

protocol PlayerProtocol {
    func setPlayState(_ sender: UIButton)
    func addNotification(_ player: MPMusicPlayerController,
                         _ selector1: Selector,
                         _ selector2: Selector)
    func addTimer(_ selector: Selector) -> Timer
}

extension PlayerProtocol {
    func setPlayState(_ sender: UIButton) {
        sender.isSelected.toggle()

        if sender.isSelected {
            PlayerService.shared.playCurrentSong()
        } else {
            PlayerService.shared.pause()
        }
    }

    func addNotification(_ player: MPMusicPlayerController,
                         _ selector1: Selector,
                         _ selector2: Selector) {
        NotificationCenter.default.addObserver(self,
                                               selector: selector1,
                                               name: .MPMusicPlayerControllerNowPlayingItemDidChange,
                                               object: player)
        NotificationCenter.default.addObserver(self,
                                               selector: selector2,
                                               name: .MPMusicPlayerControllerPlaybackStateDidChange,
                                               object: player)
    }

    func addTimer(_ selector: Selector) -> Timer {
        return Timer.scheduledTimer(timeInterval: 0.01,
                                    target: self,
                                    selector: selector,
                                    userInfo: nil,
                                    repeats: true)
    }
}
