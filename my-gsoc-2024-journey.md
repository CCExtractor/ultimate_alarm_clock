# My GSoC 2024 Journey with CCExtractor

Three months ago, I was just another computer science student at Medhavi Skills University, scrolling through GSoC organization lists and wondering if I'd ever be good enough to contribute to real open-source projects. Today, I'm writing this blog after successfully completing my first Google Summer of Code with CCExtractor, having worked on the Ultimate Alarm Clock project.

## How It All Started

I discovered CCExtractor while looking for organizations that work with Flutter. Honestly, I was intimidated at first. The idea of working with experienced developers on a project that thousands of people actually use felt overwhelming. But when I joined their Slack community, something clicked. Everyone was so welcoming and genuinely excited to help newcomers. The mentors didn't just answer questions - they explained the reasoning behind decisions and made me feel like my contributions mattered.

After reading about their projects and seeing the work done by previous GSoC contributors, I knew I wanted to be part of this community. I decided to focus solely on CCExtractor for my application.

## The Project That Changed Everything

The Ultimate Alarm Clock isn't your typical wake-up app. When I first explored the codebase, I was amazed by how sophisticated it was. This thing had weather-based alarms, location conditions, shake-to-wake challenges, and so much more. Built with Flutter, Firebase, and GetX, it was already helping people wake up smarter.

But my job was to make it even better. I proposed 10 major features that would transform how users interact with their alarms, and somehow, the mentors believed in my vision.

## What I Actually Built

Let me tell you about the features I implemented during those intense three months:

**Completed Shared Alarm System** - The app already had partial shared alarm functionality, but it was buggy and incomplete. I took it from half-working to fully functional. Now users can share alarms with family or roommates via email, get in-app notifications to accept or reject them, and the alarms actually work reliably even when the app is killed.

**Negative Conditions for Smart Controls** - This was a brain-bender. I built a system where alarms can trigger based on inverse conditions - like waking you up when you're NOT at a specific location or when the weather is NOT rainy. It required completely rethinking the existing smart control logic.

**Alarm History and Insights** - Added a comprehensive system to track alarm patterns and provide insights. Users can now see their wake-up consistency, most frequent alarm times, and get troubleshooting information when alarms don't work as expected.

**Timezone-Aware Alarms** - Built functionality for alarms that work across different time zones. Perfect for travelers or people coordinating with others in different locations. The DST transitions were particularly tricky to handle correctly.

**Advanced Snooze Customization** - Users can now set maximum snooze limits and use smart snooze with decreasing intervals. No more infinite snoozing that makes you late for everything important.

**Sunrise Alarm Feature** - Implemented a gentle wake-up system that gradually brightens the screen before the alarm rings, simulating natural sunlight. Added ambient sound options like forest sounds and birds chirping to complement the visual effect.

**Unified UI Components** - Created a consistent design system throughout the app. This wasn't glamorous work, but it made the app feel much more polished and professional.

**Major UI Overhaul** - Replaced jarring popups with smooth bottom sheet navigators and full-screen interfaces where appropriate. Made the entire app responsive for different screen sizes. The app actually looks and feels modern now.

**Fixed Ascending Volume** - The gradual volume increase feature was broken and inconsistent. I rebuilt it to work reliably across different devices and Android versions.

**Guardian Angel Feature** - My personal favorite. If you fail to wake up for important alarms, it automatically contacts someone you trust via call or SMS. I implemented this thinking about students with crucial exams or people with important job interviews.

The real learning happened in the countless bug fixes and small improvements that users will never notice but make the app actually work reliably.

## The Reality Check: My Biggest Challenge

Completing the shared alarm system almost broke me. I'm not exaggerating.

The previous implementation was there but barely worked. Users could share alarms, but they'd randomly stop working, wouldn't sync properly, or worse - wouldn't ring at all when the app was closed. I had to essentially rebuild the entire system from scratch while keeping it backward compatible.

