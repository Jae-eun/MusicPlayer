//
//  PlayerService.swift
//  MusicPlayer
//
//  Created by 이재은 on 2021/11/07.
//

import Foundation
import MediaPlayer

protocol PlayerServiceType: AnyObject {
    /// MediaLibrary 접근 권한 요청
    static func requestMediaLibraryAuthorization(completion: @escaping (_ isGranted: Bool) -> Void)
    /// 앨범 목록 가져오기
    func getAlbumList() -> [AlbumInfo]
    /// 현재 곡 재생 
    func playCurrentSong()
    /// 플레이리스트 재생
    func playSongList(_ songInfos: [SongInfo], at index: Int)
    /// 임의 순서 재생
    func playShuffleSongList(_ songInfos: [SongInfo])
    /// 곡 재생 멈춤
    func pause()
    /// 반복 재생 상태 설정
    func setRepeatState()
    /// 랜덤 재생 상태 설정
    func setShuffleState()
    /// 다음 곡 재생 
    func changeBackwardSong()
    /// 이전 곡 재생
    func changeForwardSong()
}

final class PlayerService: PlayerServiceType {

    // MARK: - Singleton
    static let shared = PlayerService()

    // MARK: - Property
    let player = MPMusicPlayerController.applicationMusicPlayer

    // MARK: - Initialize
    private init() {}

    // MARK: - Function
    static func requestMediaLibraryAuthorization(completion: @escaping (_ isGranted: Bool) -> Void) {

        switch  MPMediaLibrary.authorizationStatus() {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            MPMediaLibrary.requestAuthorization { status in
                if status == .authorized {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        default:
            completion(false)
        }
    }

    func getAlbumList() -> [AlbumInfo] {
        var albumInfos: [AlbumInfo] = []
        guard let albumItems = MPMediaQuery.albums().collections else {
            return []
        }

        for album in albumItems {
            let albumItems: [MPMediaItem] = album.items

            var songs: [SongInfo] = []

            let albumTitle = albumItems[0].albumTitle ?? ""
            let albumArtist = albumItems[0].albumArtist ?? ""
            var albumartwork: UIImage?

            for song in albumItems {
                if let artwork = song.artwork {
                    albumartwork = artwork.image(at: CGSize(width: 200, height: 200))
                }
                let songInfo = SongInfo(songId: song.playbackStoreID,
                                        trackNum: song.albumTrackNumber,
                                        songTitle: song.title ?? "",
                                        duration: song.playbackDuration)
                songs.append(songInfo)
            }

            let albumInfo = AlbumInfo(albumTitle: albumTitle,
                                      albumArtist: albumArtist,
                                      albumArtwork: albumartwork,
                                      songs: songs)
            albumInfos.append(albumInfo)
        }

        player.prepareToPlay()
        player.repeatMode = .none
        return albumInfos
    }

    func playCurrentSong() {
        player.play()
    }

    func playSongList(_ songInfos: [SongInfo], at index: Int) {
        player.shuffleMode = .off
        let songIds = (songInfos[index...] + songInfos[0..<index]).map { $0.songId }
        player.setQueue(with: songIds)
        player.play()
    }

    func playShuffleSongList(_ songInfos: [SongInfo]) {
        let songIds = songInfos.map { $0.songId }
        player.setQueue(with: songIds)
        player.shuffleMode = .songs
        player.play()
    }

    func pause() {
        player.stop()
    }

    func setRepeatState() {
        if player.repeatMode == .none {
            player.repeatMode = .all
        } else {
            player.repeatMode = .none
        }
    }

    func setShuffleState() {
        if player.shuffleMode == .off {
            player.shuffleMode = .songs
        } else {
            player.shuffleMode = .off
        }
    }

    func changeBackwardSong() {
        if player.playbackState == .paused
            || player.indexOfNowPlayingItem == NSNotFound {
            player.skipToPreviousItem()
        } else {
            player.pause()
            player.skipToPreviousItem()
            player.prepareToPlay()
            player.play()
        }
    }

    func changeForwardSong() {
        if player.playbackState == .paused
            || player.indexOfNowPlayingItem == NSNotFound {
            player.skipToNextItem()
        } else {
            player.pause()
            player.skipToNextItem()
            player.prepareToPlay()
            player.play()
        }
    }
}
