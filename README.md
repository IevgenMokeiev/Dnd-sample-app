# Dnd-sample-app
Simple spell navigator to be used during games.
- Uses DnD 5th edition API from http://www.dnd5eapi.co/
- includes the possibility to cache retrieved data, so can be used offline.

# Structure
- Project is separated into different layers, dependency injection is utilized. 
- Service layer is responsible for different tasks such as communication with network/ db, translation and filtering. 
- Model layer includes DTO, database and data layer.
- Data layer uses the next approach: data are retrieved from DB, if not present we fallback to the network data.

# Architecture
Master branch is written in MVVM, other notable branch is redux which uses Redux architecture.

# Frameworks
- App relies on SwiftUI and Combine. 
- Master has Unit Tests fully migrated to SwiftTesting
- Upcoming: migration from CoreData to SwiftData
