//
//  SongTableViewCell.swift
//  MusicPlayer
//
//  Created by 이재은 on 2021/11/06.
//

import UIKit

final class SongTableViewCell: UITableViewCell {

    // MARK: - UIComponent
    private let orderLabel = UILabel().then {
        $0.textColor = .systemGray
        $0.font = .boldSystemFont(ofSize: 15)
        $0.textAlignment = .right
        $0.adjustsFontSizeToFitWidth = true
    }
    private let songNameLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 15)
        $0.textAlignment = .left
    }

    // MARK: - Property
    private let margin: CGFloat = 16

    // MARK: - Initialize
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        orderLabel.text = nil
        songNameLabel.text = nil
    }

    // MARK: - Setup View
    private func configureUI() {
        backgroundColor = .white
        selectionStyle = .none

        [orderLabel, songNameLabel].forEach {
            contentView.addSubview($0)
        }

        makeConstraint()
    }

    private func makeConstraint() {
        orderLabel.snp.makeConstraints {
            $0.centerY.equalTo(contentView)
            $0.leading.equalTo(contentView.snp.leading).inset(margin)
            $0.width.equalTo(UIScreen.main.bounds.width / 10)
        }
        songNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(contentView)
            $0.leading.equalTo(orderLabel.snp.trailing).offset(margin)
            $0.trailing.equalTo(contentView.snp.trailing).inset(margin * 2)
        }
    }

    // MARK: - Function
    func setProperties(_ data: SongInfo) {
        orderLabel.text = String(data.trackNum)
        songNameLabel.text = data.songTitle
    }
}
