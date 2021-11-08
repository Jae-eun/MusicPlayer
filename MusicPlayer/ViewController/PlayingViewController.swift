//
//  PlayingViewController.swift
//  MusicPlayer
//
//  Created by 이재은 on 2021/11/07.
//

import UIKit
import MediaPlayer

final class PlayingViewController: UIViewController, PlayerProtocol {

    // MARK: - UIComponent
    private let albumImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.sizeToFit()
        $0.backgroundColor = .systemMint
        $0.setCornerRadius(16)
    }
    private let hStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fillEqually
        $0.isLayoutMarginsRelativeArrangement = true
        $0.spacing = 8
    }
    private let repeatButton = UIButton().then {
        $0.setImage(UIImage(symbol: .repeatAll), for: .normal)
        $0.addTarget(self, action: #selector(didTappedRepeatButton), for: .touchUpInside)
        $0.tintColor = .label
    }
    private let backwardButton = UIButton().then {
        $0.setImage(UIImage(symbol: .backward), for: .normal)
        $0.addTarget(self, action: #selector(didTappedBackwardButton), for: .touchUpInside)
        $0.tintColor = .label
    }
    private let playButton = UIButton().then {
        $0.setImage(UIImage(symbol: .play), for: .normal)
        $0.setImage(UIImage(symbol: .pause), for: .selected)
        $0.addTarget(self, action: #selector(didTappedPlayButton), for: .touchUpInside)
        $0.tintColor = .label
    }
    private let forwardButton = UIButton().then {
        $0.setImage(UIImage(symbol: .forward), for: .normal)
        $0.addTarget(self, action: #selector(didTappedForwardButton), for: .touchUpInside)
        $0.tintColor = .label
    }
    private let shuffleButton = UIButton().then {
        $0.setImage(UIImage(symbol: .shuffle), for: .normal)
        $0.setImage(UIImage(symbol: .shuffle), for: .selected)
        $0.addTarget(self, action: #selector(didTappedShuffleButton), for: .touchUpInside)
        $0.tintColor = .label
    }
    private let volumeView = UIView().then {
        $0.backgroundColor = .clear
        $0.tintColor = .systemMint
        $0.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 64, height: 20)
    }
    private let progressView = UIProgressView().then {
        $0.progressViewStyle = .bar
        $0.tintColor = .systemMint
        $0.trackTintColor = .systemGray
        $0.setProgress(0.0, animated: true)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Property
    private let player = PlayerService.shared.player
    private var duration: Float = 0.0
    private var timer: Timer?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        makeConstraint()
        setProperties()
        setButtonState()
        timer = addTimer(#selector(setProgress))
        addNotification(player, #selector(setProperties), #selector(setButtonState))
    }

    // MARK: - Setup UI
    private func configureUI() {
        view.backgroundColor = .systemBackground
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                                  target: self,
                                                  action: #selector(didTappedCloseButton))
        navigationItem.leftBarButtonItem = closeButton

        volumeView.addSubview(MPVolumeView(frame: volumeView.bounds))
        [albumImageView, hStackView, volumeView, progressView].forEach {
            view.addSubview($0)
        }
        [repeatButton, backwardButton, playButton, forwardButton, shuffleButton].forEach {
            hStackView.addArrangedSubview($0)
        }
    }

    private func makeConstraint() {
        let margin: CGFloat = 16

        albumImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(margin)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(UIScreen.main.bounds.width - margin * 4)
        }
        hStackView.snp.makeConstraints {
            $0.top.equalTo(albumImageView.snp.bottom).offset(margin * 3)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalTo(albumImageView)
        }
        volumeView.snp.makeConstraints {
            $0.width.equalTo(albumImageView.snp.width)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(hStackView.snp.bottom).offset(margin * 3)
            $0.bottom.equalTo(progressView.snp.top).offset(margin * 2).priority(.medium)
        }
        [repeatButton, backwardButton, playButton, forwardButton, shuffleButton].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(hStackView)
            }
        }
        progressView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(3)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    // MARK: - Function
    @objc private func setProperties() {
        navigationController?.navigationBar.items?.last?.setTitle(player.nowPlayingItem?.title ?? "",
                                                                  subtitle: player.nowPlayingItem?.artist ?? "")
        if let artwork = player.nowPlayingItem?.artwork {
            albumImageView.image = artwork.image(at: CGSize(width: 200, height: 200))
        }
        progressView.setProgress(0, animated: false)
        duration = Float(player.nowPlayingItem?.playbackDuration ?? 0.0)
    }

    @objc private func setButtonState() {
        playButton.isSelected = player.playbackState == .playing ? true : false
        repeatButton.isSelected = player.repeatMode == .all ? true : false
        shuffleButton.isSelected = player.shuffleMode == .songs ? true : false

        repeatButton.tintColor = repeatButton.isSelected ? .systemMint : .label
        shuffleButton.tintColor = shuffleButton.isSelected ? .systemMint : .label
    }

    @objc private func didTappedRepeatButton(_ sender: UIButton) {
        PlayerService.shared.setRepeatState()
    }

    @objc private func didTappedBackwardButton(_ sender: UIButton) {
        PlayerService.shared.changeBackwardSong()
    }

    @objc private func didTappedPlayButton(_ sender: UIButton) {
        setPlayState(sender)
    }

    @objc private func didTappedForwardButton(_ sender: UIButton) {
        PlayerService.shared.changeForwardSong()
    }

    @objc private func didTappedShuffleButton(_ sender: UIButton) {
        PlayerService.shared.setShuffleState()
    }

    @objc private func didTappedCloseButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    @objc private func setProgress() {
        progressView.setProgress(Float(player.currentPlaybackTime) / duration, animated: false)
    }
}
