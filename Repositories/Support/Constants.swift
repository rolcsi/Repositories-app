//
//  Constants.swift
//  Repositories
//
//  Created by Roland Beke on 14/11/2017.
//  Copyright © 2017 Roland Beke. All rights reserved.
//

import UIKit

enum Constants {

    static let api = "https://api.github.com"
    private static let searchOrgsPre = "/search/users?q="
    private static let searchOrgsPost = "&per_page=10" //"+type:org&per_page=10"

    static func searchOrgUrl(for name: String?) -> URL? {

        guard let name = name else { return nil }

        let urlString = api + searchOrgsPre + name + searchOrgsPost
        return URL(string: urlString)
    }
}