The Firebase Cloud Messaging integration was tricky enough, but the real nightmare was ensuring alarms would persist and actually ring even when the app was completely killed. Android's battery optimization features kept interfering, and different phone manufacturers handle background processes differently. I spent weeks testing on various devices just to make sure a shared alarm would wake someone up reliably.

The negative smart controls were another massive headache. Imagine creating alarms that trigger when you're NOT somewhere or when the weather is NOT something specific. It sounds simple until you realize you're essentially inverting the entire existing logic while keeping everything reliable. I had to rewrite significant portions of the condition checking system.

I remember spending an entire week debugging why timezone-aware alarms would randomly fail during DST transitions. Turned out to be a combination of Android's timezone handling and my own logic errors. When it finally worked correctly, I might have shouted in excitement in the library.

## What I Actually Learned

I have to be honest - I didn't write the Kotlin migration code myself. The team had already started that work. But working with the migrated codebase taught me so much about how different languages can work together in one app. It's like watching a well-choreographed dance between Dart and Kotlin.

The biggest lesson wasn't technical though. It was understanding how real software projects work. Before GSoC, my experience was mostly solo coding assignments. Suddenly I was doing code reviews, following Git workflows, writing documentation, and collaborating with people I'd never met in person. GitHub went from being just a code storage place to this living, breathing collaboration platform.

My debugging skills improved dramatically too. When you're working on an app that actual people use daily, you can't just restart your development server when something breaks. You have to actually fix it properly.

## My Mentor Made the Difference

I got lucky with my mentor. They weren't just there to answer questions - though they did that patiently, even when I asked the same thing three different ways. They helped me understand why we made certain architectural decisions, not just how to implement them.

When I got stuck on the Firebase authentication flow for shared alarms, instead of just giving me the solution, they walked me through the documentation and helped me figure it out myself. That approach taught me how to solve problems independently, which has been invaluable.

## Beyond the Code

This experience changed how I think about programming. Before GSoC, I coded for grades or personal projects. Now I code thinking about the person who might use this feature at 6 AM when they're barely awake and just need their alarm to work.

Working with contributors from different time zones was wild. I'd push code before going to bed and wake up to thoughtful code reviews from someone halfway across the world. Open source really is a 24/7 global collaboration.

Some bugs took me days to solve. I learned that sometimes you need to step away from the computer, take a walk, and come back with fresh eyes. Persistence is important, but so is knowing when to take a break.

## The Real Impact Hit Me Later

A few weeks into the project, someone on the CCExtractor Slack mentioned they'd been using the Guardian Angel feature because they were on important medication and couldn't afford to oversleep. That comment hit me harder than any grade I'd ever received. My code was actually helping someone with something that mattered.

The shared alarm feature started getting used by families to coordinate wake-up times and by study groups to make sure everyone showed up for early morning sessions. Seeing these real-world use cases made all those late-night debugging sessions worth it.

## If You're Thinking About Applying

Don't wait until the last minute to explore organizations. I started looking at CCExtractor in January, joined their community, and understood their culture long before applications opened. That preparation made my proposal much stronger.

Contribute something small first. I fixed a tiny UI bug before applying, which showed the mentors I could actually work with their codebase. It doesn't have to be groundbreaking - just something that demonstrates you can follow their development process.

Write your proposal like you're explaining to a friend, not like you're writing a research paper. Be specific about what you want to build and why it matters to users.

Most importantly, be genuine in your application. Don't just list technologies you've used - explain what you learned from using them and what challenges you overcame.

## What's Next

GSoC is over, but my relationship with CCExtractor isn't. I'm still active in their community, helping new contributors and continuing to work on the Ultimate Alarm Clock. The project has become something I genuinely care about.

This experience opened doors I didn't even know existed. I've started looking at other open source projects differently, not as intimidating monsters but as communities of people solving interesting problems together.

