# CeciStyle iOS Admin

An iOS administration application developed for Ceci'Style to manage customer appointments and support day-to-day business operations.

## Overview

CeciStyle iOS Admin provides mobile access to appointment management for Ceci'Style. The application communicates with the business backend through REST APIs and allows authorized users to review and manage appointments from an iOS device.

The project was developed in Swift using SwiftUI and integrates authentication, biometric access, Firebase Cloud Messaging, and backend services.

## Features

- View customer appointments organized by date
- Create new appointments
- Edit existing appointments
- Delete appointments
- Retrieve service information from the backend
- REST API integration
- Bearer-token authentication
- Secure token storage using iOS Keychain
- Face ID / biometric authentication
- Firebase Cloud Messaging integration
- Notification badge management for new appointments
- Manual refresh of appointment data

## Tech Stack

- Swift
- SwiftUI
- Foundation
- LocalAuthentication
- UserNotifications
- Firebase Cloud Messaging
- REST APIs
- JSON / Codable
- iOS Keychain Services
- CocoaPods

## Project Structure

```text
App/        Application entry point and root navigation
Managers/   Session and authentication management
Models/     Application data models
Services/   API and backend communication
Views/      SwiftUI views and appointment workflows
```

## Security

Authentication tokens are stored using iOS Keychain Services rather than UserDefaults.

Environment-specific configuration and Firebase configuration files are excluded from version control. A sample configuration file is included to document the expected structure without exposing production configuration.

## Configuration

Create a local configuration file from the provided example:

```bash
cp Config.example.swift Config.swift
```

Update `Config.swift` with the appropriate backend configuration for your environment.

Firebase configuration is not included in the repository. A valid `GoogleService-Info.plist` must be supplied locally when Firebase functionality is required.

## Testing

The project includes unit tests for the `Appointment` model, including JSON decoding, optional values, and equality behavior.

Additional UI test targets are included in the Xcode project.

## Development Notes

This repository contains the iOS administration client. Backend services and production credentials are not included.

The application was developed for a real business workflow and integrates with an existing backend API.

## Author

Gean Vallejos

Software Developer
