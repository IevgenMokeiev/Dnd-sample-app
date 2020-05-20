# Dnd-sample-app
uses DnD 5th edition API from http://www.dnd5eapi.co/
simple spell navigator to be used during games
includes possibility to cache retrieved data, so can be used offline

App heavily relies on SwiftUI and Combine. 

Project is separated into different layers, dependency injection is heavily used. 

Service layer is responsible for different tasks such as communication with network/ db, translation and filtering. 
Model layer includes DTO, database and data layer. 

Data layer uses the next approach: data are retrieved from DB, if not present we fallback to the network data.
