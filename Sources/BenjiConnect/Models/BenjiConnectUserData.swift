//
//  BenjiConnectUserData.swift
//  
//
//  Created by Marta Wilgan on 12/11/25.
//

import Foundation

/// Mirrors TypeScript `BenjiConnectEventUserStatusData`
public struct BenjiConnectEventUserStatusData: Codable {
    public let statusId: String
    public let numOfRewards: Int
    public let rewardStatus: String
    public let partnerStatusTierId: Int?

    public init(
        statusId: String,
        numOfRewards: Int,
        rewardStatus: String,
        partnerStatusTierId: Int?
    ) {
        self.statusId = statusId
        self.numOfRewards = numOfRewards
        self.rewardStatus = rewardStatus
        self.partnerStatusTierId = partnerStatusTierId
    }
}

/// Mirrors TypeScript `BenjiConnectEventUserData`
public struct BenjiConnectEventUserData: Codable {

    public struct User: Codable {
        public let id: Int
        public let firstName: String
        public let lastName: String

        public init(id: Int, firstName: String, lastName: String) {
            self.id = id
            self.firstName = firstName
            self.lastName = lastName
        }
    }

    public struct ExtraData: Codable {
        public let totalRewardsEarned: Double?
        public let totalRewardsRedeemed: Double?
        public let createdDate: String?

        public init(
            totalRewardsEarned: Double?,
            totalRewardsRedeemed: Double?,
            createdDate: String?
        ) {
            self.totalRewardsEarned = totalRewardsEarned
            self.totalRewardsRedeemed = totalRewardsRedeemed
            self.createdDate = createdDate
        }
    }

    public let user: User
    public let status: BenjiConnectEventUserStatusData
    public let extraData: ExtraData?

    public init(
        user: User,
        status: BenjiConnectEventUserStatusData,
        extraData: ExtraData?
    ) {
        self.user = user
        self.status = status
        self.extraData = extraData
    }
}
