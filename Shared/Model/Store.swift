//
//  Store.swift
//  TagTime (iOS)
//
//  Created by Shawn Koh on 3/4/21.
//

import Foundation

final class Store: ObservableObject {
    @Published var pings: [Ping] = Stub.pings
    @Published var tags: [Tag] = Stub.tags
    @Published var answers: [Answer] = Stub.answers

    let user: User

    init(user: User) {
        self.user = user
    }
}
