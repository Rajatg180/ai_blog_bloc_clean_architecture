# AI-Powered Blog Application

This full-stack blog application is developed using **Flutter** and integrates AI to generate and summarize blog content. The app provides seamless user authentication and state management while adhering to SOLID principles and Clean Architecture.

## Features

- **AI Integration**: Generate blog content and summarize blogs in a few words via an API.
- **User Authentication**: Secure login and registration using **Firebase** authentication.
- **State Management**: Managed with **Bloc & Cubit** for efficient and reactive UI updates.
- **Offline Access**: Integrated **Hive** for local storage, allowing users to access data offline.
- **Clean Architecture**: Follows SOLID principles for maintainability and scalability.
- **Dependency Injection**: Utilized **get_it** for dependency injection to enhance code modularity and testing.

## Technologies Used

- **Flutter**: For building the UI and managing state.
- **Firebase**: For authentication and backend services.
- **AI API**: For generating blog content and summaries.
- **Hive**: For offline data access.
- **get_it**: For dependency injection.
- **Bloc & Cubit**: For state management.

## Installation

### Prerequisites

Ensure you have the following installed:

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Dart](https://dart.dev/get-dart)
- Firebase setup for Flutter (follow [this guide](https://firebase.flutter.dev/docs/overview))
- API keys for AI integration

### Steps

1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/blog-app.git
   cd blog-app
