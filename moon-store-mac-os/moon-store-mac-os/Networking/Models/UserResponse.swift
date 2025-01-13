//
//  UserResponse.swift
//  moon-store-mac-os
//
// Created by Jose Luna on 3/1/25.
//

struct UserResponse: Decodable {
    let users: [UserModel]
    
    private enum CodingKeys: String, CodingKey {
        case users = "data"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.users = try container.decode([UserModel].self, forKey: .users)
    }
}
