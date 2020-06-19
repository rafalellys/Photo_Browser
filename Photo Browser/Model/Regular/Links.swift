//
//  Links.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import Foundation

struct Links : Codable {
	let linkSelf : String?
	let html : String?
	let photos : String?
	let likes : String?
	let portfolio : String?
	let following : String?
	let followers : String?

	enum CodingKeys: String, CodingKey {

		case linkSelf = "self"
		case html = "html"
		case photos = "photos"
		case likes = "likes"
		case portfolio = "portfolio"
		case following = "following"
		case followers = "followers"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		linkSelf = try values.decodeIfPresent(String.self, forKey: .linkSelf)
		html = try values.decodeIfPresent(String.self, forKey: .html)
		photos = try values.decodeIfPresent(String.self, forKey: .photos)
		likes = try values.decodeIfPresent(String.self, forKey: .likes)
		portfolio = try values.decodeIfPresent(String.self, forKey: .portfolio)
		following = try values.decodeIfPresent(String.self, forKey: .following)
		followers = try values.decodeIfPresent(String.self, forKey: .followers)
	}

}
