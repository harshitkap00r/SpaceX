//
//  Data.swift
//  SpaceX
//
//  Created by Get My Parking on 02/02/22.
//

import Foundation


//This one use for ViewController
struct AllRocketData: Codable {
    let name: String
    let id: String
    let success: Bool?
}


//Below this one use for DetailsViewController
struct SpecificRocketData: Codable {
    let name: String
    let links: Links?
    let cores: [Cores]
}

struct Links: Codable {
    let patch: Patch?
    let reddit: Reddit?
    let webcast: String?
    let wikipedia: String?
    let presskit: String?
    let youtube_id: String?
}

struct Patch: Codable {
    let large: String
    let small: String
}

struct Reddit: Codable {
    let launch: String?
}

struct Cores: Codable {
    let gridfins: Bool?
    let legs: Bool?
    let reused: Bool?
    let landing_attempt: Bool?
    let landing_success: Bool?
    let landing_type: String?
}
