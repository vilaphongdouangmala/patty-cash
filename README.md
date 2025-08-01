# Patty Cash

A Flutter mobile application designed to simplify the process of splitting meal costs among friends or colleagues.

## Features

- **Add Participants**: Easily add and manage people participating in the meal cost split.
- **Manage Receipt Items**: Add items from a receipt with their prices.
- **Assign Items to Participants**: Select which participants are responsible for each item.
- **Calculate Splits**: Automatically calculate the total amount owed by each participant based on their selected items.
- **Share Summary**: Generate a text summary that can be shared with others.

## Technology Stack

- **Framework**: Flutter
- **State Management**: Riverpod
- **Design**: Material Design

## Getting Started

### Prerequisites

- Flutter SDK (version ^3.5.0)
- Dart SDK

### Installation

1. Clone the repository
   ```
   git clone https://github.com/yourusername/patty-cash.git
   ```

2. Navigate to the project directory
   ```
   cd patty-cash
   ```

3. Install dependencies
   ```
   flutter pub get
   ```

4. Run the app
   ```
   flutter run
   ```

## How to Use

1. **Add Participants**:
   - From the home screen, tap "Manage Participants"
   - Enter participant names and tap "Add"

2. **Add Receipt Items**:
   - From the home screen, tap "Manage Receipt Items"
   - Enter item name and price, then tap "Add Item"

3. **Assign Items to Participants**:
   - On the Receipt Items screen, select which participants are responsible for each item by tapping their names

4. **View Split Summary**:
   - From the home screen, tap "View Split Summary"
   - See a breakdown of who owes what
   - Tap "View Item Breakdown" for detailed information
   - Tap "Share Summary" to copy the summary to clipboard

## Design

The application follows Google Material Design principles with a primary color of `#A3BFA8`.