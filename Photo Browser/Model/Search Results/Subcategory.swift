//
//  Subcategory.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import Foundation

struct Subcategory : Codable {
	let slug : String?
	let pretty_slug : String?

	enum CodingKeys: String, CodingKey {

		case slug = "slug"
		case pretty_slug = "pretty_slug"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		slug = try values.decodeIfPresent(String.self, forKey: .slug)
		pretty_slug = try values.decodeIfPresent(String.self, forKey: .pretty_slug)
	}

}
