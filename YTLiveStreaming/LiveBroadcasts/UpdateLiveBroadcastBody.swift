//
//  UpdateLiveBroadcastBody.swift
//  YTLiveStreaming
//
//  Created by Serhii Krotkykh on 10/24/16.
//  Copyright © 2016 Serhii Krotkykh. All rights reserved.
//
import Foundation

// MARK: - Update LiveBroadcasts request

/**
 Update LiveBroadcasts. Request Body
  Request
   PUT https://www.googleapis.com/youtube/v3/liveBroadcasts
  Scope
   https://www.googleapis.com/auth/youtube
   https://www.googleapis.com/auth/youtube.force-ssl
 @param
 @return
 **/
struct UpdateLiveBroadcastBody: Codable {
    struct Status: Codable {
        var privacyStatus: String
    }

    struct MonitorStream: Codable {
        var enableMonitorStream: Bool
        var broadcastStreamDelayMs: Int
    }

    struct ContentDetails: Codable {
        var monitorStream: MonitorStream
        var enableAutoStart:  Bool
        var enableAutoStop:  Bool
        var enableClosedCaptions: Bool
        var enableDvr: Bool
        var enableEmbed: Bool
        var recordFromStart: Bool
        
        init(contentDetails: LiveBroadcastStreamModel.ContentDetails) {
            monitorStream = MonitorStream(enableMonitorStream: contentDetails.monitorStream?.enableMonitorStream ?? true,
                                          broadcastStreamDelayMs: contentDetails.monitorStream?.broadcastStreamDelayMs ?? 0)
            enableAutoStart = contentDetails.enableAutoStart ?? false
            enableAutoStop = contentDetails.enableAutoStop ?? false
            enableClosedCaptions = contentDetails.enableClosedCaptions ?? false
            enableDvr = contentDetails.enableDvr ?? true
            enableEmbed = contentDetails.enableEmbed ?? true
            recordFromStart = contentDetails.recordFromStart ?? true
        }
    }

    struct Snipped: Codable {
        var title: String
        var description: String
        var scheduledStartTime: String?
        var scheduledEndTime: String?
        var status: Status?
        var contentDetails: ContentDetails?

        init(broadcast: LiveBroadcastStreamModel) {
            title = broadcast.snippet.title
            description = broadcast.snippet.description
            scheduledStartTime = broadcast.snippet.scheduledStartTime?.toJSONformat()
            scheduledEndTime = broadcast.snippet.scheduledEndTime?.toJSONformat()
            if let broadcastStatus = broadcast.status, let privacyStatus = broadcastStatus.privacyStatus {
                status = Status(privacyStatus: privacyStatus)
            }
            if let broadcastContentDetails = broadcast.contentDetails {
                contentDetails = ContentDetails(contentDetails: broadcastContentDetails)
            }
        }
    }

    let id: String
    let snippet: Snipped

    init(broadcast: LiveBroadcastStreamModel) {
        id = broadcast.id
        snippet = Snipped(broadcast: broadcast)
    }
}
