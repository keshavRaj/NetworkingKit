# NetworkingKit

**A modular Swift networking package focused on type-safe HTTP request construction, explicit error modeling, and testable architecture.**

NetworkingKit is an open-source Swift Package Manager project exploring how to design a reusable networking layer using native Apple frameworks.

The project emphasizes clear responsibilities, protocol-based abstractions, predictable request construction, and incremental development backed by unit tests.

## Features

### Implemented — Request Modeling & Construction

- **Endpoint abstraction:** Protocol-based definition of request paths, HTTP methods, query parameters, headers, request bodies, and configuration.
- **HTTP request builder:** Constructs `URLRequest` instances from endpoint definitions and a base URL.
- **Request body modeling:** Supports JSON payloads, raw binary data, and requests without a body.
- **Content types:** Models JSON and custom MIME types.
- **Request configuration:** Supports custom headers, timeout intervals, and cache policies.
- **Error modeling:** Defines networking errors and HTTP status categories for consistent error representation.
- **Unit tests:** Covers request construction, URL validation, query parameters, headers, timeout and cache configuration, and request-body serialization.

### In Progress

- Generic networking client using `URLSession`
- Response decoding and validation
- Integration testing and dependency injection

### Planned Enhancements

- Retry policies and request interceptors
- Authentication integration
- Request and response logging
- Image downloading and caching
- Integration with a SwiftUI Movie Discovery application

## Architecture

NetworkingKit separates request definitions from request construction and network execution.

**Endpoint → RequestBuilder → URLRequest → Network Client**

The goal is to keep individual components independently testable and avoid coupling feature-specific APIs to low-level networking details.

## Technology Stack

- Swift 6
- Swift Package Manager
- Foundation and URLSession
- Swift Concurrency
- Swift Testing

## Platform Support

- iOS 15+
- macOS 12+

## Installation

The project is structured as a Swift package and can be added through Xcode using its Git repository URL:

`https://github.com/keshavRaj/NetworkingKit`

**Status:** Under active development. The request-modeling and request-construction components are available, while the complete networking client API is still being developed. Not yet recommended as a production dependency.

## Development Approach

NetworkingKit is built incrementally, with emphasis on:

- Clear API contracts and separation of responsibilities
- Explicit error handling
- Unit testing of individual components
- Maintainable Swift abstractions
- Understanding architectural trade-offs rather than introducing unnecessary complexity

## License

MIT
