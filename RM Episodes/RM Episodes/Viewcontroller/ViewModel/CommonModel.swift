//
//  EpisodesModel.swift
//  RM Episodes
//
//  Created by Admin on 7/14/19.
//  Copyright © 2019 Keyur Sosa. All rights reserved.
//

import Foundation
protocol CommonModelDelagate: class {
    func onFetchCompleted()
    func onFetchNextPageData(with page: Int)
    func onFetchFailed()
}

// Class for to call Episodes
final class EpisodesModel {
    private weak var delegate: CommonModelDelagate?
    
    private var episodes: [Episode] = []
    public var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    
    let client = NetworkClass()
    
    init(delegate: CommonModelDelagate) {
        self.delegate = delegate
    }
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return episodes.count
    }
    
    func episode(at index: Int) -> Episode {
        return episodes[index]
    }
    
    func fetchEpisodes(endPoint: String) {
        let api = client.baseURL
        let url = URL(string: api + endPoint)!
        guard !isFetchInProgress else {
            return
        }
        
        isFetchInProgress = true
        // API Call
        client.makeRequest(toURL: url, withHttpMethod: .get) { results in
            if let data = results.data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let episodeData = try? decoder.decode(EpisodeData.self, from: data) else { return }
                guard let result = episodeData.results else {
                    return
                }
                let response = episodeData.info
                
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.total += result.count
                    self.episodes.append(contentsOf: result)
                    
                    if self.currentPage <= response.pages! {
                        self.currentPage += 1
                        self.delegate?.onFetchNextPageData(with: self.currentPage)
                    }
                    self.delegate?.onFetchCompleted()
                }
            }
        }
    }
}

// Class for to call Characters
final class CharacterModel {
    private weak var delegate: CommonModelDelagate?
    
    private var charactersAlive: [Character] = []
    private var charactersDead: [Character] = []
    public var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    
    let client = NetworkClass()
    
    init(delegate: CommonModelDelagate) {
        self.delegate = delegate
    }
    
    var totalCount: Int {
        return total
    }
    
    var currentAliveCount: Int {
        return charactersAlive.count
    }
    
    var currentDeadCount: Int {
        return charactersDead.count
    }
    
    func characterAlive(at index: Int) -> Character {
        return charactersAlive[index]
    }
    
    func characterDead(at index: Int) -> Character {
        return charactersDead[index]
    }
    
    func fetchCharacters(endPoint: String) {
        let api = client.baseURL
        let url = URL(string: api + endPoint)!
        
        guard !isFetchInProgress else {
            return
        }
        
        isFetchInProgress = true
        // API Call
        client.makeRequest(toURL: url, withHttpMethod: .get) { results in
            if let data = results.data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let charactersData = try? decoder.decode(CharacterData.self, from: data) else { return }
                guard var result = charactersData.results else {
                    return
                }
                let response = charactersData.info
                result = result.sorted(by: { $0.created > $1.created })
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.total += result.count
                    let filteredDead = result.filter {
                        $0.status == "Dead" // access the value to filter
                    }
                    self.charactersDead.append(contentsOf: filteredDead)
                    
                    let filteredAlive = result.filter {
                        $0.status == "Alive" // access the value to filter
                    }
                    self.charactersAlive.append(contentsOf: filteredAlive)
                    
                    if self.currentPage <= response.pages! {
                        self.currentPage += 1
                        self.delegate?.onFetchNextPageData(with: self.currentPage)
                    }
                    self.delegate?.onFetchCompleted()
                }
            }
        }
    }
}
