//
//  Sponsor.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import Foundation

struct Sponsor : Codable {
	let id : String?
	let updated_at : String?
	let username : String?
	let name : String?
	let firstName : String?
	let lastName : String?
	let twitterUsername : String?
	let portfolioUrl : String?
	let bio : String?
	let location : String?
	let links : Links?
	let profileImage : ProfileImage?
	let instagramUsername : String?
	let totalCollections : Int?
	let totalLikes : Int?
	let totalPhotos : Int?
	let acceptedTos : Bool?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case updated_at = "updated_at"
		case username = "username"
		case name = "name"
		case firstName = "first_name"
		case lastName = "last_name"
		case twitterUsername = "twitter_username"
		case portfolioUrl = "portfolio_url"
		case bio = "bio"
		case location = "location"
		case links = "links"
		case profileImage = "profile_image"
		case instagramUsername = "instagram_username"
		case totalCollections = "total_collections"
		case totalLikes = "total_likes"
		case totalPhotos = "total_photos"
		case acceptedTos = "accepted_tos"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
		username = try values.decodeIfPresent(String.self, forKey: .username)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
		lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
		twitterUsername = try values.decodeIfPresent(String.self, forKey: .twitterUsername)
		portfolioUrl = try values.decodeIfPresent(String.self, forKey: .portfolioUrl)
		bio = try values.decodeIfPresent(String.self, forKey: .bio)
		location = try values.decodeIfPresent(String.self, forKey: .location)
		links = try values.decodeIfPresent(Links.self, forKey: .links)
		profileImage = try values.decodeIfPresent(ProfileImage.self, forKey: .profileImage)
		instagramUsername = try values.decodeIfPresent(String.self, forKey: .instagramUsername)
		totalCollections = try values.decodeIfPresent(Int.self, forKey: .totalCollections)
		totalLikes = try values.decodeIfPresent(Int.self, forKey: .totalLikes)
		totalPhotos = try values.decodeIfPresent(Int.self, forKey: .totalPhotos)
		acceptedTos = try values.decodeIfPresent(Bool.self, forKey: .acceptedTos)
	}

}
