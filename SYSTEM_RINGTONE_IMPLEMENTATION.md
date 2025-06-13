# System Ringtone Support Implementation

This document describes the implementation of system ringtone support for the Ultimate Alarm Clock Android app, as requested in [PR #826](https://github.com/CCExtractor/ultimate_alarm_clock/pull/826).

## Overview

The system ringtone feature allows users to select and use ringtones that are already available on their Android device, including:
- System alarm sounds
- Notification sounds  
- Phone ringtones

## Implementation Details

### 1. Android Platform Code

#### MainActivity.kt Changes
- Added a new platform channel `CHANNEL3 = "system_ringtones"`
- Implemented methods to fetch system ringtones by category
- Added playback and stop functionality for system ringtones

**Key Methods:**
- `getSystemRingtones(category: String)`: Fetches ringtones from the specified category
- `playSystemRingtone(ringtoneUri: String)`: Plays a system ringtone
- `stopSystemRingtone()`: Stops the currently playing system ringtone

### 2. Flutter Models

#### SystemRingtoneModel
A new model class to represent system ringtones with properties:
- `title`: Display name of the ringtone
- `uri`: System URI for the ringtone
- `id`: Unique identifier
- `category`: Category (alarm, notification, ringtone)

#### RingtoneModel Updates
Extended the existing `RingtoneModel` to support system ringtones:
- Added `isSystemRingtone` boolean flag
- Added `ringtoneUri` for system ringtone URIs
- Added `category` for ringtone categorization

### 3. Service Layer

#### SystemRingtoneService
A service class that handles communication with the Android platform:
- `getSystemRingtones(category)`: Get ringtones by category
- `getAllSystemRingtones()`: Get all available system ringtones
- `getSystemRingtonesByCategory()`: Get categorized ringtones
- `playSystemRingtone(uri)`: Play a system ringtone
- `stopSystemRingtone()`: Stop playback

### 4. Audio Utils Updates

Updated `AudioUtils` class to handle system ringtones:
- Modified `playAlarm()` to support system ringtones
- Updated `previewCustomSound()` for system ringtone previews
- Enhanced `stopAlarm()` to handle system ringtone stopping
- Added system ringtone support in `stopPreviewCustomSound()`

### 5. User Interface

#### SystemRingtonePicker Widget
A new widget that provides a tabbed interface for selecting system ringtones:
- **Three tabs**: Alarms, Notifications, Ringtones
- **Preview functionality**: Play/stop buttons for each ringtone
- **Selection handling**: Updates the alarm configuration
- **Loading states**: Shows progress indicator while fetching ringtones

#### ChooseRingtoneTile Updates
Enhanced the existing ringtone selection dialog:
- Added "System Ringtones" button alongside "Upload Ringtone"
- Integrated the new SystemRingtonePicker widget
- Maintained existing functionality for custom ringtones

## Features

### 1. Categorized Ringtone Selection
- **Alarm Sounds**: System alarm tones optimized for wake-up
- **Notification Sounds**: Shorter notification tones
- **Ringtones**: Phone ringtones available on the device

### 2. Preview Functionality
- Play/stop buttons for each ringtone
- Automatic stop when selecting a different ringtone
- Proper cleanup when closing the dialog

### 3. Seamless Integration
- System ringtones appear alongside custom ringtones
- Same usage counter and management system
- Consistent UI/UX with existing ringtone features

### 4. Platform Safety
- Android-only implementation (iOS gracefully returns empty lists)
- Proper error handling for missing ringtones
- Fallback to default alarm if system ringtone fails

## Technical Architecture

```
┌─────────────────────┐
│   Flutter UI        │
│ (SystemRingtonePicker)│
└─────────┬───────────┘
          │
┌─────────▼───────────┐
│ SystemRingtoneService│
│ (Platform Channel)  │
└─────────┬───────────┘
          │
┌─────────▼───────────┐
│   Android Native    │
│   (MainActivity)    │
└─────────┬───────────┘
          │
┌─────────▼───────────┐
│  Android System     │
│  (RingtoneManager)  │
└─────────────────────┘
```

## Usage Flow

1. User opens alarm creation/editing screen
2. Taps "Choose Ringtone"
3. Selects "System Ringtones" button
4. SystemRingtonePicker loads available ringtones by category
5. User browses tabs (Alarms, Notifications, Ringtones)
6. User can preview ringtones with play/stop buttons
7. User selects desired ringtone
8. System ringtone is saved to database with proper flags
9. When alarm triggers, AudioUtils plays the system ringtone

## Database Storage

System ringtones are stored in the same `RingtoneModel` table with:
- `isSystemRingtone = true`
- `ringtoneUri` containing the system URI
- `ringtonePath` left empty (not used for system ringtones)
- `category` indicating the ringtone type

## Error Handling

- Graceful fallback to default alarm if system ringtone is unavailable
- Proper error logging for debugging
- UI feedback for loading states and errors
- Platform-specific checks (Android-only functionality)

## Performance Considerations

- Lazy loading of ringtones (loaded only when dialog opens)
- Efficient caching of ringtone lists
- Proper cleanup of audio resources
- Minimal memory footprint for ringtone metadata

## Testing

The implementation has been tested for:
- ✅ Ringtone fetching from all categories
- ✅ Preview functionality (play/stop)
- ✅ Selection and saving to database
- ✅ Alarm playback with system ringtones
- ✅ Proper cleanup and resource management
- ✅ Error handling and fallbacks

## Future Enhancements

Potential improvements for future versions:
1. **Search functionality** within ringtone categories
2. **Favorites system** for frequently used ringtones
3. **Custom categories** for user organization
4. **Ringtone metadata** (duration, file size, etc.)
5. **iOS support** using native iOS APIs

## Files Modified/Created

### New Files:
- `lib/app/data/models/system_ringtone_model.dart`
- `lib/app/utils/system_ringtone_service.dart`
- `lib/app/modules/addOrUpdateAlarm/views/system_ringtone_picker.dart`

### Modified Files:
- `android/app/src/main/kotlin/.../MainActivity.kt`
- `lib/app/data/models/ringtone_model.dart`
- `lib/app/utils/audio_utils.dart`
- `lib/app/modules/addOrUpdateAlarm/views/choose_ringtone_tile.dart`

## Conclusion

This implementation provides a comprehensive system ringtone solution that integrates seamlessly with the existing Ultimate Alarm Clock architecture. It follows Android best practices, maintains code quality, and provides an excellent user experience for selecting and using system ringtones as alarm sounds. 