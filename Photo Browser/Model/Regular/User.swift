//
//  User.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import Foundation

struct User : Codable {
	let id : String?
	let updated_at : String?
	let username : String?
	let name : String?
	let first_name : String?
	let last_name : String?
	let twitter_username : String?
	let portfolio_url : String?
	let bio : String?
	let location : String?
	let links : Links?
	let profileImage : ProfileImage?
	let instagram_username : String?
	let total_collections : Int?
	let total_likes : Int?
	let total_photos : Int?
	let accepted_tos : Bool?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case updated_at = "updated_at"
		case username = "username"
		case name = "name"
		case first_name = "first_name"
		case last_name = "last_name"
		case twitter_username = "twitter_username"
		case portfolio_url = "portfolio_url"
		case bio = "bio"
		case location = "location"
		case links = "links"
		case profileImage = "profile_image"
		case instagram_username = "instagram_username"
		case total_collections = "total_collections"
		case total_likes = "total_likes"
		case total_photos = "total_photos"
		case accepted_tos = "accepted_tos"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
		username = try values.decodeIfPresent(String.self, forKey: .username)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
		last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
		twitter_username = try values.decodeIfPresent(String.self, forKey: .twitter_username)
		portfolio_url = try values.decodeIfPresent(String.self, forKey: .portfolio_url)
		bio = try values.decodeIfPresent(String.self, forKey: .bio)
		location = try values.decodeIfPresent(String.self, forKey: .location)
		links = try values.decodeIfPresent(Links.self, forKey: .links)
		profileImage = try values.decodeIfPresent(ProfileImage.self, forKey: .profileImage)
		instagram_username = try values.decodeIfPresent(String.self, forKey: .instagram_username)
		total_collections = try values.decodeIfPresent(Int.self, forKey: .total_collections)
		total_likes = try values.decodeIfPresent(Int.self, forKey: .total_likes)
		total_photos = try values.decodeIfPresent(Int.self, forKey: .total_photos)
		accepted_tos = try values.decodeIfPresent(Bool.self, forKey: .accepted_tos)
	}

}
