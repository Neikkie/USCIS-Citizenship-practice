//
//  QuestionService.swift
//  USCIS Citizenship practice
//
//  Created by Shanique Beckford on 2/22/26.
//

import Foundation
import Combine

// Service to manage USCIS civics questions
// Based on the 2024-2025 official USCIS 100 civics questions
class QuestionService: ObservableObject {
    @Published var allQuestions: [Question] = []
    @Published var lastUpdated: Date = Date()
    
    init() {
        loadQuestions()
    }
    
    // Load all 100 USCIS civics questions (2026 Official - 2008 Test Version)
    // Updated with current information for 2026
    private func loadQuestions() {
        allQuestions = [
            // AMERICAN GOVERNMENT: Principles of American Democracy (Questions 1-12)
            Question(number: 1, question: "What is the supreme law of the land?", 
                    answers: ["The Constitution", "The Bill of Rights", "The Declaration of Independence", "Federal law"],
                    correctAnswers: ["The Constitution"],
                    category: .americanGovernment),
            
            Question(number: 2, question: "What does the Constitution do?",
                    answers: ["Sets up the government", "Defines the government", "Protects basic rights of Americans", "All of the above"],
                    correctAnswers: ["Sets up the government", "Defines the government", "Protects basic rights of Americans", "All of the above"],
                    category: .americanGovernment),
            
            Question(number: 3, question: "The idea of self-government is in the first three words of the Constitution. What are these words?",
                    answers: ["We the People", "We the Citizens", "We the Americans", "In God We Trust"],
                    correctAnswers: ["We the People"],
                    category: .americanGovernment),
            
            Question(number: 4, question: "What is an amendment?",
                    answers: ["A change to the Constitution", "An addition to the Constitution", "A law", "A court decision"],
                    correctAnswers: ["A change to the Constitution", "An addition to the Constitution"],
                    category: .americanGovernment),
            
            Question(number: 5, question: "What do we call the first ten amendments to the Constitution?",
                    answers: ["The Bill of Rights", "The First Ten", "The Rights of Man", "The Freedom Amendments"],
                    correctAnswers: ["The Bill of Rights"],
                    category: .americanGovernment),
            
            Question(number: 6, question: "What is one right or freedom from the First Amendment?",
                    answers: ["Speech", "Religion", "Assembly", "Press"],
                    correctAnswers: ["Speech", "Religion", "Assembly", "Press"],
                    category: .americanGovernment),
            
            Question(number: 7, question: "How many amendments does the Constitution have?",
                    answers: ["Twenty-seven (27)", "Ten (10)", "Fifty (50)", "One hundred (100)"],
                    correctAnswers: ["Twenty-seven (27)"],
                    category: .americanGovernment),
            
            Question(number: 8, question: "What did the Declaration of Independence do?",
                    answers: ["Announced our independence from Great Britain", "Declared our independence from Great Britain", "Said that the United States is free from Great Britain", "Freed the colonies"],
                    correctAnswers: ["Announced our independence from Great Britain", "Declared our independence from Great Britain", "Said that the United States is free from Great Britain"],
                    category: .americanGovernment),
            
            Question(number: 9, question: "What are two rights in the Declaration of Independence?",
                    answers: ["Life and liberty", "Liberty and the pursuit of happiness", "Life and the pursuit of happiness", "All of the above"],
                    correctAnswers: ["Life and liberty", "Liberty and the pursuit of happiness", "Life and the pursuit of happiness", "All of the above"],
                    category: .americanGovernment),
            
            Question(number: 10, question: "What is freedom of religion?",
                    answers: ["You can practice any religion, or not practice a religion", "You can choose your own religion", "You don't have to practice a religion", "All of the above"],
                    correctAnswers: ["You can practice any religion, or not practice a religion", "All of the above"],
                    category: .americanGovernment),
            
            Question(number: 11, question: "What is the economic system in the United States?",
                    answers: ["Capitalist economy", "Market economy", "Free market", "Socialist economy"],
                    correctAnswers: ["Capitalist economy", "Market economy"],
                    category: .americanGovernment),
            
            Question(number: 12, question: "What is the 'rule of law'?",
                    answers: ["Everyone must follow the law", "Leaders must obey the law", "Government must obey the law", "No one is above the law"],
                    correctAnswers: ["Everyone must follow the law", "Leaders must obey the law", "Government must obey the law", "No one is above the law"],
                    category: .americanGovernment),
            
            // AMERICAN GOVERNMENT: System of Government (Questions 13-47)
            Question(number: 13, question: "Name one branch or part of the government.",
                    answers: ["Congress", "Legislative", "President", "Executive"],
                    correctAnswers: ["Congress", "Legislative", "President", "Executive"],
                    category: .americanGovernment),
            
            Question(number: 14, question: "What stops one branch of government from becoming too powerful?",
                    answers: ["Checks and balances", "Separation of powers", "The Constitution", "The Bill of Rights"],
                    correctAnswers: ["Checks and balances", "Separation of powers"],
                    category: .americanGovernment),
            
            Question(number: 15, question: "Who is in charge of the executive branch?",
                    answers: ["The President", "The Vice President", "The Cabinet", "Congress"],
                    correctAnswers: ["The President"],
                    category: .americanGovernment),
            
            Question(number: 16, question: "Who makes federal laws?",
                    answers: ["Congress", "Senate and House of Representatives", "U.S. or national legislature", "The President"],
                    correctAnswers: ["Congress", "Senate and House of Representatives", "U.S. or national legislature"],
                    category: .americanGovernment),
            
            Question(number: 17, question: "What are the two parts of the U.S. Congress?",
                    answers: ["The Senate and House of Representatives", "Senate and House", "Upper and lower chambers", "Congress and Senate"],
                    correctAnswers: ["The Senate and House of Representatives"],
                    category: .americanGovernment),
            
            Question(number: 18, question: "How many U.S. Senators are there?",
                    answers: ["One hundred (100)", "Fifty (50)", "Four hundred thirty-five (435)", "Two hundred (200)"],
                    correctAnswers: ["One hundred (100)"],
                    category: .americanGovernment),
            
            Question(number: 19, question: "We elect a U.S. Senator for how many years?",
                    answers: ["Six (6)", "Four (4)", "Two (2)", "Eight (8)"],
                    correctAnswers: ["Six (6)"],
                    category: .americanGovernment),
            
            Question(number: 20, question: "Who is one of your state's U.S. Senators now?",
                    answers: ["Answers will vary", "Check USCIS website for current senators", "Your state's senator name", "Contact your state office"],
                    correctAnswers: ["Answers will vary"],
                    category: .americanGovernment),
            
            Question(number: 21, question: "The House of Representatives has how many voting members?",
                    answers: ["Four hundred thirty-five (435)", "One hundred (100)", "Five hundred (500)", "Two hundred (200)"],
                    correctAnswers: ["Four hundred thirty-five (435)"],
                    category: .americanGovernment),
            
            Question(number: 22, question: "We elect a U.S. Representative for how many years?",
                    answers: ["Two (2)", "Four (4)", "Six (6)", "Eight (8)"],
                    correctAnswers: ["Two (2)"],
                    category: .americanGovernment),
            
            Question(number: 23, question: "Name your U.S. Representative.",
                    answers: ["Answers will vary", "Check USCIS website for your representative", "Your district's representative", "Contact your district office"],
                    correctAnswers: ["Answers will vary"],
                    category: .americanGovernment),
            
            Question(number: 24, question: "Who does a U.S. Senator represent?",
                    answers: ["All people of the state", "Everyone in the state", "The state's citizens", "The state"],
                    correctAnswers: ["All people of the state"],
                    category: .americanGovernment),
            
            Question(number: 25, question: "Why do some states have more Representatives than other states?",
                    answers: ["Because of the state's population", "Because they have more people", "Because some states have more people", "Population determines representation"],
                    correctAnswers: ["Because of the state's population", "Because they have more people", "Because some states have more people"],
                    category: .americanGovernment),
            
            Question(number: 26, question: "We elect a President for how many years?",
                    answers: ["Four (4)", "Two (2)", "Six (6)", "Eight (8)"],
                    correctAnswers: ["Four (4)"],
                    category: .americanGovernment),
            
            Question(number: 27, question: "In what month do we vote for President?",
                    answers: ["November", "January", "October", "December"],
                    correctAnswers: ["November"],
                    category: .americanGovernment),
            
            Question(number: 28, question: "What is the name of the President of the United States now?",
                    answers: ["Donald Trump", "President Trump", "Trump", "Check USCIS for current president"],
                    correctAnswers: ["Donald Trump", "President Trump", "Trump"],
                    category: .americanGovernment),
            
            Question(number: 29, question: "What is the name of the Vice President of the United States now?",
                    answers: ["JD Vance", "Vance", "Vice President Vance", "Check USCIS for current VP"],
                    correctAnswers: ["JD Vance", "Vance", "Vice President Vance"],
                    category: .americanGovernment),
            
            Question(number: 30, question: "If the President can no longer serve, who becomes President?",
                    answers: ["The Vice President", "Vice President", "The Speaker of the House", "The Secretary of State"],
                    correctAnswers: ["The Vice President", "Vice President"],
                    category: .americanGovernment),
            
            Question(number: 31, question: "If both the President and the Vice President can no longer serve, who becomes President?",
                    answers: ["The Speaker of the House", "Speaker of the House", "The Chief Justice", "The Secretary of State"],
                    correctAnswers: ["The Speaker of the House", "Speaker of the House"],
                    category: .americanGovernment),
            
            Question(number: 32, question: "Who is the Commander in Chief of the military?",
                    answers: ["The President", "President", "The Vice President", "Secretary of Defense"],
                    correctAnswers: ["The President", "President"],
                    category: .americanGovernment),
            
            Question(number: 33, question: "Who signs bills to become laws?",
                    answers: ["The President", "President", "Congress", "The Supreme Court"],
                    correctAnswers: ["The President", "President"],
                    category: .americanGovernment),
            
            Question(number: 34, question: "Who vetoes bills?",
                    answers: ["The President", "President", "Congress", "The Supreme Court"],
                    correctAnswers: ["The President", "President"],
                    category: .americanGovernment),
            
            Question(number: 35, question: "What does the President's Cabinet do?",
                    answers: ["Advises the President", "Helps the President", "Assists the President", "Counsels the President"],
                    correctAnswers: ["Advises the President"],
                    category: .americanGovernment),
            
            Question(number: 36, question: "What are two Cabinet-level positions?",
                    answers: ["Secretary of State", "Secretary of Defense", "Secretary of Treasury", "Attorney General"],
                    correctAnswers: ["Secretary of State", "Secretary of Defense", "Secretary of Treasury", "Attorney General"],
                    category: .americanGovernment),
            
            Question(number: 37, question: "What does the judicial branch do?",
                    answers: ["Reviews laws", "Explains laws", "Resolves disputes", "Decides if a law goes against the Constitution"],
                    correctAnswers: ["Reviews laws", "Explains laws", "Resolves disputes", "Decides if a law goes against the Constitution"],
                    category: .americanGovernment),
            
            Question(number: 38, question: "What is the highest court in the United States?",
                    answers: ["The Supreme Court", "Supreme Court", "U.S. Supreme Court", "Federal Court"],
                    correctAnswers: ["The Supreme Court", "Supreme Court"],
                    category: .americanGovernment),
            
            Question(number: 39, question: "How many justices are on the Supreme Court?",
                    answers: ["Nine (9)", "9", "Eight (8)", "Ten (10)"],
                    correctAnswers: ["Nine (9)", "9"],
                    category: .americanGovernment),
            
            Question(number: 40, question: "Who is the Chief Justice of the United States now?",
                    answers: ["John Roberts", "Roberts", "Chief Justice Roberts", "Check USCIS for current"],
                    correctAnswers: ["John Roberts", "Roberts", "Chief Justice Roberts"],
                    category: .americanGovernment),
            
            Question(number: 41, question: "Under our Constitution, some powers belong to the federal government. What is one power of the federal government?",
                    answers: ["To print money", "To declare war", "To create an army", "To make treaties"],
                    correctAnswers: ["To print money", "To declare war", "To create an army", "To make treaties"],
                    category: .americanGovernment),
            
            Question(number: 42, question: "Under our Constitution, some powers belong to the states. What is one power of the states?",
                    answers: ["Provide schooling and education", "Provide protection (police)", "Provide safety (fire departments)", "Give a driver's license"],
                    correctAnswers: ["Provide schooling and education", "Provide protection (police)", "Provide safety (fire departments)", "Give a driver's license"],
                    category: .americanGovernment),
            
            Question(number: 43, question: "Who is the Governor of your state now?",
                    answers: ["Answers will vary", "Check your state website", "Your state's governor", "Varies by state"],
                    correctAnswers: ["Answers will vary"],
                    category: .americanGovernment),
            
            Question(number: 44, question: "What is the capital of your state?",
                    answers: ["Answers will vary", "Check your state", "Your state capital", "Varies by state"],
                    correctAnswers: ["Answers will vary"],
                    category: .americanGovernment),
            
            Question(number: 45, question: "What are the two major political parties in the United States?",
                    answers: ["Democratic and Republican", "Democrat and Republican", "Democratic Party and Republican Party", "Liberal and Conservative"],
                    correctAnswers: ["Democratic and Republican", "Democrat and Republican"],
                    category: .americanGovernment),
            
            Question(number: 46, question: "What is the political party of the President now?",
                    answers: ["Republican", "Republican Party", "GOP", "Democratic"],
                    correctAnswers: ["Republican", "Republican Party"],
                    category: .americanGovernment),
            
            Question(number: 47, question: "What is the name of the Speaker of the House of Representatives now?",
                    answers: ["Mike Johnson", "Johnson", "Speaker Johnson", "Check USCIS for current"],
                    correctAnswers: ["Mike Johnson", "Johnson", "Speaker Johnson"],
                    category: .americanGovernment),
            
            // AMERICAN GOVERNMENT: Rights and Responsibilities (Questions 48-57)
            Question(number: 48, question: "There are four amendments to the Constitution about who can vote. Describe one of them.",
                    answers: ["Citizens eighteen and older can vote", "You don't have to pay to vote", "Any citizen can vote", "A male citizen of any race can vote"],
                    correctAnswers: ["Citizens eighteen and older can vote", "You don't have to pay to vote", "Any citizen can vote", "A male citizen of any race can vote"],
                    category: .americanGovernment),
            
            Question(number: 49, question: "What is one responsibility that is only for United States citizens?",
                    answers: ["Serve on a jury", "Vote in a federal election", "Run for office", "Help with a campaign"],
                    correctAnswers: ["Serve on a jury", "Vote in a federal election"],
                    category: .americanGovernment),
            
            Question(number: 50, question: "Name one right only for United States citizens.",
                    answers: ["Vote in a federal election", "Run for federal office", "Serve on a jury", "Work for the government"],
                    correctAnswers: ["Vote in a federal election", "Run for federal office"],
                    category: .americanGovernment),
            
            Question(number: 51, question: "What are two rights of everyone living in the United States?",
                    answers: ["Freedom of expression", "Freedom of speech", "Freedom of assembly", "Freedom to petition the government"],
                    correctAnswers: ["Freedom of expression", "Freedom of speech", "Freedom of assembly", "Freedom to petition the government"],
                    category: .americanGovernment),
            
            Question(number: 52, question: "What do we show loyalty to when we say the Pledge of Allegiance?",
                    answers: ["The United States", "The flag", "America", "Our country"],
                    correctAnswers: ["The United States", "The flag"],
                    category: .americanGovernment),
            
            Question(number: 53, question: "What is one promise you make when you become a United States citizen?",
                    answers: ["Give up loyalty to other countries", "Defend the Constitution and laws of the United States", "Obey the laws of the United States", "Serve in the military if needed"],
                    correctAnswers: ["Give up loyalty to other countries", "Defend the Constitution and laws of the United States", "Obey the laws of the United States", "Serve in the military if needed"],
                    category: .americanGovernment),
            
            Question(number: 54, question: "How old do citizens have to be to vote for President?",
                    answers: ["Eighteen (18) and older", "18 and older", "21 and older", "16 and older"],
                    correctAnswers: ["Eighteen (18) and older", "18 and older"],
                    category: .americanGovernment),
            
            Question(number: 55, question: "What are two ways that Americans can participate in their democracy?",
                    answers: ["Vote", "Join a political party", "Help with a campaign", "Join a civic group"],
                    correctAnswers: ["Vote", "Join a political party", "Help with a campaign", "Join a civic group"],
                    category: .americanGovernment),
            
            Question(number: 56, question: "When is the last day you can send in federal income tax forms?",
                    answers: ["April 15", "April 15th", "Tax Day", "Mid-April"],
                    correctAnswers: ["April 15"],
                    category: .americanGovernment),
            
            Question(number: 57, question: "When must all men register for the Selective Service?",
                    answers: ["At age eighteen (18)", "Between eighteen (18) and twenty-six (26)", "At 18", "When they turn 18"],
                    correctAnswers: ["At age eighteen (18)", "Between eighteen (18) and twenty-six (26)"],
                    category: .americanGovernment),
            
            // AMERICAN HISTORY: Colonial Period and Independence (Questions 58-70)
            Question(number: 58, question: "What is one reason colonists came to America?",
                    answers: ["Freedom", "Political liberty", "Religious freedom", "Economic opportunity"],
                    correctAnswers: ["Freedom", "Political liberty", "Religious freedom", "Economic opportunity"],
                    category: .americanHistory),
            
            Question(number: 59, question: "Who lived in America before the Europeans arrived?",
                    answers: ["American Indians", "Native Americans", "Indigenous peoples", "First Nations"],
                    correctAnswers: ["American Indians", "Native Americans"],
                    category: .americanHistory),
            
            Question(number: 60, question: "What group of people was taken to America and sold as slaves?",
                    answers: ["Africans", "People from Africa", "African people", "Slaves from Africa"],
                    correctAnswers: ["Africans", "People from Africa"],
                    category: .americanHistory),
            
            Question(number: 61, question: "Why did the colonists fight the British?",
                    answers: ["Because of high taxes", "Because the British army stayed in their houses", "Because they didn't have self-government", "All of the above"],
                    correctAnswers: ["Because of high taxes", "Because the British army stayed in their houses", "Because they didn't have self-government"],
                    category: .americanHistory),
            
            Question(number: 62, question: "Who wrote the Declaration of Independence?",
                    answers: ["Thomas Jefferson", "Jefferson", "Benjamin Franklin", "John Adams"],
                    correctAnswers: ["Thomas Jefferson", "Jefferson"],
                    category: .americanHistory),
            
            Question(number: 63, question: "When was the Declaration of Independence adopted?",
                    answers: ["July 4, 1776", "1776", "July 4th, 1776", "Independence Day 1776"],
                    correctAnswers: ["July 4, 1776"],
                    category: .americanHistory),
            
            Question(number: 64, question: "There were 13 original states. Name three.",
                    answers: ["New York", "New Jersey", "Pennsylvania", "Massachusetts"],
                    correctAnswers: ["New York", "New Jersey", "Pennsylvania", "Massachusetts"],
                    category: .americanHistory),
            
            Question(number: 65, question: "What happened at the Constitutional Convention?",
                    answers: ["The Constitution was written", "The Founding Fathers wrote the Constitution", "The Constitution was drafted", "Created the Constitution"],
                    correctAnswers: ["The Constitution was written", "The Founding Fathers wrote the Constitution"],
                    category: .americanHistory),
            
            Question(number: 66, question: "When was the Constitution written?",
                    answers: ["1787", "1776", "1789", "1791"],
                    correctAnswers: ["1787"],
                    category: .americanHistory),
            
            Question(number: 67, question: "The Federalist Papers supported the passage of the U.S. Constitution. Name one of the writers.",
                    answers: ["James Madison", "Alexander Hamilton", "John Jay", "Publius"],
                    correctAnswers: ["James Madison", "Alexander Hamilton", "John Jay", "Publius"],
                    category: .americanHistory),
            
            Question(number: 68, question: "What is one thing Benjamin Franklin is famous for?",
                    answers: ["U.S. diplomat", "Oldest member of the Constitutional Convention", "First Postmaster General", "Writer of Poor Richard's Almanac"],
                    correctAnswers: ["U.S. diplomat", "Oldest member of the Constitutional Convention", "First Postmaster General", "Writer of Poor Richard's Almanac"],
                    category: .americanHistory),
            
            Question(number: 69, question: "Who is the 'Father of Our Country'?",
                    answers: ["George Washington", "Washington", "President Washington", "Thomas Jefferson"],
                    correctAnswers: ["George Washington", "Washington"],
                    category: .americanHistory),
            
            Question(number: 70, question: "Who was the first President?",
                    answers: ["George Washington", "Washington", "George W.", "President Washington"],
                    correctAnswers: ["George Washington", "Washington"],
                    category: .americanHistory),
            
            // AMERICAN HISTORY: 1800s (Questions 71-77)
            Question(number: 71, question: "What territory did the United States buy from France in 1803?",
                    answers: ["The Louisiana Territory", "Louisiana", "Louisiana Purchase", "French Territory"],
                    correctAnswers: ["The Louisiana Territory", "Louisiana"],
                    category: .americanHistory),
            
            Question(number: 72, question: "Name one war fought by the United States in the 1800s.",
                    answers: ["War of 1812", "Mexican-American War", "Civil War", "Spanish-American War"],
                    correctAnswers: ["War of 1812", "Mexican-American War", "Civil War", "Spanish-American War"],
                    category: .americanHistory),
            
            Question(number: 73, question: "Name the U.S. war between the North and the South.",
                    answers: ["The Civil War", "Civil War", "The War between the States", "War between the States"],
                    correctAnswers: ["The Civil War", "The War between the States"],
                    category: .americanHistory),
            
            Question(number: 74, question: "Name one problem that led to the Civil War.",
                    answers: ["Slavery", "Economic reasons", "States' rights", "Territorial disputes"],
                    correctAnswers: ["Slavery", "Economic reasons", "States' rights"],
                    category: .americanHistory),
            
            Question(number: 75, question: "What was one important thing that Abraham Lincoln did?",
                    answers: ["Freed the slaves", "Saved the Union", "Led the United States during the Civil War", "Emancipation Proclamation"],
                    correctAnswers: ["Freed the slaves", "Saved the Union", "Led the United States during the Civil War"],
                    category: .americanHistory),
            
            Question(number: 76, question: "What did the Emancipation Proclamation do?",
                    answers: ["Freed the slaves", "Freed slaves in the Confederacy", "Freed slaves in the Confederate states", "Freed most slaves"],
                    correctAnswers: ["Freed the slaves", "Freed slaves in the Confederacy", "Freed slaves in the Confederate states"],
                    category: .americanHistory),
            
            Question(number: 77, question: "What did Susan B. Anthony do?",
                    answers: ["Fought for women's rights", "Fought for civil rights", "Worked for women's suffrage", "Campaigned for women to vote"],
                    correctAnswers: ["Fought for women's rights", "Fought for civil rights"],
                    category: .americanHistory),
            
            // AMERICAN HISTORY: Recent American History and Other Important Historical Information (Questions 78-87)
            Question(number: 78, question: "Name one war fought by the United States in the 1900s.",
                    answers: ["World War I", "World War II", "Korean War", "Vietnam War"],
                    correctAnswers: ["World War I", "World War II", "Korean War", "Vietnam War"],
                    category: .americanHistory),
            
            Question(number: 79, question: "Who was President during World War I?",
                    answers: ["Woodrow Wilson", "Wilson", "President Wilson", "Theodore Roosevelt"],
                    correctAnswers: ["Woodrow Wilson", "Wilson"],
                    category: .americanHistory),
            
            Question(number: 80, question: "Who was President during the Great Depression and World War II?",
                    answers: ["Franklin Roosevelt", "Roosevelt", "FDR", "Franklin D. Roosevelt"],
                    correctAnswers: ["Franklin Roosevelt", "Roosevelt", "FDR"],
                    category: .americanHistory),
            
            Question(number: 81, question: "Who did the United States fight in World War II?",
                    answers: ["Japan, Germany, and Italy", "Japan and Germany", "The Axis Powers", "Nazi Germany"],
                    correctAnswers: ["Japan, Germany, and Italy", "The Axis Powers"],
                    category: .americanHistory),
            
            Question(number: 82, question: "Before he was President, Eisenhower was a general. What war was he in?",
                    answers: ["World War II", "WWII", "Second World War", "World War I"],
                    correctAnswers: ["World War II", "WWII"],
                    category: .americanHistory),
            
            Question(number: 83, question: "During the Cold War, what was the main concern of the United States?",
                    answers: ["Communism", "Spread of communism", "Soviet Union", "Nuclear war"],
                    correctAnswers: ["Communism"],
                    category: .americanHistory),
            
            Question(number: 84, question: "What movement tried to end racial discrimination?",
                    answers: ["Civil rights movement", "Civil rights", "The civil rights movement", "Civil Rights Movement"],
                    correctAnswers: ["Civil rights movement", "Civil rights"],
                    category: .americanHistory),
            
            Question(number: 85, question: "What did Martin Luther King, Jr. do?",
                    answers: ["Fought for civil rights", "Worked for equality for all Americans", "Led civil rights movement", "Advocated for peaceful protest"],
                    correctAnswers: ["Fought for civil rights", "Worked for equality for all Americans"],
                    category: .americanHistory),
            
            Question(number: 86, question: "What major event happened on September 11, 2001, in the United States?",
                    answers: ["Terrorists attacked the United States", "9/11 attacks", "Terrorist attacks", "Attack on World Trade Center"],
                    correctAnswers: ["Terrorists attacked the United States"],
                    category: .americanHistory),
            
            Question(number: 87, question: "Name one American Indian tribe in the United States.",
                    answers: ["Cherokee", "Navajo", "Sioux", "Chippewa"],
                    correctAnswers: ["Cherokee", "Navajo", "Sioux", "Chippewa"],
                    category: .americanHistory),
            
            // INTEGRATED CIVICS: Geography (Questions 88-95)
            Question(number: 88, question: "Name one of the two longest rivers in the United States.",
                    answers: ["Missouri River", "Mississippi River", "Colorado River", "Rio Grande"],
                    correctAnswers: ["Missouri River", "Mississippi River"],
                    category: .integratedCivics),
            
            Question(number: 89, question: "What ocean is on the West Coast of the United States?",
                    answers: ["Pacific Ocean", "Pacific", "Atlantic Ocean", "Gulf of Mexico"],
                    correctAnswers: ["Pacific Ocean", "Pacific"],
                    category: .integratedCivics),
            
            Question(number: 90, question: "What ocean is on the East Coast of the United States?",
                    answers: ["Atlantic Ocean", "Atlantic", "Pacific Ocean", "Gulf of Mexico"],
                    correctAnswers: ["Atlantic Ocean", "Atlantic"],
                    category: .integratedCivics),
            
            Question(number: 91, question: "Name one U.S. territory.",
                    answers: ["Puerto Rico", "U.S. Virgin Islands", "American Samoa", "Guam"],
                    correctAnswers: ["Puerto Rico", "U.S. Virgin Islands", "American Samoa", "Guam"],
                    category: .integratedCivics),
            
            Question(number: 92, question: "Name one state that borders Canada.",
                    answers: ["Maine", "New York", "Vermont", "Washington"],
                    correctAnswers: ["Maine", "New York", "Vermont", "Washington"],
                    category: .integratedCivics),
            
            Question(number: 93, question: "Name one state that borders Mexico.",
                    answers: ["California", "Arizona", "New Mexico", "Texas"],
                    correctAnswers: ["California", "Arizona", "New Mexico", "Texas"],
                    category: .integratedCivics),
            
            Question(number: 94, question: "What is the capital of the United States?",
                    answers: ["Washington, D.C.", "Washington D.C.", "D.C.", "The District of Columbia"],
                    correctAnswers: ["Washington, D.C.", "Washington D.C."],
                    category: .integratedCivics),
            
            Question(number: 95, question: "Where is the Statue of Liberty?",
                    answers: ["New York Harbor", "Liberty Island", "New York", "New Jersey"],
                    correctAnswers: ["New York Harbor", "Liberty Island"],
                    category: .integratedCivics),
            
            // INTEGRATED CIVICS: Symbols and Holidays
            Question(number: 96, question: "Why does the flag have 13 stripes?",
                    answers: ["Because there were 13 original colonies", "Because the stripes represent the original colonies", "For the 13 colonies", "13 original states"],
                    correctAnswers: ["Because there were 13 original colonies", "Because the stripes represent the original colonies"],
                    category: .integratedCivics),
            
            Question(number: 97, question: "Why does the flag have 50 stars?",
                    answers: ["Because there is one star for each state", "Because each star represents a state", "Because there are 50 states", "One star for every state"],
                    correctAnswers: ["Because there is one star for each state", "Because each star represents a state", "Because there are 50 states"],
                    category: .integratedCivics),
            
            Question(number: 98, question: "What is the name of the national anthem?",
                    answers: ["The Star-Spangled Banner", "Star-Spangled Banner", "America the Beautiful", "God Bless America"],
                    correctAnswers: ["The Star-Spangled Banner", "Star-Spangled Banner"],
                    category: .integratedCivics),
            
            Question(number: 99, question: "When do we celebrate Independence Day?",
                    answers: ["July 4", "Fourth of July", "July 4th", "Independence Day"],
                    correctAnswers: ["July 4"],
                    category: .integratedCivics),
            
            Question(number: 100, question: "Name two national U.S. holidays.",
                    answers: ["New Year's Day", "Martin Luther King, Jr. Day", "Presidents' Day", "Memorial Day"],
                    correctAnswers: ["New Year's Day", "Martin Luther King, Jr. Day", "Presidents' Day", "Memorial Day"],
                    category: .integratedCivics),
        ]
        
        lastUpdated = Date()
    }
    
    // Get random questions for practice test (10 questions as per USCIS)
    func getTestQuestions(count: Int = 10) -> [Question] {
        return Array(allQuestions.shuffled().prefix(count))
    }
    
    // Get questions by category
    func getQuestions(by category: QuestionCategory) -> [Question] {
        return allQuestions.filter { $0.category == category }
    }
    
    // Get a random question for flashcard
    func getRandomQuestion() -> Question? {
        return allQuestions.randomElement()
    }
}
