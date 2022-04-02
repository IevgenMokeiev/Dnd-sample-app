# Dnd-sample-app
Uses DnD 5th edition API: http://www.dnd5eapi.co/

A simple spell compendium to be used during games.

- includes possibility to cache retrieved data, so can be used offline.

- app heavily relies on SwiftUI and Combine. 

- project is separated into different layers, dependency injection is heavily used. 

- service layer is responsible for different tasks such as communication with network / db, translation and filtering. 

- model layer includes DTO, database and data layer. 

- data layer uses the next approach: data are retrieved from DB, if not present we fallback to the network data.

- master branch is written using Redux architecture, for simpler implementation see mvvm branch. Master branch also has more feature.
