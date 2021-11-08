//
//  AlbumCollectionViewCell.swift
//  MusicPlayer
//
//  Created by 이재은 on 2021/11/03.
//

import UIKit

/// 앨범 목록 컬렉션뷰셀
final class AlbumCollectionViewCell: UICollectionViewCell {

    // MARK: - UIComponent
    private let albumImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.setCornerRadius(8)
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
        $0.font = .boldSystemFont(ofSize: 18)
    }
    private let artistLabel = UILabel().then {
        $0.textColor = .systemGray
        $0.font = .systemFont(ofSize: 15)
    }

    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        albumImageView.image = nil
        albumNameLabel.text = nil
        artistLabel.text = nil
    }

    // MARK: - Setup View
    private func configureUI() {
        backgroundColor = .systemBackground

        [albumImageView, vStackView].forEach {
            contentView.addSubview($0)
        }
        [albumNameLabel, artistLabel].forEach {
            vStackView.addArrangedSubview($0)
        }
        makeConstraint()
    }

    private func makeConstraint() {
        albumImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(contentView)
            $0.width.height.equalTo(contentView.snp.width)
        }
        vStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentView)
            $0.top.equalTo(albumImageView.snp.bottom).offset(8)
            $0.bottom.equalTo(contentView).priority(.medium)
        }
    }

    // MARK: - Function
    func configure(_ data: AlbumInfo) {
        albumImageView.image = data.albumArtwork
        albumNameLabel.text = data.albumTitle
        artistLabel.text = data.albumArtist
    }
}
