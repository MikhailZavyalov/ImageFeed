
import Foundation
// MARK: - раскоментить закоменченное и сделать чтобы всё парсилось
// MARK: - и поменять url тип string на URL
// MARK: - разобраться с objectTaskArray

// MARK: - ImagesListResultElement
struct ImagesListResultElement: Codable {
    
    // MARK: - Urls
    struct Urls: Codable {
        let raw, full, regular, small: URL
        let thumb: URL
    }
    
    let id: String
    // MARK: - parse date from string swift
//    let createdAt: Date
    let width, height: Int
    let description: String?
    let urls: Urls
    let likedByUser: Bool
    //    let user: User?
    //    let currentUserCollections: [CurrentUserCollection]
    //    let links: ImagesListResultLinks?
    //    let color, blurHash: String
    //    let likes: Int
    //    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
//        case createdAt = "created_at"
        case width, height
        case description
        case urls
        case likedByUser = "liked_by_user"
        //        case links
        //        case updatedAt = "updated_at"
        //        case color
        //        case blurHash = "blur_hash"
        //        case user
        //        case currentUserCollections = "current_user_collections"
        //        case likes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
//        createdAt = try container.decode(Date.self, forKey: .createdAt)
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
        description = try? container.decode(String.self, forKey: .description)
        urls = try container.decode(Urls.self, forKey: .urls)
        likedByUser = try container.decode(Bool.self, forKey: .likedByUser)
        //        links = try? container.decode(ImagesListResultLinks.self, forKey: .links)
        //        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        //        color = try container.decode(String.self, forKey: .color)
        //        blurHash = try container.decode(String.self, forKey: .blurHash)
        //        likes = try container.decode(Int.self, forKey: .likes)
        //        user = try? container.decode(User.self, forKey: .user)
        //        currentUserCollections = try container.decode([CurrentUserCollection].self, forKey: .currentUserCollections)
    }
}

// MARK: - CurrentUserCollection
//struct CurrentUserCollection: Codable {
//    let id: Int
//    let title: String
////    let publishedAt, lastCollectedAt, updatedAt: Date
//    let coverPhoto, user: JSONNull?
//
//    enum CodingKeys: String, CodingKey {
//        case id, title
////        case publishedAt = "published_at"
////        case lastCollectedAt = "last_collected_at"
////        case updatedAt = "updated_at"
//        case coverPhoto = "cover_photo"
//        case user
//    }
//}

// MARK: - ImagesListResultLinks
//struct ImagesListResultLinks: Codable {
//    let linksSelf, html, download, downloadLocation: String
//
//    enum CodingKeys: String, CodingKey {
//        case linksSelf = "self"
//        case html, download
//        case downloadLocation = "download_location"
//    }
//}

// MARK: - User
//struct User: Codable {
//    let id, username, name: String
//    let portfolioURL: String
//    let bio, location: String?
//    let totalLikes, totalPhotos, totalCollections: Int
//    let instagramUsername, twitterUsername: String
//    let profileImage: ProfileImage
//    let links: UserLinks
//
//    enum CodingKeys: String, CodingKey {
//        case id, username, name
//        case portfolioURL = "portfolio_url"
//        case bio, location
//        case totalLikes = "total_likes"
//        case totalPhotos = "total_photos"
//        case totalCollections = "total_collections"
//        case instagramUsername = "instagram_username"
//        case twitterUsername = "twitter_username"
//        case profileImage = "profile_image"
//        case links
//    }
//}

// MARK: - UserLinks
//struct UserLinks: Codable {
//    let linksSelf, html, photos, likes: String
//    let portfolio: String
//
//    enum CodingKeys: String, CodingKey {
//        case linksSelf = "self"
//        case html, photos, likes, portfolio
//    }
//}

// MARK: - ProfileImage
//struct ProfileImage: Codable {
//    let small, medium, large: String
//}
//
//typealias ImagesListResult = [ImagesListResultElement]

// MARK: - Encode/decode helpers

//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
//
//    public var hashValue: Int {
//        return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}
//