To future GSoC students: it's going to be harder than you think and more rewarding than you can imagine. Embrace the struggle, ask questions, and remember that everyone in the open source community was a beginner once.

Oh, and make sure your actual alarm clock works while you're building alarm clock software. Trust me on this one.

## Project Technical Details

### Features Implemented

#### 1. Profile Switcher and Alarm/Profile Sharing
- Effortless management of custom alarm profiles for different days and occasions
- Alarm and profile sharing with other users using email addresses
- In-app notifications for received alarms/profiles with accept/reject options
- Issue: [#591](https://github.com/CCExtractor/ultimate_alarm_clock/issues/591)
- Pull Request: [#584](https://github.com/CCExtractor/ultimate_alarm_clock/pull/584)

#### 2. Google Calendar Integration and Date-based Scheduling
- Integration with Google Calendar to import reminders and events
- Automatic alarm creation from calendar events
- Date-specific alarm scheduling capabilities
- Issue: [#590](https://github.com/CCExtractor/ultimate_alarm_clock/issues/590)
- Pull Request: [#584](https://github.com/CCExtractor/ultimate_alarm_clock/pull/584)

#### 3. Guardian Angel Feature
- Emergency contact system for important alarms
- Automatic call/SMS to designated contacts if user fails to wake up
- Configurable timer for activation after inactivity
- Issue: [#592](https://github.com/CCExtractor/ultimate_alarm_clock/issues/592)
- Pull Request: [#584](https://github.com/CCExtractor/ultimate_alarm_clock/pull/584)

#### 4. Anti-disturbance Smart Controls
- Automatic alarm dismissal when screen is active for extended periods
- Intelligent detection of user activity to prevent unnecessary interruptions
- Issue: [#572](https://github.com/CCExtractor/ultimate_alarm_clock/issues/572)
- Pull Request: [#574](https://github.com/CCExtractor/ultimate_alarm_clock/pull/574)

#### 5. Enhanced Weather and Location Services
- Migration to Open-Meteo API for seamless weather integration
- No API key required, reducing setup friction
- Background location access notifications
- Weather and location-based logic shifted to Kotlin for better performance
- Issue: [#579](https://github.com/CCExtractor/ultimate_alarm_clock/issues/579)
- Pull Request: [#580](https://github.com/CCExtractor/ultimate_alarm_clock/pull/580)

#### 6. Revamped Timer System
- Multiple timer support with intuitive UI
- Notification display when app is minimized
- Direct Kotlin database access for improved performance
- Elimination of Flutter dependency for data operations
- Issue: [#564](https://github.com/CCExtractor/ultimate_alarm_clock/issues/564)
- Pull Request: [#565](https://github.com/CCExtractor/ultimate_alarm_clock/pull/565)

#### 7. Cross-Communication Infrastructure
- Migration from ISAR to SQLite databases
- Enhanced cross-language data accessibility
- Streamlined native feature integration
- Elimination of Method Channel dependency for background operations
- Issue: [#562](https://github.com/CCExtractor/ultimate_alarm_clock/issues/562)
- Pull Request: [#563](https://github.com/CCExtractor/ultimate_alarm_clock/pull/563)

#### 8. Audio System Improvements
- Addition of 5 new royalty-free ringtones
- Fixed erratic ringtone preview behavior
- Enhanced audio playback reliability
- Issue: [#595](https://github.com/CCExtractor/ultimate_alarm_clock/issues/595)
- Pull Request: [#596](https://github.com/CCExtractor/ultimate_alarm_clock/pull/596)

#### 9. Backend Architecture Migration
- Alarm scheduling logic migrated from Flutter to Kotlin
- Smart controls logic moved to native Android implementation
- Reduced background app launches and improved battery efficiency
- Pull Requests: [#563](https://github.com/CCExtractor/ultimate_alarm_clock/pull/563), [#574](https://github.com/CCExtractor/ultimate_alarm_clock/pull/574), [#580](https://github.com/CCExtractor/ultimate_alarm_clock/pull/580)

#### 10. UI and Bug Fixes
- Fixed weekday scheduling logic issues
- Resolved multiple controller errors across different modules
- New UI design for alarm and profile setting screens
- Improved Firebase Auth implementation
- Enhanced overall app stability and user experience

### Merged Pull Requests

| No | PR No | Description |
|----|-------|-------------|
| 1 | [#641](https://github.com/CCExtractor/ultimate_alarm_clock/pull/641) | Exit Preview button to the Alarm Control Screen |
| 2 | [#648](https://github.com/CCExtractor/ultimate_alarm_clock/pull/648) | Clear button behavior fix in math challenge screen |
| 3 | [#669](https://github.com/CCExtractor/ultimate_alarm_clock/pull/669) | AM/PM text completion fix in addOrUpdateAlarm |
| 4 | [#686](https://github.com/CCExtractor/ultimate_alarm_clock/pull/686) | Screen Activity Toggle Button State Issue fix |
| 5 | [#698](https://github.com/CCExtractor/ultimate_alarm_clock/pull/698) | AM/PM Toggle on Boundary Transition fix |
| 6 | [#715](https://github.com/CCExtractor/ultimate_alarm_clock/pull/715) | Text overflow resolution in WeatherTile |
| 7 | [#722](https://github.com/CCExtractor/ultimate_alarm_clock/pull/722) | Bottom overflow fix in SnoozeDurationTile |
| 8 | [#728](https://github.com/CCExtractor/ultimate_alarm_clock/pull/728) | Timer animation UI fix for small screens |
| 9 | [#759](https://github.com/CCExtractor/ultimate_alarm_clock/pull/759) | Guardian Angel Feature Validation |
| 10 | [#763](https://github.com/CCExtractor/ultimate_alarm_clock/pull/763) | Consistent Undo Duration Implementation |
| 11 | [#769](https://github.com/CCExtractor/ultimate_alarm_clock/pull/769) | Alarm Reliability Improvements and Debug Screen |
| 12 | [#782](https://github.com/CCExtractor/ultimate_alarm_clock/pull/782) | One-time alarms state fix after ringing |
| 13 | [#787](https://github.com/CCExtractor/ultimate_alarm_clock/pull/787) | Preview exit error page fix |
| 14 | [#789](https://github.com/CCExtractor/ultimate_alarm_clock/pull/789) | GetX pattern implementation for debug module |
| 15 | [#797](https://github.com/CCExtractor/ultimate_alarm_clock/pull/797) | Dismiss error resolution |
| 16 | [#801](https://github.com/CCExtractor/ultimate_alarm_clock/pull/801) | Alarm deletion issues and update prevention fix |

### Technologies Used

- **Frontend**: Flutter, Dart
- **Backend**: Firebase Firestore, Firebase Auth, Firebase Cloud Messaging
- **Native Development**: Kotlin (Android)
- **Database**: SQLite (migrated from ISAR)
- **State Management**: GetX
- **APIs**: Google Calendar API, Open-Meteo Weather API
- **Architecture**: Clean Architecture with Repository Pattern

### Project Repository

**GitHub**: [CCExtractor/ultimate_alarm_clock](https://github.com/CCExtractor/ultimate_alarm_clock)
**GSoC 2024 Features**: Available in the main branch
**Final Submission Commit**: [9e93856](https://github.com/CCExtractor/ultimate_alarm_clock/commit/9e93856)

---

**Author**: Mahendra Kasula  
**University**: Medhavi Skills University  
**GSoC 2024 Organization**: CCExtractor  
**Contact**: kasulamahi624@gmail.com  
**LinkedIn**: [MAHENDRA KASULA](https://linkedin.com/in/mahendra-kasula)  
**GitHub**: [mahendra-918](https://github.com/mahendra-918)