//
//  graphQL.swift
//  SpaceX
//
//  Created by Okan Sarp Kaya on 16.05.2022.
//

import Foundation
extension Launches: Equatable {
    public static func == (lhs: Launches, rhs: Launches) -> Bool {
        return lhs.id == rhs.id && lhs.missionName == rhs.missionName && lhs.links?.missionPatchSmall == rhs.links?.missionPatchSmall
    }
}
extension Launches: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
extension Launches: Identifiable { }
