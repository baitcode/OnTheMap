# OnTheMap

iOS app showing where Udacity students are studying from. Built in December 2015
as project 3 of the Udacity iOS course.

## What it does

- Log in with a Udacity account or through Facebook.
- See other students' locations as pins on a map or as a list, and open the link each student shared.
- Share your own location: enter an address, confirm it on the map, attach a URL.

## Structure

| File | Role |
| --- | --- |
| `ApiClient.swift` | Generic HTTP client base class returning PromiseKit promises |
| `UdacityClient.swift` | Udacity session and user API |
| `ParseClient.swift` | Student locations, stored in Parse |
| `StudentInformation.swift` | Student location model |
| `Students*Controller.swift` | Map and list tabs |
| `Share*Controller.swift` | The two-step "share my location" flow |

## Build

```sh
open OnTheMap.xcworkspace
```

The CocoaPods dependencies (PromiseKit, Facebook SDK, SwiftSpinner) are committed
in `Pods/`.

## Status

No longer functional. Student locations were stored in the hosted Parse service,
which has since shut down. The code is Swift 2, so it will not compile with a
current Xcode without migration.
