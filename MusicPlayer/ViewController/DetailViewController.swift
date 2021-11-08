//
//  DetailViewController.swift
//  MusicPlayer
//
//  Created by 이재은 on 2021/11/03.
//

import UIKit
import MediaPlayer

final class DetailViewController: PlayerBaseViewController {

    // MARK: - UIComponent
    private let albumImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.sizeToFit()
        $0.setCornerRadius(5)
    }
    private let vStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fillProportionally
        $0.isLayoutMarginsRelativeArrangement = true
        $0.spacing = 3
    }
    private let albumNameLabel = UILabel().then {
        $0.textColor = .label
        $0.font = .boldSystemFont(ofSize: 22)
    }
    private let artistLabel = UILabel().then {
        $0.textColor = .systemGray
        $0.font = .systemFont(ofSize: 18)
    }
    private let hStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fillEqually
        $0.isLayoutMarginsRelativeArrangement = true
        $0.spacing = 16
    }
    private let playButton = UIButton().then {
        $0.setImage(UIImage(symbol: .play), for: .normal)
        $0.addTarget(self, action: #selector(didTappedPlayButton), for: .touchUpInside)
        $0.backgroundColor = .systemMint
        $0.tintColor = .systemBackground
        $0.setCornerRadius(8)
    }
    private let shuffleButton = UIButton().then {
        $0.setImage(UIImage(symbol: .shuffle), for: .normal)
        $0.addTarget(self, action: #selector(didTappedShuffleButton), for: .touchUpInside)
        $0.backgroundColor = .systemMint
        $0.tintColor = .systemBackground
        $0.setCornerRadius(8)
    }
    private let headerView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .systemBackground
    }
    lazy var tableView: UITableView = UITableView().then {
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .systemBackground
        $0.estimatedRowHeight = 50
        $0.separatorStyle = .singleLine
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
        $0.registerCell(withType: SongTableViewCell.self)
        $0.tableFooterView = UIView(frame: .zero)
    }

    // MARK: - Property
    private let albumInfo: AlbumInfo
    private var songInfos: [SongInfo]

    // MARK: - Initialize
    init(with albumInfo: AlbumInfo) {
        self.albumInfo = albumInfo
        songInfos = albumInfo.songs

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        setProperties()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.prefersLargeTitles = false
    }

    // MARK: - Setup UI
    private func configureUI() {
        [headerView, tableView].forEach {
            view.addSubview($0)
        }
        [albumImageView, vStackView, hStackView].forEach {
            headerView.addSubview($0)
        }
        [albumNameLabel, artistLabel].forEach {
            vStackView.addArrangedSubview($0)
        }
        [playButton, shuffleButton].forEach {
            hStackView.addArrangedSubview($0)
        }
        setConstraint()
    }

    private func setConstraint() {
        let margin: CGFloat = 16

        headerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(240)
        }
        albumImageView.snp.makeConstraints {
            $0.top.leading.equalTo(headerView).inset(margin)
            $0.width.height.equalTo(UIScreen.main.bounds.width / 3)
        }
        vStackView.snp.makeConstraints {
            $0.leading.equalTo(albumImageView.snp.trailing).offset(margin)
            $0.trailing.equalTo(headerView).inset(margin)
            $0.top.equalTo(albumImageView)

        }
        hStackView.snp.makeConstraints {
            $0.top.equalTo(albumImageView.snp.bottom).offset(margin)
            $0.leading.trailing.bottom.equalTo(headerView).inset(margin)
        }
        [playButton, shuffleButton].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(hStackView).dividedBy(1.5)
            }
        }
        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(headerView.snp.bottom)
        }
    }
    
    // MARK: - Function
    private func setProperties() {
        albumImageView.image = albumInfo.albumArtwork
        albumNameLabel.text = albumInfo.albumTitle
        artistLabel.text = albumInfo.albumArtist
    }

    @objc func didTappedPlayButton(_ sender: UIButton) {
        PlayerService.shared.playSongList(songInfos, at: 0)
        showBottomPlayer()
    }

    @objc func didTappedShuffleButton(_ sender: UIButton) {
        PlayerService.shared.playShuffleSongList(songInfos)
        showBottomPlayer()
    }
}

// MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {

        return songInfos.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: SongTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.setProperties(songInfos[indexPath.row])

        return cell
    }
}

// MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {

        PlayerService.shared.playSongList(songInfos, at: indexPath.row)
        showBottomPlayer()
    }
}
