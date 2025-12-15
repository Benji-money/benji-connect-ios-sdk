//
//  Mapper.swift
//  
//
//  Created by Marta Wilgan on 12/12/25.
//

import Foundation

public enum Mapper {

    public static func mapToOnSuccessData(data: BenjiConnectAuthSuccessEventData) -> BenjiConnectOnSuccessData {
        let token = extractAccessToken(from: data.token)
        let base = BenjiConnectMetadata(context: buildContext(), extras: [:])

        let metadata = BenjiConnectOnSuccessMetadata(
            base: base,
            action: data.action,
            userData: data.metadata.map { mapEventUserDataToUserData($0) }
        )

        return .init(token: token, metadata: metadata)
    }

    public static func mapToOnExitData(data: BenjiConnectFlowExitEventData) -> BenjiConnectOnExitData {
        let base = BenjiConnectMetadata(context: buildContext(), extras: [:])
        let md = BenjiConnectOnExitMetadata(base: base, trigger: data.trigger.rawValue, step: data.step)
        return .init(metadata: md)
    }

    public static func mapToOnErrorData(data: BenjiConnectErrorEventData) -> BenjiConnectOnErrorData {
        let base = BenjiConnectMetadata(context: buildContext(), extras: [:])

        let nsError = NSError(
            domain: "BenjiConnect",
            code: 0,
            userInfo: [
                NSLocalizedDescriptionKey: data.error.message,
                "name": data.error.name ?? "unknown",
                "stack": data.error.stack ?? ""
            ]
        )

        return .init(error: nsError, errorID: "500", metadata: base)
    }

    public static func mapToAuthSuccessEventData(data: BenjiConnectAuthSuccessEventData) -> BenjiConnectOnEventData {
        let base = BenjiConnectMetadata(context: buildContext(), extras: [:])
        return .init(type: .authSuccess, metadata: base)
    }

    public static func mapToOnEventData(type: BenjiConnectEventType, rawData: BenjiConnectEventData) -> BenjiConnectOnEventData {
        let base = BenjiConnectMetadata(context: buildContext(), extras: rawData)
        return .init(type: type, metadata: base)
    }

    private static func extractAccessToken(from token: BenjiConnectEventToken?) -> String {
        return token?.accessToken ?? ""
    }

    private static func mapEventUserDataToUserData(_ event: BenjiConnectEventUserData) -> BenjiConnectUserData {
        return .init(
            user: .init(id: event.user.id, firstName: event.user.firstName, lastName: event.user.lastName),
            status: .init(
                statusID: event.status.statusID,
                numOfRewards: event.status.numOfRewards,
                rewardStatus: event.status.rewardStatus,
                partnerStatusTierID: event.status.partnerStatusTierID
            ),
            extraData: event.extraData.map {
                .init(
                    totalRewardsEarned: $0.totalRewardsEarned,
                    totalRewardsRedeemed: $0.totalRewardsRedeemed,
                    createdDate: $0.createdDate
                )
            }
        )
    }
}
