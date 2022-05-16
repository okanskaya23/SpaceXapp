//
//  Apollo.swift
//  SpaceX
//
//  Created by Okan Sarp Kaya on 14.05.2022.
//

import Foundation
import Apollo
import ApolloWebSocket

class Network {
    static let shared = Network()
    private(set) lazy var apollo = ApolloClient(url: URL(string: "https://api.spacex.land/graphql/")!)
    static let paginationLimit = 20
    static let defaultImageURL = URL(string: "https://i.ibb.co/N76Tmvs/Elon-Musk-Space-X.jpg")!
}
