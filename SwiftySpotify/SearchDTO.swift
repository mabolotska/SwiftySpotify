//
//  SearchDTO.swift
//  SwiftySpotify
//
//  Created by Maryna Bolotska on 23/04/23.
//

import Foundation

struct SearchAPIResponse: Codable {
    
    struct Albums: Codable {
        let items: [Album]
    }
    
    struct CoverArts: Codable {
        struct Cover: Codable {
            let url: String
        }
        let sources: [Cover]
    }
    struct Album: Codable {
        struct Payload: Codable {
            let uri: String
            let name: String
            let coverArt: CoverArts
        }
        let data: Payload
    }
    let albums: Albums
}
