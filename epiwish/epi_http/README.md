# Epi HTTP

HTTP methods and models for Epiwish projects.

---

Use `EpiResponse` class to create responses.

Creating success responses
```dart
final EpiResponse<int> response = EpiResponse.success(
  42,
  message: 'The answer to life, the universe, and everything.',
);
```

Creating error responses
```dart
final EpiResponse<String?> response = EpiResponse.error(
  null,
  message: 'Something went wrong!',
);
```

Creating unknown responses
```dart
final EpiResponse<String?> response = EpiResponse.unknown(
  null,
  message: 'We have no idea what happened!',
);
```


You can check status and data from the response like this:
```dart
if (response.status == Status.success) {
  final data = response.data;
  // Do something with the data
  // ...
} else if (response.status == Status.error) {
  final message = response.message;
  // Handle the error with message
  // ...
} else {
  // Handle the unknown status
}
```