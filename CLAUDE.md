# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

YTLiveStreaming is an iOS framework for creating live broadcasts and video streams on YouTube using the YouTube Live Streaming API (YouTube Data API v3). It supports both CocoaPods and Swift Package Manager distribution.

**Platform:** iOS 13+ / macOS 10.15+
**Swift:** 5.0+
**Xcode:** 13.0+

## Build Commands

```bash
# Swift Package Manager
swift build
swift test

# CocoaPods - validate podspec
pod lib lint YTLiveStreaming.podspec --allow-warnings

# CocoaPods - publish new version (requires trunk session)
pod trunk push YTLiveStreaming.podspec --verbose --allow-warnings
```

## Publishing a New Version

1. Update version in `YTLiveStreaming.podspec`
2. Commit changes
3. Create and push git tag: `git tag X.X.X && git push origin master --tags`
4. Validate: `pod spec lint YTLiveStreaming.podspec --allow-warnings`
5. Publish: `pod trunk push YTLiveStreaming.podspec --verbose --allow-warnings`

## Architecture

```
Client App → YTLiveStreaming → YTLiveRequest → LiveStreamingAPI → Moya Provider → YouTube API v3
                                    ↓
                              GoogleOAuth2 (Keychain token storage)
```

### Key Components

- **YTLiveStreaming/** - Main framework source
  - `API/YTLiveStreaming.swift` - Main public API class with async and callback-based methods
  - `API/LiveLauncher.swift` - Singleton for broadcast status monitoring via timer-based polling
  - `LiveStreamingRequests/LiveStreamingAPI.swift` - Moya TargetType enum defining all API endpoints
  - `LiveStreamingRequests/YTLiveRequest.swift` - Network request layer with OAuth token injection
  - `TokenStorage/GoogleOAuth2.swift` - OAuth 2.0 token management using Keychain
  - `LiveBroadcasts/` - Broadcast data models (Codable structs)
  - `LiveStreams/` - Stream data models (Codable structs)

- **YTLiveStreamingTests/** - XCTest-based tests with JSON mock data in `JSON/` subdirectory

### Patterns

- **Async migration in progress:** New methods use Swift async/await, legacy methods use completion callbacks wrapping async versions
- **Result pattern:** All operations return `Result<T, YTError>` for error handling
- **Singletons:** `GoogleOAuth2.sharedInstance`, `LiveLauncher.sharedInstance`
- **Delegation:** `LiveStreamTransitioning` protocol for broadcast status callbacks

## Dependencies

- **Moya 14.0** - Network abstraction layer
- **SwiftyJSON** - JSON parsing
- **KeychainAccess** - Secure token storage

## SwiftLint

Disabled rules: `nesting`, `identifier_name`, `line_length`, `file_length`, `force_cast`

## Credentials

The framework reads `CLIENT_ID` and `API_KEY` from `Info.plist` or `Config.plist` via `Credentials.swift`. These are required for YouTube API authentication.
