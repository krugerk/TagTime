//
//  MissedPingCard.swift
//  TagTime (iOS)
//
//  Created by Shawn Koh on 4/4/21.
//

import SwiftUI
import Resolver

struct MissedPingCard: View {
    // TODO: I'm not sure if we should use EnvironmentObject here, but I'm not sure how else
    // I can delete the ping from MissedPingList.
    @EnvironmentObject var answerService: AnswerService
    @EnvironmentObject var alertService: AlertService
    @EnvironmentObject var tagService: TagService
    @State private var config = AnswerCreatorConfig()

    let ping: Date

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        Text(dateFormatter.string(from: ping))
            .onTap { config.create(pingDate: ping) }
            .cardButtonStyle(.baseCard)
            .sheet(isPresented: $config.isPresented) {
                AnswerCreator(config: $config)
                    .environmentObject(self.answerService)
                    .environmentObject(self.alertService)
                    .environmentObject(self.tagService)
            }
    }
}

struct MissedPingCard_Previews: PreviewProvider {
    @Injected static var answerService: AnswerService
    @Injected static var alertService: AlertService
    @Injected static var tagService: TagService

    static var previews: some View {
        MissedPingCard(ping: Stub.pings.first!)
            .environmentObject(answerService)
            .environmentObject(alertService)
            .environmentObject(tagService)
    }
}
