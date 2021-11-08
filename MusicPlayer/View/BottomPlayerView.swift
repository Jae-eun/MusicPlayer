//
//  BottomPlayerView.swift
//  MusicPlayer
//
//  Created by 이재은 on 2021/11/07.
//

import UIKit

protocol BottomPlayerViewDelegate: AnyObject {
    func didTappedBottomPlayer()
}

final class BottomPlayerView: UIView {

    // MARK: - UIComponent
    private let progressView = UIProgressView().then {
        $0.progressViewStyle = .bar
        $0.tintColor = .systemMint
        $0.trackTintColor = .systemGray
        $0.setProgress(0.0, animated: true)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let hStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.isLayoutMarginsRelativeArrangement = true
        $0.spacing = 8
    }
    private let playButton = UIButton().then {
        $0.setImage(UIImage(symbol: .play), for: .normal)
        $0.setImage(UIImage(symbol: .pause), for: .selected)
        $0.addTarget(self, action: #selector(didTappedPlayButton), for: .touchUpInside)
        $0.tintColor = .label
    }
    private let vStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .fillProportionally
        $0.isLayoutMarginsRelativeArrangement = true
        $0.spacing = 3
    }
    private let albumNameLabel = UILabel().then {
        $0.textColor = .label
        $0.font = .boldSystemFont(ofSize: 15)
    }
    private let artistLabel = UILabel().then {
        $0.textColor = .systemGray
        $0.font = .systemFont(ofSize: 12)
    }
    private let albumImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.sizeToFit()
        $0.backgroundColor = .systemMint
        $0.setCornerRadius(3)
    }

    // MARK: - Property
    weak var delegate: BottomPlayerViewDelegate?
    private let player = PlayerService.shared.player
    
    
    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
        addGesture()
        setProperties()
        setPlayButtonState()
        addNotification()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup View
    private func configureUI() {
        backgroundColor = .systemBackground
        layer.opacity = 0.9

        [progressView, hStackView].forEach {
            addSubview($0)
        }
        [playButton, vStackView, albumImageView].forEach {
            hStackView.addArrangedSubview($0)
        }
        [albumNameLabel, artistLabel].forEach {
            vStackView.addArrangedSubview($0)
        }

        makeConstraint()
    }

    private func makeConstraint() {
        let margin: CGFloat = 16

        progressView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.centerX.equalToSuperview()
            $0.height.equalTo(3)
        }
        albumImageView.snp.makeConstraints {
            $0.width.height.equalTo(hStackView.snp.height).dividedBy(1.5)
        }
        hStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(margin)
            $0.trailing.equalToSuperview().inset(margin)
            $0.center.equalToSuperview()
            $0.height.equalTo(100)
        }
        playButton.snp.makeConstraints {
            $0.width.height.equalTo(albumImageView)
        }
    }

    // MARK: - Function
    @objc private func setProperties() {
        if let artwork = player.nowPlayingItem?.artwork {
            albumImageView.image = artwork.image(at: CGSize(width: 200, height: 200))
        }
        albumNameLabel.text = player.nowPlayingItem?.title ?? ""
        artistLabel.text = player.nowPlayingItem?.artist ?? ""
    }

    @objc private func setPlayButtonState() {
        playButton.isSelected = player.playbackState == .playing ? true : false
    }

    @objc private func didTappedPlayButton(_ sender: UIButton) {
        sender.isSelected.toggle()

        if sender.isSelected {
            PlayerService.shared.playCurrentSong()
        } else {
            PlayerService.shared.pause()
        }
    }

    private func addNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setProperties),
                                               name: .MPMusicPlayerControllerNowPlayingItemDidChange,
                                               object: player)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setPlayButtonState),
                                               name: .MPMusicPlayerControllerPlaybackStateDidChange,
                                               object: player)
    }

    private func addGesture() {
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                     action: #selector(tappedView(_:)))
        addGestureRecognizer(gesture)
    }

    @objc func tappedView(_ gesture: UITapGestureRecognizer) {
        delegate?.didTappedBottomPlayer()
    }
}
