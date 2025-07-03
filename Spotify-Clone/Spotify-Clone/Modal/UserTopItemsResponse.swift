import Foundation

// MARK: - Welcome
struct UserTopItemsResponse: Codable {

    let items: [AudioTrack]
}

// MARK: - Item
struct Item: Codable {
    let album: Album2
    let artists: [Artist]
    let id: String
    let isPlayable: Bool
    let name: String
    let popularity: Int
    let trackNumber: Int
    let type, uri: String
    let isLocal: Bool
    
    enum CodingKeys: String, CodingKey {
        case album, artists
        case id
        case isPlayable = "is_playable"
        case name, popularity
        case trackNumber = "track_number"
        case type, uri
        case isLocal = "is_local"
    }
}

// MARK: - Album
struct Album2: Codable {
    let albumType: String
    let totalTracks: Int
    let availableMarkets: [String]
    let href: String
    let id: String
    let images: [APIImage]
    let name, releaseDate, releaseDatePrecision, type: String
    let uri: String
    let artists: [Artist]
    let isPlayable: Bool
    
    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case totalTracks = "total_tracks"
        case availableMarkets = "available_markets"
        case href, id, images, name
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case type, uri, artists
        case isPlayable = "is_playable"
    }
}

