# Project Overview

A Flutter application for displaying and searching through categorized logs.

## Features

- Display a list of logs.
- Search functionality for logs.
- Filter logs based on error status.
- Navigation to log details.

## Code Structure

- DataSearch: Implements search functionality.
- ListPage: Displays the list of logs.
- _ListPageState: Manages the state of ListPage.

## Usage

Ensure Flutter and Dart are installed. Before running the project, create a `config.dart` file in the `lib` directory. This file should contain the your API URL. Here's an example of how your `config.dart` file might look:

```dart

class Config {
  static const API_URL = 'YOUR_API_URL';
}
```

## Dependencies

- flutter/material.dart
- ../models/log.dart
- ../services/fetch_logs.dart
- faker
