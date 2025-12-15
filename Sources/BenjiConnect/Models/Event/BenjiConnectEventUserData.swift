//
//  BenjiConnectEventUserData.swift
//  
//
//  Created by Marta Wilgan on 12/12/25.
//

import Foundation

public struct BenjiConnectEventUserData: Codable, Sendable, Equatable {
    public struct User: Codable, Sendable, Equatable {
        public let id: Int
        public let firstName: String
        public let lastName: String
        
        private enum CodingKeys: String, CodingKey {
            case id
            case firstName = "first_name"
            case lastName = "last_name"
        }

        public init(id: Int, firstName: String, lastName: String) {
            self.id = id
            self.firstName = firstName
            self.lastName = lastName
        }
    }

    public struct ExtraData: Codable, Sendable, Equatable {
        public let totalRewardsEarned: Int?
        public let totalRewardsRedeemed: Int?
        public let createdDate: String?
        
        private enum CodingKeys: String, CodingKey {
            case totalRewardsEarned = "total_rewards_earned"
            case totalRewardsRedeemed = "total_rewards_redeemed"
            case createdDate = "created_date"
        }

        public init(
            totalRewardsEarned: Int? = nil,
            totalRewardsRedeemed: Int? = nil,
            createdDate: String? = nil
        ) {
            self.totalRewardsEarned = totalRewardsEarned
            self.totalRewardsRedeemed = totalRewardsRedeemed
            self.createdDate = createdDate
        }

    }

    public let user: User
    public let status: BenjiConnectEventUserStatusData
    public let extraData: ExtraData?
    
    private enum CodingKeys: String, CodingKey {
        case user
        case status
        case extraData = "extra_data"
    }

    public init(user: User, status: BenjiConnectEventUserStatusData, extraData: ExtraData? = nil) {
        self.user = user
        self.status = status
        self.extraData = extraData
    }
}
