# CyberWise – Protecting Older Adults Online

CyberWise is an iOS app designed to help older adults navigate the digital world safely and confidently. It provides tools for scam detection, local password management, and interactive educational modules, all within an accessible and easy-to-use interface.

## Features

- **Password Vault** – Locally encrypted with AES-GCM and secured with Face ID/Touch ID or PIN.
- **Scam Detection** – Checks phone numbers, emails, and websites using IPQualityScore API.
- **Educational Modules** – Interactive lessons covering phishing, scam calls, secure browsing, and more.
- **Accessibility-Focused Design** – Large fonts, simple layouts, and offline functionality.

## Tech Stack

- **Language:** Swift
- **Framework:** SwiftUI (iOS 16+)
- **Architecture:** MVC
- **Encryption:** CryptoKit (AES-GCM)
- **API Integration:** IPQualityScore (IPQS)
- **Design Tools:** Figma
- **Version Control:** GitHub

## Requirements

- Device: iPhone 11 or newer
- OS: iOS 16 or later
- Xcode 14+ (to build and run the app)

## Installation
1. Clone the repository:
   ```bash
   git clone https://projects.cs.nott.ac.uk/psygj1/cyberwise.git
2. Open the project in Xcode.  
3. Connect a compatible device or use the simulator.  
4. Build and run the app.

Note: This project includes a default IPQualityScore (IPQS) API key for dissertation purposes.
While it may work for demonstration, it is not guaranteed to remain active or support extended use.
If needed, you can obtain your own key at ipqualityscore.com and replace it in the relevant files (the ones that call the API, e.g. MaliciousURLAPI.swift)

