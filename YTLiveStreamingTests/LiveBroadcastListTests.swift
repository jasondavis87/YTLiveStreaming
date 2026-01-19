//
//  LiveBroadcastListTests.swift
//  YTLiveStreamingTests
//
//  Created by Serhii Krotkykh on 05.05.2021.
//  Copyright © 2021 Serhii Krotkykh. All rights reserved.

@testable import YTLiveStreaming
import XCTest

class LiveBroadcastListTestCase: XCTestCase {

    fileprivate var broadcastListDataProvider: BroadcastListMockDataProvider!

    // MARK: - Class Setup and Teardown

    override func setUp() {
        super.setUp()
        broadcastListDataProvider = BroadcastListMockDataProvider()
    }

    // MARK: - Live Broadcasts Section

    func testLiveBroadcastList() {
        if let model =  broadcastListDataProvider.getBroadcastList() {
            XCTAssertEqual(model.items.count, 3)
        }
    }

    func testLiveBroadcastStreamModel() {
        if let model = broadcastListDataProvider.getBroadcastStream() {
            XCTAssertEqual(model.id, "test_broadcast_id")
            XCTAssertEqual(model.kind, "youtube#liveBroadcast")
            XCTAssertEqual(model.snippet.title, "Test Live Broadcast")
            XCTAssertEqual(model.snippet.channelId, "UCtest_channel_id")
            XCTAssertEqual(model.snippet.isDefaultBroadcast, false)
            XCTAssertNotNil(model.snippet.thumbnails.def)
            XCTAssertNotNil(model.snippet.thumbnails.high)
            XCTAssertNotNil(model.snippet.thumbnails.medium)
            XCTAssertEqual(model.contentDetails?.latencyPreference, "normal")
            XCTAssertEqual(model.contentDetails?.enableContentEncryption, false)
            XCTAssertEqual(model.status?.lifeCycleStatus, "created")
            XCTAssertEqual(model.status?.privacyStatus, "private")
        }
    }
}

// MARK: -

private class BroadcastListMockDataProvider {
    func getBroadcastList() -> LiveBroadcastListModel? {
        let bundle = Bundle(for: BroadcastListMockDataProvider.self)
        switch DecodeData.load(bundle, "LiveBroadcastListModel.json", as: LiveBroadcastListModel.self) {
        case .success(let model):
            return model
        case .failure(let error):
            XCTFail("Failed to parse. Error: \(error.message())")
            return nil
        }
    }

    func getBroadcastStream() -> LiveBroadcastStreamModel? {
        let bundle = Bundle(for: BroadcastListMockDataProvider.self)
        switch DecodeData.load(bundle, "LiveBroadcastStreamModel.json", as: LiveBroadcastStreamModel.self) {
        case .success(let model):
            return model
        case .failure(let error):
            XCTFail("Failed to parse LiveBroadcastStreamModel. Error: \(error.message())")
            return nil
        }
    }
}
