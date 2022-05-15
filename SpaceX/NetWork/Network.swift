//
//  Apollo.swift
//  SpaceX
//
//  Created by Okan Sarp Kaya on 14.05.2022.
//

import Foundation
import Apollo
import ApolloWebSocket


public typealias Launches = SpaceXHistoryQuery.Data.Launch
class Network {
    static let shared = Network()
    private(set) lazy var apollo = ApolloClient(url: URL(string: "https://api.spacex.land/graphql/")!)
    static let paginationLimit = 20
}
