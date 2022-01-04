//
//  Petition.swift
//  Project 7
//
//  Created by Eduard Tokarev on 03.01.2022.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
