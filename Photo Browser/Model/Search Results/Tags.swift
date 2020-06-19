//
//  Tags.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import Foundation

struct Tags : Codable {
	let type : String?
	let title : String?
	let source : Source?

	enum CodingKeys: String, CodingKey {

		case type = "type"
		case title = "title"
		case source = "source"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		source = try values.decodeIfPresent(Source.self, forKey: .source)
	}

}
