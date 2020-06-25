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
	let totalPages : Int?
	let results : [Model]?

	enum CodingKeys: String, CodingKey {

		case total = "total"
		case totalPages = "total_pages"
		case results = "results"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		total = try values.decodeIfPresent(Int.self, forKey: .total)
		totalPages = try values.decodeIfPresent(Int.self, forKey: .totalPages)
		results = try values.decodeIfPresent([Model].self, forKey: .results)
	}

}
