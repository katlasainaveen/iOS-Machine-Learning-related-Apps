//
//  Model.swift
//  WhatFlower
//
//  Created by Sai Naveen Katla on 26/09/20.
//

import Foundation

struct Model: Codable {
    let query: Query
}

struct Query: Codable {
    let pageids: [Int]
    let pages: Pages
}

struct Pages: Codable {
    let ids: PageForID
}

struct PageForID: Codable {
    let extract: String
}

