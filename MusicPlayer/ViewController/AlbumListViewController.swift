//
//  AlbumListViewController.swift
//  MusicPlayer
//
//  Created by 이재은 on 2021/11/03.
//

import UIKit
import MediaPlayer

final class AlbumListViewController: UIViewController {

    // MARK: - UIComponent
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .systemBackground
        $0.registerCell(withType: AlbumCollectionViewCell.self)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.frame = .zero
        $0.showsHorizontalScrollIndicator = false

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let margin: CGFloat = 16
        $0.contentInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        let size = CGSize(width: (UIScreen.main.bounds.width - margin * 3) / 2 , height: 250)
        layout.itemSize = size
        $0.collectionViewLayout = layout
    }

    // MARK: - Property
    var albums: [AlbumInfo] = []

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        requestMediaLibraryAuthorization()
    }

    // MARK: - Congifure UI
    private func configureUI() {
        title = "앨범"

        view.addSubview(collectionView)
        setupNavigationBar()
        makeConstraint()
    }

    private func makeConstraint() {
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Function

    /// MediaLibrary 접근 권한 요청
    func requestMediaLibraryAuthorization() {
        PlayerService.requestMediaLibraryAuthorization { isGranted in
            if isGranted {
                self.albums = SongQuery().getAlbumList()
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } else {
                UIAlertController
                    .alert(title: "뮤직 앨범 접근 권한 요청",
                           message: "MusicPlayer 서비스를 사용하기 위해서\n 접근 권한을 허용해주세요.")
                    .action(title: "설정으로 이동") {  _ in
                        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }

                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                    }
                    .action(title: "닫기", style: .cancel)
                    .present(to: self)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension AlbumListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell: AlbumCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(albums[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension AlbumListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let detailViewController: DetailViewController = .init(with: albums[indexPath.item])
        navigationController?.pushViewController(detailViewController, animated: true)

        collectionView.deselectItem(at: indexPath, animated: false)
    }
}
