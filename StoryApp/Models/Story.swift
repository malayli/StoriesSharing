import Foundation

struct Story: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let profilePictureURL: String
    var seen: Bool = false
    var liked: Bool = false

    enum CodingKeys: String, CodingKey {
        case id, name
        case profilePictureURL = "profile_picture_url"
    }
}
