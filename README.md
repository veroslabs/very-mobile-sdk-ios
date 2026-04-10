# iOS SDK Integration

> **Full documentation**: [https://very.org/docs/native-sdk/integration](https://very.org/docs/native-sdk/integration)

## Installation

### Swift Package Manager (recommended)

```swift
dependencies: [
    .package(url: "https://github.com/veroslabs/very-sdk-ios.git", from: "1.0.19")
]
```

### CocoaPods

```ruby
pod 'VerySDK'
```

Then run `pod install`.

### Camera Permission

Add to `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is needed for palm biometric verification.</string>
```

Package source: [github.com/veroslabs/very-sdk-ios](https://github.com/veroslabs/very-sdk-ios) (SPM / CocoaPods)

## Getting an SDK Key

Native SDK keys are not yet available via the Developer Portal. Contact [support@very.org](mailto:support@very.org) to get your SDK key and client credentials.

## Enroll a New User

Pass `nil` for `userId` to register a new user. The SDK opens a consent screen, collects the user's email, then guides them through a palm scan.

```swift
import VerySDK

guard VerySDK.isSupported() else {
    print("Device not supported")
    return
}

let config = VeryConfig(
    sdkKey: "your_sdk_key",
    userId: nil,              // nil = new enrollment
    themeMode: "dark"
)

VerySDK.authenticate(
    from: self,
    config: config,
    presentationStyle: .modal
) { result in
    if result.isSuccess {
        print("Auth code: \(result.code)")
    } else {
        print("Error: \(result.errorType) — \(result.errorMessage ?? "")")
    }
}
```

## Verify an Existing User

Pass the user's ID from a previous enrollment to verify their identity.

```swift
let config = VeryConfig(
    sdkKey: "your_sdk_key",
    userId: "vu-1ed0a927-...",   // from previous enrollment
    themeMode: "dark"
)

VerySDK.authenticate(from: self, config: config) { result in
    if result.isSuccess {
        print("Verified: \(result.code)")
    }
}
```

## Exchange the Auth Code (Backend)

When authentication succeeds, the SDK returns an authorization `code`. Send this to your backend, which exchanges it for an `id_token`:

```
POST https://api.very.org/oauth2/token
Content-Type: application/x-www-form-urlencoded

grant_type=authorization_code
&client_id=your_client_id
&client_secret=your_client_secret
&code=AUTH_CODE_FROM_SDK
&redirect_uri=your_redirect_uri
```

Response:

```json
{
  "access_token": "eyJhbGciOi...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "id_token": "eyJhbGciOi..."
}
```

Decode the `id_token` JWT to get the user's identity:

```json
{
  "iss": "https://connect.very.org",
  "sub": "vu-1ed0a927-a336-45dd-9c73-20092db9ae8d",
  "aud": ["your_client_id"],
  "email": "user@example.com",
  "exp": 1761013475,
  "iat": 1761009875
}
```

- For **enrollment**: store the `sub` (user ID) — pass it as `userId` for future verifications
- For **verification**: confirm the `sub` matches the expected user

> **Important:** The `client_secret` for token exchange must only be stored on your backend. Never embed it in the mobile app.

## Configuration Reference

### VeryConfig

| Parameter           | Type    | Default    | Description                                                        |
| ------------------- | ------- | ---------- | ------------------------------------------------------------------ |
| `sdkKey`            | String  | required   | Your SDK API key                                                   |
| `userId`            | String? | nil        | Nil for enrollment, user ID for verification                       |
| `language`          | String? | device     | Locale code (e.g. `"en"`, `"es"`, `"ja"`). 35 languages supported. |
| `themeMode`         | String  | `"dark"`   | `"dark"` or `"light"`                                              |
| `baseUrl`           | String? | production | Override API endpoint (for staging/testing)                        |
| `presentationStyle` | Enum    | `.modal`   | `.modal`, `.push`, or `.embed`                                     |
| `livenessMode`      | Enum    | `.gesture` | `.gesture` or `.touch`                                             |

### VeryResult

| Property       | Type          | Description                                                                   |
| -------------- | ------------- | ----------------------------------------------------------------------------- |
| `isSuccess`    | Bool          | Whether authentication completed successfully                                 |
| `code`         | String        | Authorization code to exchange for `id_token` on your backend                 |
| `userId`       | String        | The user's VeryAI ID                                                          |
| `signedToken`  | String?       | Signed JWT token (when available)                                             |
| `error`        | String?       | Error code string                                                             |
| `errorType`    | VeryErrorType | Typed error (see [Error Codes](https://very.org/docs/native-sdk/error-codes)) |
| `errorMessage` | String?       | Human-readable error message                                                  |

## Requirements

- iOS 16.4+
- Swift 5.0+ / Xcode 16+
- Camera permission
- Physical device recommended

Use `VerySDK.isSupported()` to check device compatibility at runtime before showing the verification UI.
