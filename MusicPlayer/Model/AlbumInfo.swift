//
//  AlbumInfo.swift
//  MusicPlayer
//
//  Created by 이재은 on 2021/11/04.
//

import Foundation
import MediaPlayer

struct AlbumInfo {
    var albumTitle: String
    var albumArtist: String
    var albumArtwork: UIImage?
    var songs: [SongInfo]
}

struct SongInfo {
    var songId: String
    var trackNum: Int
    var songTitle: String
    var duration: TimeInterval
}
