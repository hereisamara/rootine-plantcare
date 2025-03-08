
# Rootine


Rootine is a mobile application designed to assist users in plant care and disease identification through a comprehensive set of features. The app provides user authentication, a plant disease identifier, and a plant tracker, ensuring secure and personalized access while offering valuable tools for plant health management.

## Features

### User Authentication
- **Sign Up/Registration**: Users can create an account with their email and password for personalized access to the app.
- **Login**: Users can log in with their email and password to access their account.
- **Password Reset**: Users can reset their password via a link sent to their registered email address.

### Plant Disease Identifier
- **Capture and Upload Image**: Users can capture or upload images of their plants (supported formats: JPEG, PNG) for disease diagnosis.
- **Disease Analysis**: The app employs a machine learning model to analyze the uploaded images and identify diseases from 10 different classes, including healthy plants.
- **Results Display**: The app presents the disease name, a brief description, and recommended treatments or actions to manage the plant's health.

### Plant Tracker
- **Plant Profile Creation**: Users can create detailed profiles for their plants, including information such as name, species, planting date, and location.
- **Growth Tracking**: Users can log updates on their plant's growth, including metrics like height, number of leaves, flowering, and overall health status.
- **Reminders**: Users can set notifications for important care activities such as watering, fertilizing, pruning, and pest control, tailored to the specific needs of each plant.

## Getting Started

### Prerequisites
- Flutter SDK: [Installation Guide](https://flutter.dev/docs/get-started/install)
- Dart SDK: Included with Flutter
- Firebase Project: Create a firebase prject first to use firebase authentication and storage.
- Backend Repository: Clone and set up the backend API repository (Flask) from the corresponding repository link.

### Installation

1. Clone the repository:
   \`\`\`bash
   git clone [https://github.com/hereisamara/rootine-plantcare.git](https://github.com/hereisamara/rootine-plantcare.git)
   \`\`\`

2. Navigate to the project directory:
   \`\`\`bash
   cd rootine_flutter
   \`\`\`

3. Install dependencies:
   \`\`\`bash
   flutter pub get
   \`\`\`

4. Run the app:
   \`\`\`bash
   flutter run
   \`\`\`

### Backend Setup
For backend setup and API integration, please refer to the [Rootine Backend Repository](https://github.com/hereisamara/rootine_flask).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter documentation: [flutter.dev](https://flutter.dev/docs)
- Flask documentation: [flask.palletsprojects.com](https://flask.palletsprojects.com/en/2.0.x/)

