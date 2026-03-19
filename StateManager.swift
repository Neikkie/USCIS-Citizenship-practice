//
//  StateManager.swift
//  USCIS Citizenship practice
//
//  Created by Shanique Beckford on 2/22/26.
//

import Foundation
import Combine

// US State information for USCIS civics questions
struct USState: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let capital: String
    let governor: String // Current as of 2026
    let senators: [String] // Current as of 2026
    
    var displayName: String {
        return name
    }
}

class StateManager: ObservableObject {
    @Published var selectedState: USState? {
        didSet {
            saveState()
        }
    }
    
    @Published var hasSelectedState: Bool = false
    
    private let userDefaults = UserDefaults.standard
    private let stateKey = "selectedState"
    
    // All 50 US states with current 2026 information
    let allStates: [USState] = [
        USState(id: "AL", name: "Alabama", capital: "Montgomery", governor: "Kay Ivey", senators: ["Katie Britt", "Tommy Tuberville"]),
        USState(id: "AK", name: "Alaska", capital: "Juneau", governor: "Mike Dunleavy", senators: ["Lisa Murkowski", "Dan Sullivan"]),
        USState(id: "AZ", name: "Arizona", capital: "Phoenix", governor: "Katie Hobbs", senators: ["Mark Kelly", "Ruben Gallego"]),
        USState(id: "AR", name: "Arkansas", capital: "Little Rock", governor: "Sarah Huckabee Sanders", senators: ["John Boozman", "Tom Cotton"]),
        USState(id: "CA", name: "California", capital: "Sacramento", governor: "Gavin Newsom", senators: ["Alex Padilla", "Adam Schiff"]),
        USState(id: "CO", name: "Colorado", capital: "Denver", governor: "Jared Polis", senators: ["Michael Bennet", "John Hickenlooper"]),
        USState(id: "CT", name: "Connecticut", capital: "Hartford", governor: "Ned Lamont", senators: ["Richard Blumenthal", "Chris Murphy"]),
        USState(id: "DE", name: "Delaware", capital: "Dover", governor: "Matt Meyer", senators: ["Tom Carper", "Chris Coons"]),
        USState(id: "FL", name: "Florida", capital: "Tallahassee", governor: "Ron DeSantis", senators: ["Marco Rubio", "Rick Scott"]),
        USState(id: "GA", name: "Georgia", capital: "Atlanta", governor: "Brian Kemp", senators: ["Jon Ossoff", "Raphael Warnock"]),
        USState(id: "HI", name: "Hawaii", capital: "Honolulu", governor: "Josh Green", senators: ["Brian Schatz", "Mazie Hirono"]),
        USState(id: "ID", name: "Idaho", capital: "Boise", governor: "Brad Little", senators: ["Mike Crapo", "Jim Risch"]),
        USState(id: "IL", name: "Illinois", capital: "Springfield", governor: "J.B. Pritzker", senators: ["Dick Durbin", "Tammy Duckworth"]),
        USState(id: "IN", name: "Indiana", capital: "Indianapolis", governor: "Mike Braun", senators: ["Todd Young", "Jim Banks"]),
        USState(id: "IA", name: "Iowa", capital: "Des Moines", governor: "Kim Reynolds", senators: ["Chuck Grassley", "Joni Ernst"]),
        USState(id: "KS", name: "Kansas", capital: "Topeka", governor: "Laura Kelly", senators: ["Roger Marshall", "Jerry Moran"]),
        USState(id: "KY", name: "Kentucky", capital: "Frankfort", governor: "Andy Beshear", senators: ["Mitch McConnell", "Rand Paul"]),
        USState(id: "LA", name: "Louisiana", capital: "Baton Rouge", governor: "Jeff Landry", senators: ["Bill Cassidy", "John Kennedy"]),
        USState(id: "ME", name: "Maine", capital: "Augusta", governor: "Janet Mills", senators: ["Susan Collins", "Angus King"]),
        USState(id: "MD", name: "Maryland", capital: "Annapolis", governor: "Wes Moore", senators: ["Ben Cardin", "Chris Van Hollen"]),
        USState(id: "MA", name: "Massachusetts", capital: "Boston", governor: "Maura Healey", senators: ["Elizabeth Warren", "Ed Markey"]),
        USState(id: "MI", name: "Michigan", capital: "Lansing", governor: "Gretchen Whitmer", senators: ["Gary Peters", "Elissa Slotkin"]),
        USState(id: "MN", name: "Minnesota", capital: "St. Paul", governor: "Tim Walz", senators: ["Amy Klobuchar", "Tina Smith"]),
        USState(id: "MS", name: "Mississippi", capital: "Jackson", governor: "Tate Reeves", senators: ["Roger Wicker", "Cindy Hyde-Smith"]),
        USState(id: "MO", name: "Missouri", capital: "Jefferson City", governor: "Mike Kehoe", senators: ["Josh Hawley", "Eric Schmitt"]),
        USState(id: "MT", name: "Montana", capital: "Helena", governor: "Greg Gianforte", senators: ["Jon Tester", "Tim Sheehy"]),
        USState(id: "NE", name: "Nebraska", capital: "Lincoln", governor: "Jim Pillen", senators: ["Deb Fischer", "Pete Ricketts"]),
        USState(id: "NV", name: "Nevada", capital: "Carson City", governor: "Joe Lombardo", senators: ["Catherine Cortez Masto", "Jacky Rosen"]),
        USState(id: "NH", name: "New Hampshire", capital: "Concord", governor: "Kelly Ayotte", senators: ["Jeanne Shaheen", "Maggie Hassan"]),
        USState(id: "NJ", name: "New Jersey", capital: "Trenton", governor: "Phil Murphy", senators: ["Cory Booker", "George Helmy"]),
        USState(id: "NM", name: "New Mexico", capital: "Santa Fe", governor: "Michelle Lujan Grisham", senators: ["Martin Heinrich", "Ben Ray Luján"]),
        USState(id: "NY", name: "New York", capital: "Albany", governor: "Kathy Hochul", senators: ["Chuck Schumer", "Kirsten Gillibrand"]),
        USState(id: "NC", name: "North Carolina", capital: "Raleigh", governor: "Josh Stein", senators: ["Ted Budd", "Thom Tillis"]),
        USState(id: "ND", name: "North Dakota", capital: "Bismarck", governor: "Kelly Armstrong", senators: ["John Hoeven", "Kevin Cramer"]),
        USState(id: "OH", name: "Ohio", capital: "Columbus", governor: "Mike DeWine", senators: ["Sherrod Brown", "Bernie Moreno"]),
        USState(id: "OK", name: "Oklahoma", capital: "Oklahoma City", governor: "Kevin Stitt", senators: ["James Lankford", "Markwayne Mullin"]),
        USState(id: "OR", name: "Oregon", capital: "Salem", governor: "Tina Kotek", senators: ["Ron Wyden", "Jeff Merkley"]),
        USState(id: "PA", name: "Pennsylvania", capital: "Harrisburg", governor: "Josh Shapiro", senators: ["Bob Casey", "John Fetterman"]),
        USState(id: "RI", name: "Rhode Island", capital: "Providence", governor: "Dan McKee", senators: ["Jack Reed", "Sheldon Whitehouse"]),
        USState(id: "SC", name: "South Carolina", capital: "Columbia", governor: "Henry McMaster", senators: ["Lindsey Graham", "Tim Scott"]),
        USState(id: "SD", name: "South Dakota", capital: "Pierre", governor: "Kristi Noem", senators: ["John Thune", "Mike Rounds"]),
        USState(id: "TN", name: "Tennessee", capital: "Nashville", governor: "Bill Lee", senators: ["Marsha Blackburn", "Bill Hagerty"]),
        USState(id: "TX", name: "Texas", capital: "Austin", governor: "Greg Abbott", senators: ["John Cornyn", "Ted Cruz"]),
        USState(id: "UT", name: "Utah", capital: "Salt Lake City", governor: "Spencer Cox", senators: ["Mike Lee", "John Curtis"]),
        USState(id: "VT", name: "Vermont", capital: "Montpelier", governor: "Phil Scott", senators: ["Bernie Sanders", "Peter Welch"]),
        USState(id: "VA", name: "Virginia", capital: "Richmond", governor: "Glenn Youngkin", senators: ["Mark Warner", "Tim Kaine"]),
        USState(id: "WA", name: "Washington", capital: "Olympia", governor: "Bob Ferguson", senators: ["Patty Murray", "Maria Cantwell"]),
        USState(id: "WV", name: "West Virginia", capital: "Charleston", governor: "Patrick Morrisey", senators: ["Shelley Moore Capito", "Jim Justice"]),
        USState(id: "WI", name: "Wisconsin", capital: "Madison", governor: "Tony Evers", senators: ["Ron Johnson", "Tammy Baldwin"]),
        USState(id: "WY", name: "Wyoming", capital: "Cheyenne", governor: "Mark Gordon", senators: ["John Barrasso", "Cynthia Lummis"])
    ]
    
