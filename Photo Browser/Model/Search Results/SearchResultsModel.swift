//
//  FilteredResultsModel.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import Foundation

struct SearchResultsModel : Codable {
	let total : Int?
	let total_pages : Int?
	let results : [Model]?

	enum CodingKeys: String, CodingKey {

		case total = "total"
		case total_pages = "total_pages"
		case results = "results"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		total = try values.decodeIfPresent(Int.self, forKey: .total)
		total_pages = try values.decodeIfPresent(Int.self, forKey: .total_pages)
		results = try values.decodeIfPresent([Model].self, forKey: .results)
	}

}
