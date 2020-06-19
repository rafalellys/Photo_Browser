//
//  Source.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import Foundation

struct Source : Codable {
	let ancestry : Ancestry?
	let title : String?
	let subtitle : String?
	let description : String?
	let meta_title : String?
	let meta_description : String?
	let coverPhoto : CoverPhoto?

	enum CodingKeys: String, CodingKey {

		case ancestry = "ancestry"
		case title = "title"
		case subtitle = "subtitle"
		case description = "description"
		case meta_title = "meta_title"
		case meta_description = "meta_description"
		case coverPhoto = "cover_photo"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		ancestry = try values.decodeIfPresent(Ancestry.self, forKey: .ancestry)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		subtitle = try values.decodeIfPresent(String.self, forKey: .subtitle)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		meta_title = try values.decodeIfPresent(String.self, forKey: .meta_title)
		meta_description = try values.decodeIfPresent(String.self, forKey: .meta_description)
		coverPhoto = try values.decodeIfPresent(CoverPhoto.self, forKey: .coverPhoto)
	}

}
