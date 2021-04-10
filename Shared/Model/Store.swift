//
//  Store.swift
//  TagTime (iOS)
//
//  Created by Shawn Koh on 3/4/21.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import Combine

final class Store: ObservableObject {
    @Published var pings: [Ping] = []
    @Published var tags: [Tag] = Stub.tags
    @Published var answers: [Answer] = []

    let pingService = PingService()

    let settings: Settings
    let user: User

    var subscribers = Set<AnyCancellable>()

    init(settings: Settings, user: User) {
        self.settings = settings
        self.user = user
        setup()
        setupSubscribers()

        pingService.unansweredPings(user: user) {
            self.pings = $0
        }
    }

    private var listener: ListenerRegistration?

    private func setup() {
        self.listener = Firestore.firestore()
            .collection("users")
            .document(user.id)
            .collection("answers")
            .addSnapshotListener() { (snapshot, error) in
                guard let snapshot = snapshot else {
                    // TODO: Log error
                    return
                }
                // TODO: find a better way to handle situations like these
                do {
                    self.answers = try snapshot.documents.compactMap { try $0.data(as: Answer.self) }
                } catch {
                    // TODO: Log error
                }
            }
    }

    private func setupSubscribers() {
        settings.$averagePingInterval
            .sink { self.pingService.averagePingInterval = $0 * 60 }
            .store(in: &subscribers )
    }

    func addAnswer(_ answer: Answer) {
        do {
            try Firestore.firestore()
                .collection("users")
                .document(user.id)
                .collection("answers")
                .document(answer.ping.timeIntervalSince1970.description)
                .setData(from: answer) { error in
                    guard let error = error else {
                        return
                    }
                    // TODO: Log error
                    print("unable to save answer", error)
                }
        } catch {
            // TODO: Log error
            print("Unable to add answer")
        }
    }
}
