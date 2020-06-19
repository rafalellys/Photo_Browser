//
//  Ancestry.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import Foundation

struct Ancestry : Codable {
	let type : Type?
	let category : Category?
	let subcategory : Subcategory?

	enum CodingKeys: String, CodingKey {

		case type = "type"
		case category = "category"
		case subcategory = "subcategory"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		type = try values.decodeIfPresent(Type.self, forKey: .type)
		category = try values.decodeIfPresent(Category.self, forKey: .category)
		subcategory = try values.decodeIfPresent(Subcategory.self, forKey: .subcategory)
	}

}
