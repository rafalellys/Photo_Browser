//
//  Model.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import Foundation


struct Model : Codable {
	let id : String?
	let createdAt : String?
	let updatedAt : String?
	let promotedAt : String?
	let width : Int?
	let height : Int?
	let color : String?
	let description : String?
	let altDescription : String?
	let urls : Urls?
	let links : Links?
	let categories : [String]?
	let likes : Int?
	let likedByUser : Bool?
	let currentUserCollections : [String]?
	let sponsorship : Sponsorship?
	let user : User?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case createdAt = "created_at"
		case updatedAt = "updated_at"
		case promotedAt = "promoted_at"
		case width = "width"
		case height = "height"
		case color = "color"
		case description = "description"
		case altDescription = "alt_description"
		case urls = "urls"
		case links = "links"
		case categories = "categories"
		case likes = "likes"
		case likedByUser = "liked_by_user"
		case currentUserCollections = "current_user_collections"
		case sponsorship = "sponsorship"
		case user = "user"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
		promotedAt = try values.decodeIfPresent(String.self, forKey: .promotedAt)
		width = try values.decodeIfPresent(Int.self, forKey: .width)
		height = try values.decodeIfPresent(Int.self, forKey: .height)
		color = try values.decodeIfPresent(String.self, forKey: .color)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		altDescription = try values.decodeIfPresent(String.self, forKey: .altDescription)
		urls = try values.decodeIfPresent(Urls.self, forKey: .urls)
		links = try values.decodeIfPresent(Links.self, forKey: .links)
		categories = try values.decodeIfPresent([String].self, forKey: .categories)
		likes = try values.decodeIfPresent(Int.self, forKey: .likes)
		likedByUser = try values.decodeIfPresent(Bool.self, forKey: .likedByUser)
		currentUserCollections = try values.decodeIfPresent([String].self, forKey: .currentUserCollections)
		sponsorship = try values.decodeIfPresent(Sponsorship.self, forKey: .sponsorship)
		user = try values.decodeIfPresent(User.self, forKey: .user)
	}

}
