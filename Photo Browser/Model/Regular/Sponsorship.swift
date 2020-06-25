//
//  Sponsorship.swift
//  Photo Browser
//
//  Created by Rafael Lellys on 2020-06-19.
//  Copyright © 2020 Rafael Lellys. All rights reserved.
//

import Foundation

struct Sponsorship : Codable {
	let impressionUrls : [String]?
	let tagline : String?
	let taglineUrl : String?
	let sponsor : Sponsor?

	enum CodingKeys: String, CodingKey {

		case impressionUrls = "impression_urls"
		case tagline = "tagline"
		case taglineUrl = "tagline_url"
		case sponsor = "sponsor"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		impressionUrls = try values.decodeIfPresent([String].self, forKey: .impressionUrls)
		tagline = try values.decodeIfPresent(String.self, forKey: .tagline)
		taglineUrl = try values.decodeIfPresent(String.self, forKey: .taglineUrl)
		sponsor = try values.decodeIfPresent(Sponsor.self, forKey: .sponsor)
	}

}
