//
//  Category.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import Foundation

struct Category : Codable {
	let slug : String?
	let prettySlug : String?

	enum CodingKeys: String, CodingKey {

		case slug = "slug"
		case prettySlug = "pretty_slug"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		slug = try values.decodeIfPresent(String.self, forKey: .slug)
		prettySlug = try values.decodeIfPresent(String.self, forKey: .prettySlug)
	}

}
