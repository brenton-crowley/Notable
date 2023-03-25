# Notable
A demo app that demonstrates:
- Login functionality
- Core data storage for a user and their notes.
- Test-driven development

## Video Demonstration

https://user-images.githubusercontent.com/1415689/227746222-a3351c1c-56f1-42f3-8c6d-d2f08f7834c4.mov

## Features
- Login with users
Examples:
- | username | password
- | mike_ | 20Mike -> true
- | john01 | Ab01@1 -> false
- | nikita | ZoPW_98 -> false
- | test | test2@ -> true

- Add notes using + button
- Delete notes via swipe or tap on note name

## Learnings
### Manhours
- Around 10 development hours
- Around 5 research/tinkering hours with learning about UI tests in XCode
### TDD
- Got the job done but appreciate it's probably not best-practice as I had a learning/researching component to this.
- Had some trouble trying to identify views when using the recording feature. After some research, I discovered that one can use accessibilityIdentifier to have greater control over view identification.
- UI tests and the simulator appear super flakey when running tests or using the receording feature.
### Core Data
- Chose to not use SwiftUI api for core data such as @FetchRequest as it was a little bit easier to unit test. Go with a known quantity when introducing new content (TDD).