    init() {
        loadState()
    }
    
    func getStateSpecificAnswer(for questionNumber: Int) -> [String]? {
        guard let state = selectedState else { return nil }
        
        switch questionNumber {
        case 20: // Who is one of your state's U.S. Senators now?
            return state.senators
        case 23: // Name your U.S. Representative
            // Note: For representatives, users need to know their specific district
            // We provide guidance since districts vary within each state
            return ["Answer varies by congressional district in \(state.name)", "Find your representative at house.gov by entering your ZIP code", "During your interview, provide your district representative's name"]
        case 43: // Who is the Governor of your state now?
            return [state.governor]
        case 44: // What is the capital of your state?
            return [state.capital]
        default:
            return nil
        }
    }
    
    // Generate 4 multiple choice options for test mode
    func getMultipleChoiceOptions(for questionNumber: Int, correctAnswers: [String]) -> [String] {
        guard let state = selectedState else { return [] }
        
        var options: [String] = []
        
        switch questionNumber {
        case 20: // Senators - show the 2 real senators plus 2 from other states
            options = state.senators
            // Add 2 senators from other nearby states as distractors
            let otherSenators = allStates
                .filter { $0.id != state.id }
                .flatMap { $0.senators }
                .shuffled()
                .prefix(2)
            options.append(contentsOf: otherSenators)
            
        case 23: // Representative - this varies by district, so use generic guidance
            options = correctAnswers
            // Add one more generic option to make 4 total
            options.append("Your district's current representative")
            return Array(options.prefix(4).shuffled())
            
        case 43: // Governor - show real governor plus 3 from other states
            options = [state.governor]
            let otherGovernors = allStates
                .filter { $0.id != state.id }
                .map { $0.governor }
                .shuffled()
                .prefix(3)
            options.append(contentsOf: otherGovernors)
            
        case 44: // Capital - show real capital plus 3 from other states
            options = [state.capital]
            let otherCapitals = allStates
                .filter { $0.id != state.id }
                .map { $0.capital }
                .shuffled()
                .prefix(3)
            options.append(contentsOf: otherCapitals)
            
        default:
            return correctAnswers
        }
        
        // Shuffle and return exactly 4 options
        return Array(options.shuffled().prefix(4))
    }
    
    private func saveState() {
        if let state = selectedState, let encoded = try? JSONEncoder().encode(state) {
            userDefaults.set(encoded, forKey: stateKey)
            hasSelectedState = true
        } else {
            userDefaults.removeObject(forKey: stateKey)
            hasSelectedState = false
        }
    }
    
    private func loadState() {
        if let data = userDefaults.data(forKey: stateKey),
           let decoded = try? JSONDecoder().decode(USState.self, from: data) {
            selectedState = decoded
            hasSelectedState = true
        } else {
            hasSelectedState = false
        }
    }
}
