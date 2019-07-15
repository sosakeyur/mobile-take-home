//
//  EpisodeJsonFormat.swift
//  RM Episodes
//
//  Created by Admin on 7/13/19.
//  Copyright © 2019 Keyur Sosa. All rights reserved.
//

import Foundation

var defOptionalString = String(stringLiteral: "")
var defOptionalUrl = URL(string: "")

var defOptionalInt = -1

struct EpisodeData: Codable, CustomStringConvertible {
    var info: Info
    var results: [Episode]?

    var description: String {
        var desc = """
        pages = \(info.pages ?? defOptionalInt)
        episode per page = \(info.count ?? defOptionalInt)
        next page = \(info.next ?? defOptionalString)
        prev page = \(info.prev ?? defOptionalString)
        episode:
        
        """
        if let episodes = results {
            for episode in episodes {
                desc += episode.description
            }
        }

        return desc
    }
}

struct CharacterData: Codable, CustomStringConvertible {
    var info: Info2
    var results: [Character]?
    
    var description: String {
        var desc = """
        pages = \(info.pages ?? defOptionalInt)
        episode per page = \(info.count ?? defOptionalInt)
        next page = \(info.next ?? defOptionalString)
        prev page = \(info.prev ?? defOptionalString)
        episode:
        
        """
        if let episodes = results {
            for episode in episodes {
                desc += episode.description
            }
        }
        
        return desc
    }
}

struct Episode: Codable, CustomStringConvertible {
    var id: Int
    var name: String?
    var air_date: String?
    var episode: String?
    var characters: [String]?
    var url: String?
    var created: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case air_date = "airDate"
        case episode
        case characters
        case url
        case created
    }

    var description: String {
        return """
        ------------
        id = \(id)
        name = \(name ?? defOptionalString)
        air_date = \(air_date ?? defOptionalString)
        episode = \(episode ?? defOptionalString)
        characters = \(characters ?? [])
        url = \(url ?? defOptionalString)
        created = \(created ?? defOptionalString)
        ------------
        """
    }
}

struct Character: Codable, CustomStringConvertible {
    var id: Int
    var name: String?
    var status: String?
    var species: String?
    var type: String?
    var gender: String?
    var origin: origin
    var location: location
    var image: URL?
    var created: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case species
        case type
        case gender
        case origin
        case location
        case image
        case created
    }
    
    var description: String {
        return """
        ------------
        id = \(id)
        name = \(name ?? defOptionalString)
        status = \(status ?? defOptionalString)
        species = \(species ?? defOptionalString)
        type = \(type ?? defOptionalString)
        gender = \(gender ?? defOptionalString)
        ------------
        """
    }
}

struct Info: Codable, CustomStringConvertible {
    public let count: Int?
    public let next: String?
    public let pages: Int?
    public let prev: String?
    
    var description: String {
        return """
        ------------
        count = \(count ?? defOptionalInt)
        next = \(next ?? defOptionalString)
        pages = \(pages ?? defOptionalInt)
        prev = \(prev ?? defOptionalString)
        ------------
        """
    }
}


struct Info2: Codable, CustomStringConvertible {
    public let count: Int?
    public let next: String?
    public let pages: Int?
    public let prev: String?
    
    var description: String {
        return """
        ------------
        count = \(count ?? defOptionalInt)
        next = \(next ?? defOptionalString)
        pages = \(pages ?? defOptionalInt)
        prev = \(prev ?? defOptionalString)
        ------------
        """
    }
}


struct location: Codable, CustomStringConvertible {
    public let name: String?
    public let url: String?

    var description: String {
        return """
        ------------
        name = \(name ?? defOptionalString)
        url = \(url ?? defOptionalString)
        ------------
        """
    }
}

struct origin: Codable, CustomStringConvertible {
    public let name: String?
    public let url: String?
    
    var description: String {
        return """
        ------------
        name = \(name ?? defOptionalString)
        url = \(url ?? defOptionalString)
        ------------
        """
    }
}
