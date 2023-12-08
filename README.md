# Ultimate Alarm Clock

This project aims to build a non-conventional alarm clock with smart features such as auto-dismissal based on phone activity, weather and  more! It also includes challenges to ensure you completely wake up and an option to set shared alarms! This is the ULTIMATE alarm clock :)

<p align="center">
  <a href="https://summerofcode.withgoogle.com/programs/2023/projects/c7GIl1mf">
    <img src="https://github.com/its-me-abhishek/ultimate_alarm_clock/assets/114338679/38068ae2-39f4-4b25-9ab7-43c4cd4ac3f2" height="500" alt="GSOC">
  </a>
</p>
  
## Table of Contents
- [GetX Pattern](#getx-pattern)
- [Database Schema](#database-schema)
- [Installation & Setup](#installation--setup)
- [User Interface & Features](#user-interface--features)
- [Contribution Guidelines](#contribution-guidelines)
- [Future Plans](#future-plans)
- [Community](#community)
- [Flutter](#flutter)

## GetX Pattern

The "Ultimate Alarm Clock" project employs the GetX pattern for state management. The GetX pattern is a popular state management solution in the Flutter ecosystem, known for its simplicity, efficiency, and developer-friendly approach. It simplifies the process of managing the state of a Flutter application and helps in building reactive and performant user interfaces.

### Using `get_cli` for Project Development

The "Ultimate Alarm Clock" project uses `get_cli`, a powerful Flutter package that simplifies various aspects of project development, such as generating new pages, routes, and more. Below, we'll briefly explain how to use `get_cli` for creating new pages and touch upon the purpose of different files in a GetX-based Flutter project.

#### Installing `get_cli`

To get started with `get_cli`, you need to install it. Run the following command in your project directory:

```bash
flutter pub global activate get_cli
```

#### Creating a New Page

With `get_cli`, you can quickly generate the necessary files for a new page. Here's how you can do it:

```bash
get create page:/your_page_name
```

Replace `/your_page_name` with the desired name for your new page. This command will create several files and folders for your page, including a controller, view, and binding.

### Purpose of Different Files

- **Controller**: The controller is responsible for handling the business logic and state management of a page. It connects the UI (View) with the underlying data and functions. 
- **View**: The view represents the UI of the page. It defines how the page should look and interact with users. It focuses on the presentation of data.
- **Binding**: The binding connects the controller and view, ensuring that they work together seamlessly. It sets up dependencies, routes, and other configurations required for the page.

To learn more about the GetX, you can read the documentation [_here_](https://chornthorn.github.io/getx-docs/).

## Database Schema

The "Ultimate Alarm Clock" project utilizes multiple databases for different purposes. These databases include Firebase Firestore, ISAR, and Flutter Secure Storage. Each database serves a distinct role in managing various aspects of the application. Below we provide an overview of the schema for each of these databases. 

### Firebase Firestore

Firebase Firestore is used for real-time data synchronization and storage of user-related data. It plays a pivotal role in enabling features like shared alarms and seamless collaboration among users. Here's why Firestore is a necessary component:

- **Shared Alarms**: Firestore allows users to share alarms with one another in real-time. Users can collaborate on alarm settings, making it convenient for multiple individuals to set alarms for a common purpose.

- **Real-time Updates**: Firestore enables instant updates and synchronization of alarm data across devices and users. This means that any changes made to shared alarms are immediately reflected on all connected devices.


The schema for Firebase Firestore consists of collections and documents, and here is a summary of its structure. 


#### Users Collection
- **Attributes**:
  - `fullName` (String): User's fullname
  - `firstName` (String): User's first name
  - `lastName` (String): User's last name
  - `email` (String): User's email address
  - `id` (String): A unique identifier for each user

#### Alarms Collection
- **Attributes**:
  - `isarId` (Auto-incremented Integer): A unique identifier generated automatically by ISAR.

  - `firestoreId` (String): An optional identifier associated with Firestore. 

  - `alarmTime` (String): The time at which the alarm is set to go off.

  - `alarmID` (String): A unique identifier for each alarm.

  - `isEnabled` (Boolean): Indicates whether the alarm is enabled.

  - `isLocationEnabled` (Boolean): Indicates whether location-based features are enabled for the alarm.

  - `isSharedAlarmEnabled` (Boolean): Indicates whether the alarm is shared with other users.

  - `isWeatherEnabled` (Boolean): Indicates whether weather-related features are enabled for the alarm.

  - `isMathsEnabled` (Boolean): Indicates whether math-related features are enabled for the alarm.

  - `isShakeEnabled` (Boolean): Indicates whether the alarm can be turned off by shaking the device.

  - `isQrEnabled` (Boolean): Indicates whether QR code scanning is enabled for the alarm.

  - `intervalToAlarm` (Integer): Time interval in minutes for the alarm to go off.

  - `isActivityEnabled` (Boolean): Indicates whether activity tracking is enabled for the alarm.

  - `location` (String): The location associated with the alarm.

  - `activityInterval` (Integer): Interval for activity tracking, in minutes.

  - `minutesSinceMidnight` (Integer): The number of minutes since midnight when the alarm is set.

  - `days` (List of Booleans): A list representing the days on which the alarm should repeat.

  - `weatherTypes` (List of Integers): List of weather conditions for the alarm.

  - `shakeTimes` (Integer): Number of times the device must be shaken to turn off the alarm.

  - `numMathsQuestions` (Integer): The number of math questions for the alarm.

  - `mathsDifficulty` (Integer): The difficulty level of math questions.

  - `qrValue` (String): The QR code value associated with the alarm.

  - `sharedUserIds` (List of Strings): User IDs with whom the alarm is shared.

  - `ownerId` (String): The user ID of the alarm owner.

  - `ownerName` (String): The name of the alarm owner.

  - `lastEditedUserId` (String): User ID of the last user who edited the alarm.

  - `mutexLock` (Boolean): A flag indicating whether a mutex lock is applied to the alarm.

  - `mainAlarmTime` (String): The main time at which the alarm is set.

  - `label` (String): A label or description associated with the alarm.

  - `isOneTime` (Boolean): Indicates whether the alarm is a one-time alarm.

  - `snoozeDuration` (Integer): The snooze duration for the alarm, in minutes.

  - `offsetDetails` (Map, Ignored): A map containing additional offset details.

### ISAR 

ISAR is the go-to solution for local storage of alarm-related data. It facilitates the efficient and structured management of alarm settings and preferences, ensuring that alarms function smoothly even in offline scenarios. ISAR optimizes data retrieval, enabling quick access to triggered alarms and user-specific configurations. Its performance efficiency and data integrity make it an essential component, ensuring that alarms trigger accurately and promptly. ISAR complements Firestore's real-time data synchronization, offering a responsive local data store to enhance the overall user experience. 

The key reasons for utilizing IsarDb are as follows:

- **Offline Functionality**: IsarDb ensures that alarms function seamlessly even in offline scenarios. Users can trust that their alarms will trigger as expected, regardless of their internet connection status.

- **Performance Optimization**: IsarDb optimizes data retrieval, allowing for quick access to triggered alarms and user-specific configurations. It enhances the overall performance and responsiveness of the application.

The schema for this data is already described above.

### Flutter Secure Storage

The Flutter Secure Storage library is utilized in the "Ultimate Alarm Clock" project for securely storing various settings and preferences. This storage solution employs key-value pairs to manage and access data. Below are the keys and their associated purposes:

- `userModel`: Stores user-related data in a JSON-encoded format, including user settings and preferences.

- `weather_state`: Stores the current weather state information.

- `API keys`: Several keys are used for storing API keys securely, allowing the application to access external services.

- `Haptic Feedback`: Key-value pairs are used to store and manage user preferences related to haptic feedback settings.

- `Sorted Alarm List`: Key-value pairs are used to store and manage user preferences for sorting the alarm list.

- `theme_value`: Stores the selected theme (e.g., dark or light) for the application.

Flutter Secure Storage is instrumental in ensuring the security and privacy of sensitive user data and preferences, contributing to a seamless and secure user experience in the "Ultimate Alarm Clock" project.

## Installation & Setup
### Prerequisites
Before getting started, ensure you have the following prerequisites installed on your system:

- [Flutter](https://flutter.dev/docs/get-started/install): Install the latest version of Flutter, including Dart SDK, by following the official installation guide.

- [Git](https://git-scm.com/downloads): Version control tool to clone the project's repository.

- A code editor such as [Visual Studio Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio) with Flutter and Dart plugins.


### Installation Steps

1. **Clone the Repository**:

   Open your terminal or command prompt and navigate to the directory where you want to store the project. Then, run the following command to clone the repository:

   ```bash
   git clone https://github.com/CCExtractor/ultimate_alarm_clock.git
   ```
   
2. **Navigate to the Project Directory**:

   Change your working directory to the project folder:
   
   ```bash
   cd ultimate-alarm-clock
   ```
   
3. **Install Dependencies**:
   
   Use the `flutter pub get` command to install the project's dependencies:

   ```bash
   flutter pub get
   ```
   
4. **Run the Application**:
  
   You can run the application on a connected device (emulator or physical device) using the following command:

   ```bash
   flutter run
   ```
   
This command will compile and launch the "Ultimate Alarm Clock" app on your device.


## User Interface & Features

The "Ultimate Alarm Clock" offers a user-friendly and versatile interface designed to meet your alarm management needs. This section provides an overview of the app's user interface, highlighting key features and functionalities.

### Splash Screen
- The app opens with a welcoming splash screen, providing a brief introduction to the application.
<img src="https://github.com/its-me-abhishek/ultimate_alarm_clock/assets/114338679/ae0ad406-6b6a-432f-8fec-e363bc0aa14c" height="300" alt="splash">
<img src="https://github.com/its-me-abhishek/ultimate_alarm_clock/assets/114338679/dad3ce66-3fed-4075-926d-cf29231a5e3c" height="300" alt="splash2">

### Light and Dark Modes
- The "Ultimate Alarm Clock" offers both light and dark modes to suit your preferred theme and enhance readability in different lighting conditions.
<img src="https://github.com/its-me-abhishek/ultimate_alarm_clock/assets/114338679/3f1669a0-b860-4047-9a0f-2b7af5dabaae" height="300" alt="dark">
<img src="https://github.com/its-me-abhishek/ultimate_alarm_clock/assets/114338679/621bff1f-9aa1-4630-a5bc-1f5fc85ddb66" height="300" alt="light">

### Home View
- After the splash screen, you are directed to the Home View, where you can manage your alarms.
- The Home View allows you to:
  - View all your alarms.
  - Toggle alarms on/off.
  - Preview alarms.
  - Delete alarms.
  - Edit alarms.
  - Create new alarms using the floating action button.
- A settings icon in the app bar provides access to the Settings View.
<img src="https://github.com/its-me-abhishek/ultimate_alarm_clock/assets/114338679/46206641-3e62-4e5d-b8a9-5cfb93f1c18a" height="300" alt="home">


### Settings View
- In the Settings View, you can customize various aspects of the app:
  - Set or edit the weather API key for weather-related features.
  - Log in with your Google account.
  - Toggle haptic feedback on/off.
  - Toggle the sorting of the alarm list based on time.
  - Toggle between light and dark modes.
<img src="https://github.com/its-me-abhishek/ultimate_alarm_clock/assets/114338679/ac18497b-4533-46e5-a6fa-9382300a4caa" height="300" alt="settings">

### Add or Update Alarm View
- The floating action button in the Home View allows you to create alarms, directing you to the Add or Update Alarm View.
- In this view, you can:
  - Set the alarm time using a time picker or manually entering time using keyboard.
  - Configure alarm repetition.
  - Set the snooze duration.
  - Add a label to the alarm.
  - Define automatic cancellation conditions based on screen activity, weather, and location.
  - Choose from challenges, including shake to dismiss, QR code, and math challenges.
  - Manage shared alarms.

<img src="https://github.com/its-me-abhishek/ultimate_alarm_clock/assets/114338679/f856d436-1ba4-4f1f-8297-1396627d9218" height="300" alt="add-alarm-1">
<img src="https://github.com/its-me-abhishek/ultimate_alarm_clock/assets/114338679/5f0dd9be-0afa-4b91-b084-5be949dce2df" height="300" alt="add-alarm-2">

### Shared Alarms

The "Ultimate Alarm Clock" project introduces the feature of shared alarms, allowing users to collaborate with friends, family members, or colleagues to ensure they wake up on time.

#### Creating and Joining Shared Alarms

1. **Google Sign-In**: To create or join a shared alarm, users must first sign in with their Google account. This authentication step ensures that only registered users can access this feature and maintains the security of shared alarms.

2. **Creating a Shared Alarm**:

   - From the Home View, users can create a new alarm by tapping the "Create Alarm" button.
   - During the alarm creation process, users have the option to make it a "shared alarm."

3. **Joining an Existing Shared Alarm**:

   - Users can join an existing shared alarm by entering a unique shared alarm ID or accepting an invitation from the owner.
   - The shared alarm ID is a unique code that the owner shares with potential collaborators.


#### Implementation of Shared Alarms

##### `addUserToAlarmSharedUsers`

The `addUserToAlarmSharedUsers` function enables users to add new collaborators to a shared alarm. Here's how it works:

- When a user initiates the process to join a shared alarm, this function is called.
- It begins by checking whether the provided alarm ID exists in the database.
- If the alarm ID is not found, the function returns `false`, indicating that the addition process failed.
- If the alarm ID is found, the function proceeds to add the user as a collaborator.
- If the user is the owner of the alarm, the function returns `null`, preventing the owner from being added as a collaborator.
- The function then updates the list of shared user IDs and offset details for the alarm. It sets `isOffsetBefore` to `true`, `offsetDuration` to `0`, and `offsettedTime` to the alarm's original time.
- The user is added to the list of shared user IDs, and the changes are instantly synchronized with all collaborators.

##### `removeUserFromAlarmSharedUsers`

The `removeUserFromAlarmSharedUsers` function allows the owner of a shared alarm, to remove a collaborator from the shared alarm. Here's how it works:

- When the owner initiates the removal process, this function is called.
- Similar to the previous function, it begins by checking whether the provided alarm ID exists in the database.
- If the alarm ID is not found, the function returns an empty list, indicating that the removal process failed due to the alarm's non-existence.
- If the alarm ID is found, the function proceeds to remove the specified user from the list of shared user IDs.
- After the removal, the function updates the shared user IDs for the alarm, and the changes are immediately synchronized with all collaborators.

##### `streamAlarms`

1. **Data Sources**: It combines data from three primary data sources:
   - **Firestore**: Alarms stored in the Firestore database.
   - **Shared Alarms**: Alarms shared with the user through collaboration.
   - **IsarDB**: Alarms stored locally for offline use.

2. **Data Transformation**: The function processes the data retrieved from these sources. This transformation includes converting the raw document snapshots into `AlarmModel` objects, a data structure that represents alarm records.

3. **Sorting**: Depending on user preferences, the alarms are sorted. Users have the option to enable or disable sorting, and two different sorting methods are applied based on this preference:
   - **Time-Based Sorting**: If the sorting preference is enabled, the alarms are sorted in ascending order based on their scheduled time.
   - **Priority Sorting**: If the sorting preference is disabled, the alarms are organized based on priority:
     - First, the enabled alarms are listed ahead of disabled ones.
     - Then, alarms are sorted by their upcoming time, factoring in repetition patterns and immediate execution for one-time alarms.

4. **Returned Stream**: After these processes, the function returns a stream (`streamAlarms`) that represents the list of alarms. This stream reflects the real-time status of alarms and is used to update the user interface whenever alarms are added, modified, or removed.

The "Ultimate Alarm Clock" offers an intuitive and feature-rich user interface, making it easy to set, manage, and customize your alarms while providing a seamless experience.

## Contribution Guidelines

Thank you for your interest in contributing to the "Ultimate Alarm Clock" project. Contributions from the open-source community are highly valued and help improve the application. Please read the following guidelines to understand how you can contribute effectively.

### How to Contribute

1. **Fork the Repository**: Start by forking the project's repository to your own GitHub account.

2. **Clone the Repository**: Clone the forked repository to your local development environment using the `git clone` command.

   ```bash
   git clone https://github.com/your-username/ultimate-alarm-clock.git
   ```
3. **Create a Branch**: Create a new branch for your contributions, giving it a descriptive name.

   ```bash
   git checkout -b your-feature-name
   ```
   
4. **Make Changes**: Make your desired changes, improvements, or bug fixes in your local environment.

5. **Test**: Ensure that your changes do not introduce new issues and do not break existing features. Test your code thoroughly.

6. **Documentation**: If your changes impact the user interface, configuration, or functionality, update the documentation to reflect the changes.

7. **Commit**: Commit your changes with a clear and concise message.
   ```bash
   git commit -m "Add feature/fix: Describe your changes here"
   ```

8. **Push Changes**: Push your changes to your GitHub fork.
   ```bash
   git push origin your-feature-name
   ```

9. **Pull Request**: Create a Pull Request (PR) from your fork to the original repository. Ensure your PR has a clear title and description outlining the changes.

10. **Code Review**: Your PR will undergo code review. Make any necessary adjustments based on feedback.

11. **Merge**: Once your PR is approved, it will be merged into the main project repository.

### Guidelines

- Be respectful and considerate when contributing and interacting with the community.
- Follow the project's coding style, conventions, and best practices.
- Keep your PR focused on a single issue or feature. If you wish to contribute multiple changes, create separate branches and PRs for each.
- Provide a detailed and clear description of your PR, including the purpose of the changes and any related issues.
- Ensure that your code is well-documented and that any new features or changes are reflected in the project's documentation.
- Make sure your contributions do not introduce security vulnerabilities or cause regressions.

### Reporting Issues

If you find a bug or have a suggestion for improvement, please create an [issue](https://github.com/CCExtractor/ultimate_alarm_clock/issues/new) on the project's GitHub repository. Be sure to include a clear and detailed description of the problem or enhancement.

We appreciate your contributions to the "Ultimate Alarm Clock" project, and your help is invaluable in making it even better.

If you have any questions regarding something in the project, do not hestitate to ask :)

## Future Plans

#### Default Alarm Ringtones

- In addition to custom ringtones, we will also provide a selection of default alarm tones. These default options will cater to a variety of preferences and ensure that users have a range of options to choose from.

#### Timer Functionality

- We are working on implementing timer functionality within the app. This will expand the utility of the "Ultimate Alarm Clock" beyond traditional alarm features, allowing users to set countdown timers for various purposes.

#### Architectural and Data Flow Changes

- We have plans to make architectural and data flow changes within the application to enhance its overall performance and maintainability. These changes will optimize resource utilization and streamline the user experience.

## Community

We would love to hear from you! You may join the CCExtractor community through Slack:

[![Slack](https://img.shields.io/badge/chat-on_slack-purple.svg?style=for-the-badge&logo=slack)](https://ccextractor.org/public/general/support/)

## Flutter

For help in getting started with Flutter, view
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
