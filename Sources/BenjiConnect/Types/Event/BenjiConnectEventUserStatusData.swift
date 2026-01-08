//
//  BenjiConnectEventUserStatusData.swift
//  
//
//  Created by Marta Wilgan on 12/12/25.
//

import Foundation

public struct BenjiConnectEventUserStatusData: Codable, Sendable, Equatable {
    public let statusID: String
    public let numOfRewards: Int
    public let rewardStatus: String
    public let partnerStatusTierID: Int?
    
    private enum CodingKeys: String, CodingKey {
        case statusID = "status_id"
        case numOfRewards = "num_of_rewards"
        case rewardStatus = "reward_status"
        case partnerStatusTierID = "partner_status_tier_id"
    }

    public init(statusID: String, numOfRewards: Int, rewardStatus: String, partnerStatusTierID: Int? = nil) {
        self.statusID = statusID
        self.numOfRewards = numOfRewards
        self.rewardStatus = rewardStatus
        self.partnerStatusTierID = partnerStatusTierID
    }
}
