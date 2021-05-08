//
//  DebugMenu.swift
//  TagTime (iOS)
//
//  Created by Shawn Koh on 25/4/21.
//

#if DEBUG
import SwiftUI
import Resolver

struct DebugMenu: View {
    @EnvironmentObject private var answerService: AnswerService
    @EnvironmentObject private var authenticationService: AuthenticationService
    @EnvironmentObject private var tagService: TagService
    @EnvironmentObject private var notificationScheduler: NotificationScheduler
    @EnvironmentObject private var pingService: PingService

    var body: some View {
        VStack(alignment: .leading) {
            Text("Debug Mode")
                .font(.title)
                .bold()
                .padding()

            Text("Schedule notification in 5 seconds")
                .onTap {
                    let timeInterval = Date(timeIntervalSinceNow: 5).timeIntervalSince1970.rounded()
                    let pingDate = Date(timeIntervalSince1970: timeInterval)
                    notificationScheduler.scheduleNotification(
                        ping: pingDate,
                        badge: pingService.unansweredPings.count,
                        previousAnswer: answerService.latestAnswer
                    )
                }

            Text("Delete all answers")
                .onTap { answerService.deleteAllAnswers() }

            Text("Reset User Start Date")
                .onTap { authenticationService.resetUserStartDate() }

            Text("Reset Tag Cache")
                .onTap { tagService.resetTagCache() }

            Spacer()
        }
        .background(.modalBackground)
        .cardButtonStyle(.modalCard)
    }
}

struct DebugMenu_Previews: PreviewProvider {
    @Injected static var answerService: AnswerService
    @Injected static var authenticationService: AuthenticationService
    @Injected static var tagService: TagService
    @Injected static var notificationScheduler: NotificationScheduler
    @Injected static var pingService: PingService

    static var previews: some View {
        DebugMenu()
            .environmentObject(answerService)
            .environmentObject(authenticationService)
            .environmentObject(tagService)
            .environmentObject(notificationScheduler)
            .environmentObject(pingService)
    }
}
#endif
