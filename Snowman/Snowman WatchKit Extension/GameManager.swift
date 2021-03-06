//
//  GameManager.swift
//  Snowman WatchKit Extension
//
//  Created by Conrad Stoll on 7/8/17.
//  Copyright © 2017 Conrad Stoll. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at

//  http://www.apache.org/licenses/LICENSE-2.0

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation
import WatchKit

struct Definitions : Codable {
    var dictionary : [String : String] = [String : String]()
}

struct GameMode {
    let title : String
    let phrases : [String]
}

class GameManager {
    static let shared = GameManager()
    
    let definitions : Definitions?
    let modes = [common, fruits, harryPotter, shakespeare, spelling]
    
    init() {
        self.definitions = GameManager.loadDefinitions()
    }
    
    func definition(for word: String) -> String? {
        if let definitions = definitions, let definition = definitions.dictionary[word] {
            return definition
        }
        
        return nil
    }
    
    static func loadDefinitions() -> Definitions? {
        let decoder = JSONDecoder()
        
        if let path = Bundle.main.path(forResource: "Definitions", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let definitions = try? decoder.decode(Definitions.self, from: data) {
            
            return definitions
        }
        
        return nil
    }
    
    static func loadFile(named name: String, extension fileExtension: String, seperatedBy seperator: String) -> [String] {
        let bundle = Bundle.main
        let path = bundle.path(forResource: name, ofType: fileExtension)!
        let string = try! String(contentsOfFile: path)
        
        let phrases = string.components(separatedBy: seperator)
        let filtered = filteredArray(for: phrases)
        
        var toPrint = ""
        
        for item in filtered {
            toPrint += "\"" + item + "\", "
        }
        
        print(toPrint)
        
        return filtered
    }
    
    static func filteredArray(for phrases: [String]) -> [String] {
        let filtered = phrases.filter { (s) -> Bool in
            if s.count > 20 {
                return false
            }
            
            return true
        }
        
        let mapped = filtered.map { (s) -> String in
            return s.capitalized
        }
        
        return mapped
    }
    
    func playAgain() {
        WKInterfaceController.reloadRootPageControllers(withNames: ["GameModeInterfaceController"], contexts: [modes], orientation: .vertical, pageIndex: 0)
    }
}

let common = GameMode(title: "Most Common Words", phrases: ["Ability", "About", "Above", "Accept", "According", "Account", "Across", "Action", "Activity", "Actually", "Address", "Administration", "Admit", "Adult", "Affect", "After", "Again", "Against", "Agency", "Agent", "Agree", "Agreement", "Ahead", "Allow", "Almost", "Alone", "Along", "Already", "Although", "Always", "American", "Among", "Amount", "Analysis", "Animal", "Another", "Answer", "Anyone", "Anything", "Appear", "Apply", "Approach", "Argue", "Around", "Arrive", "Article", "Artist", "Assume", "Attack", "Attention", "Attorney", "Audience", "Author", "Authority", "Available", "Avoid", "Beautiful", "Because", "Become", "Before", "Begin", "Behavior", "Behind", "Believe", "Benefit", "Better", "Between", "Beyond", "Billion", "Black", "Blood", "Board", "Break", "Bring", "Brother", "Budget", "Build", "Building", "Business", "Camera", "Campaign", "Cancer", "Candidate", "Capital", "Career", "Carry", "Catch", "Cause", "Center", "Central", "Century", "Certain", "Certainly", "Chair", "Challenge", "Chance", "Change", "Character", "Charge", "Check", "Child", "Choice", "Choose", "Church", "Citizen", "Civil", "Claim", "Class", "Clear", "Clearly", "Close", "Coach", "Collection", "College", "Color", "Commercial", "Common", "Community", "Company", "Compare", "Computer", "Concern", "Condition", "Conference", "Congress", "Consider", "Consumer", "Contain", "Continue", "Control", "Could", "Country", "Couple", "Course", "Court", "Cover", "Create", "Crime", "Cultural", "Culture", "Current", "Customer", "Daughter", "Death", "Debate", "Decade", "Decide", "Decision", "Defense", "Degree", "Democrat", "Democratic", "Describe", "Design", "Despite", "Detail", "Determine", "Develop", "Development", "Difference", "Different", "Difficult", "Dinner", "Direction", "Director", "Discover", "Discuss", "Discussion", "Disease", "Doctor", "Dream", "Drive", "During", "Early", "Economic", "Economy", "Education", "Effect", "Effort", "Eight", "Either", "Election", "Employee", "Energy", "Enjoy", "Enough", "Enter", "Entire", "Environment", "Environmental", "Especially", "Establish", "Evening", "Event", "Every", "Everybody", "Everyone", "Everything", "Evidence", "Exactly", "Example", "Executive", "Exist", "Expect", "Experience", "Expert", "Explain", "Factor", "Family", "Father", "Federal", "Feeling", "Field", "Fight", "Figure", "Final", "Finally", "Financial", "Finger", "Finish", "First", "Floor", "Focus", "Follow", "Force", "Foreign", "Forget", "Former", "Forward", "Friend", "Front", "Future", "Garden", "General", "Generation", "Glass", "Government", "Great", "Green", "Ground", "Group", "Growth", "Guess", "Happen", "Happy", "Health", "Heart", "Heavy", "Herself", "Himself", "History", "Hospital", "Hotel", "House", "However", "Human", "Hundred", "Husband", "Identify", "Image", "Imagine", "Impact", "Important", "Improve", "Include", "Including", "Increase", "Indeed", "Indicate", "Individual", "Industry", "Information", "Inside", "Instead", "Institution", "Interest", "Interesting", "International", "Interview", "Investment", "Involve", "Issue", "Itself", "Kitchen", "Knowledge", "Language", "Large", "Later", "Laugh", "Lawyer", "Leader", "Learn", "Least", "Leave", "Legal", "Letter", "Level", "Light", "Likely", "Listen", "Little", "Local", "Machine", "Magazine", "Maintain", "Major", "Majority", "Manage", "Management", "Manager", "Market", "Marriage", "Material", "Matter", "Maybe", "Measure", "Media", "Medical", "Meeting", "Member", "Memory", "Mention", "Message", "Method", "Middle", "Might", "Military", "Million", "Minute", "Mission", "Model", "Modern", "Moment", "Money", "Month", "Morning", "Mother", "Mouth", "Movement", "Movie", "Music", "Myself", "Nation", "National", "Natural", "Nature", "Nearly", "Necessary", "Network", "Never", "Newspaper", "Night", "North", "Nothing", "Notice", "Number", "Occur", "Offer", "Office", "Officer", "Official", "Often", "Operation", "Opportunity", "Option", "Order", "Organization", "Other", "Others", "Outside", "Owner", "Painting", "Paper", "Parent", "Participant", "Particular", "Particularly", "Partner", "Party", "Patient", "Pattern", "Peace", "People", "Perform", "Performance", "Perhaps", "Period", "Person", "Personal", "Phone", "Physical", "Picture", "Piece", "Place", "Plant", "Player", "Point", "Police", "Policy", "Political", "Politics", "Popular", "Population", "Position", "Positive", "Possible", "Power", "Practice", "Prepare", "Present", "President", "Pressure", "Pretty", "Prevent", "Price", "Private", "Probably", "Problem", "Process", "Produce", "Product", "Production", "Professional", "Professor", "Program", "Project", "Property", "Protect", "Prove", "Provide", "Public", "Purpose", "Quality", "Question", "Quickly", "Quite", "Radio", "Raise", "Range", "Rather", "Reach", "Ready", "Reality", "Realize", "Really", "Reason", "Receive", "Recent", "Recently", "Recognize", "Record", "Reduce", "Reflect", "Region", "Relate", "Relationship", "Religious", "Remain", "Remember", "Remove", "Report", "Represent", "Republican", "Require", "Research", "Resource", "Respond", "Response", "Responsibility", "Result", "Return", "Reveal", "Right", "Scene", "School", "Science", "Scientist", "Score", "Season", "Second", "Section", "Security", "Senior", "Sense", "Series", "Serious", "Serve", "Service", "Seven", "Several", "Shake", "Share", "Shoot", "Short", "Should", "Shoulder", "Significant", "Similar", "Simple", "Simply", "Since", "Single", "Sister", "Situation", "Skill", "Small", "Smile", "Social", "Society", "Soldier", "Somebody", "Someone", "Something", "Sometimes", "Sound", "Source", "South", "Southern", "Space", "Speak", "Special", "Specific", "Speech", "Spend", "Sport", "Spring", "Staff", "Stage", "Stand", "Standard", "Start", "State", "Statement", "Station", "Still", "Stock", "Store", "Story", "Strategy", "Street", "Strong", "Structure", "Student", "Study", "Stuff", "Style", "Subject", "Success", "Successful", "Suddenly", "Suffer", "Suggest", "Summer", "Support", "Surface", "System", "Table", "Teach", "Teacher", "Technology", "Television", "Thank", "Their", "Themselves", "Theory", "There", "These", "Thing", "Think", "Third", "Those", "Though", "Thought", "Thousand", "Threat", "Three", "Through", "Throughout", "Throw", "Today", "Together", "Tonight", "Total", "Tough", "Toward", "Trade", "Traditional", "Training", "Travel", "Treat", "Treatment", "Trial", "Trouble", "Truth", "Under", "Understand", "Until", "Usually", "Value", "Various", "Victim", "Violence", "Visit", "Voice", "Watch", "Water", "Weapon", "Weight", "Western", "Whatever", "Where", "Whether", "Which", "While", "White", "Whole", "Whose", "Window", "Within", "Without", "Woman", "Wonder", "Worker", "World", "Worry", "Would", "Write", "Writer", "Wrong", "Young", "Yourself"])

let fruits = GameMode(title: "Fruits and\nVegetables", phrases: ["Apple", "Apricot", "Asparagus", "Eggplant", "Avocado", "Banana", "Beet", "Black-Eyed Peas", "Fava Bean", "Broccoli", "Brussels Sprouts", "Butternut Squash", "Carrot", "Cherry", "Clementine", "Zucchini", "Date", "Elderberry", "Endive", "Fennel", "Fig", "Garlic", "Grape", "Green Bean", "Guava", "Honeydew Melon", "Canteloupe", "Lettuce", "Artichoke", "Corn", "Artichoke", "Kiwi", "Leek", "Lemon", "Lime", "Mango", "Grapefruit", "Melon", "Mushroom", "Nectarine", "Olive", "Orange", "Pea", "Peanut", "Pear", "Pepper", "Pineapple", "Pumpkin", "Chard", "Radish", "Raisin", "Rhubarb", "Mandarin", "Tangerine", "Strawberry", "Sweet Potato", "Potato", "Tomato", "Turnip", "Plum", "Watercress", "Watermelon", "Yam", "Green Onions", "Pear", "Collards", "Cucumber", "Garlic", "Kale", "Kohlrabi", "Mustard", "Okra", "Shallots", "Spinach", "Blackberry", "Boysenberry", "Currant", "Coconut", "Cranberry", "Dragonfruit", "Durian", "Fig", "Gooseberry", "Jackfruit", "Jujube", "Kumquat", "Loquat", "Lychee", "Marionberry", "Mulberry", "Papaya", "Passionfruit", "Peach", "Persimmon", "Plantain", "Plumcot", "Pomegranate", "Pomelo", "Raspberry", "Star Fruit", "Tamarind", "Yuzu", "Amaranth", "Chickpeas", "Lentils", "Split Peas", "Cauliflower", "Cabbage", "Celery", "Ginger", "Rutabaga", "Spaghetti Squash", "Acorn Squash", "Jicama", "Taro", "Turnip Greens"])

let harryPotter = GameMode(title: "Harry Potter", phrases: ["Wingardium Leviosa", "Expelliarmus", "Alohamora", "Arithmancy", "Hogwarts", "Hedwig", "Butterbeer", "Chudley Cannons", "Severus Snape", "Sneakoscope", "Always", "Accio", "Acid Pops", "Aguamenti", "Alchemy", "Alohomora", "Anapneo", "Animagi", "Aparecium", "Apparate", "Aragog", "Arithmancy", "Auror", "Avada Kedavra", "Azkaban", "Bathilda Bagshot", "Basilisk", "Beater", "Professor Binns", "Regulus Black", "Sirius Black", "Blast-Ended Skrewt", "The Blood Baron", "Bludgers", "Boggart", "Borgin And Burkes", "Bowtruckles", "Lavender Brown", "Bubble-Head Charm", "The Burrow", "Butterbeer", "Sir Cadogan", "Canary Creams", "Centaurs", "Cho Chang", "Charm", "Chaser", "Chocoballs", "Chocolate Frogs", "The Chudley Cannons", "Cleansweep Seven", "Penelope Clearwater", "Cockroach Clusters", "Common Room", "Cornish Pixies", "Vincent Crabbe", "Colin Creevey", "Bartemius Crouch", "Crookshanks", "Bartemius Crouch Jr", "Cruciatus Curse", "The Daily Prophet", "The Dark Mark", "Death Eaters", "Deflating Draught", "Fleur Delecour", "Dementor", "Densaugeo", "Dervish And Banges", "Diagon Alley", "Diffindo", "Dedalus Diggle", "Amos Diggory", "Cedric Diggory", "Divination", "Dobby", "Elphias Doge", "Dragon", "Dueling Club", "Albus Dumbledore", "Dumbledore's Army", "Dungbomb", "Durmstrang Institute", "Dudley Dursley", "Eeylops Owl Emporium", "The Elixir of Life", "Enervate", "Engorgio", "Errol", "Evanesco", "Expectopatronum", "Expelliarmus", "Exploding Bonbons", "Exploding Snap", "Extendable Ears", "The Fat Friar", "The Fat Lady", "Fawkes", "Felix Felicis", "Ferula", "Fidelius Charm", "Arabella Figg", "Argus Filch", "Seamus Finnigan", "Firebolt", "Firenze", "Fizzing Whizbees", "Nicholas Flamel", "Mundungus Fletcher", "Professor Flitwick", "Flobberworm", "Floo Powder", "Flourish And Blotts", "Flutterby Bush", "The Forbidden Forest", "Freezing Charm", "Cornelius Fudge", "Furnunculus", "Gold Galleon", "Marvolo Gaunt", "Gillyweed", "Goblet of Fire", "Gobstones", "Godric's Hollow", "Golden Snitch", "Gregory Goyle", "Hermione Granger", "Grawp", "The Great Hall", "The Grey Lady", "Grindylow", "Gringotts", "Griphook", "Gryffindor House", "Godric Gryffindor", "Rubeus Hagrid", "The Headless Hunt", "Hebridean Black", "Hedwig", "Heir of Slytherin", "Hermes", "Herbology", "Hinkypunk", "Hippogriff", "The Hog's Head", "Hogsmeade", "Hogwarts", "Honeydukes", "Madam Hooch", "Horcrux", "The House Cup", "House-Elf", "Howler", "Hufflepuff House", "Helga Hufflepuff", "Impediment Jinx", "Imperius Curse", "Incendio", "Incarcerous", "Inferius", "Intruder Charm", "Invisibility Cloak", "Jelly-Legs Jinx", "Jelly Slugs", "Igor Karakaroff", "Keeper", "King's Cross Station", "The Knight Bus", "Knockturn Alley", "Knut", "Kreacher", "Viktor Krum", "Kwikspell", "The Leaky Cauldron", "Leprechaun", "Bellatrix Lestrange", "Levicorpus", "Liberacorpus", "Gilderoy Lockhart", "Alice Longbottom", "Frank Longbottom", "Neville Longbottom", "Luna Lovegood", "Aidan Lynch", "Magical Menagerie", "Abraxas Malfoy", "Draco Malfoy", "Lucus Malfoy", "Narcissa Malfoy", "Mandragora", "Mandrake", "Marauder's Map", "Olympe Maxime", "Merpeople", "Mimbulus Mimbletonia", "Ministry of Magic", "Mirror of Erised", "Moaning Myrtle", "Mobiliarbus", "Mobilicorpus", "Monkshood", "Alastor Moody", "Moony", "Morgana", "Muffliato", "Muggle", "Muggle Studies", "Nagini", "Nearly Headless Nick", "Niffler", "Phineas Nigellus", "Norbert", "Mrs Norris", "Norwegian Ridgeback", "Nosebleed Nougat", "Nox", "Obliviate", "Obliviator", "Occlumency", "Ollivanders", "Omnioculars", "Oppugno", "Padfoot", "Parselmouth", "Parseltongue", "Patronus", "Peeves", "Pensieve", "Pepper Imps", "Peppermint Toads", "Pepper-Up Potion", "Petrificus Totalus", "Pigwidgeon", "Pocket Sneakoscope", "Polyjuice Potion", "Madam Pomfrey", "Portkey", "Potions", "Harry Potter", "James Potter", "Lily Potter", "Prior Incantatem", "Privet Drive", "Prongs", "Protean Charm", "Puking Pastilles", "Pumpkin Juice", "Pumpkin Pasty", "Pure-Blood", "Put-Outer", "Pygmy Puffs", "Quaffle", "Quick-Quotes Quill", "Quidditch", "Quietus", "Professor Quirrell", "Ravenclaw House", "Rowena Ravenclaw", "Red Cap", "Reducio", "Reductor Curse", "Relashio", "Remembrall", "Reparo", "Rictusempra", "Riddikulus", "Riddle House", "Tom Marvolo Riddle", "Room of Requirement", "Scabbers", "Scourgify", "Secrecy Sensor", "Sectumsempra", "Seeker", "Shield Charm", "Shrieking Shack", "Sickle", "Silencio", "Professor Sinistra", "Skele-Gro", "Skiving Snackboxes", "Slug Club", "Horace Slughorn", "Slytherin House", "Salazar Slytherin", "Smeltings", "Severus Snape", "Sneakoscope", "Sonorus", "Sorceror's Stone", "Sorting Hat", "Specialis Revelio", "Spellotape", "Professor Sprout", "Squib", "Stinksap", "Stupefy", "Swelling Solution", "Tarantallegra", "Tergeo", "The Quibbler", "Thestrals", "Time-Turner", "Ton-Tongue Toffee", "Triwizard Tournament", "Dolores Umbridge", "Unforgiveable Curses", "Unicorn", "Unbreakable Vow", "Veela", "Venomous Tentacula", "Veritaserum", "Lord Voldemort", "Wand", "Ron Weasley", "The Weird Sisters", "Werewolf", "Whomping Willow", "Wingardium Leviosa", "Wizengamot", "Witherwings", "Wolfsbane", "Wormtail", "Zonko's"])

let spelling = GameMode(title: "Spelling Bee", phrases: ["Gladiolus", "Cerise", "Luxuriance", "Albumen", "Asceticism", "Fracas", "Foulard", "Knack", "Torsion", "Detoriorating", "Intelligible", "Interning", "Promiscuous", "Sanitarium", "Canonical", "Therapy", "Initials", "Sacrilegious", "Semaphore", "Chlorophyll", "Psychiatry", "Dulcimer", "Meticulosity", "Insouciant", "Vignette", "Soubrette", "Transept", "Crustaceology", "Condominium", "Schappe", "Syllepsis", "Catamaran", "Eudaemonic", "Smaragdine", "Esquamulose", "Equipage", "Sycophant", "Eczema", "Ratoon", "Chihuahua", "Abalone", "Interlocutory", "Croissant", "Shalloon", "Macerate", "Vouchsafe", "Hydrophyte", "Incisor", "Narcolepsy", "Cambist", "Deification", "Maculature", "Elucubrate", "Sarcophagus", "Psoriasis", "Purim", "Luge", "Milieu", "Odontalgia", "Staphylococci", "Elegiacal", "Spoliator", "Fibranne", "Antipyretic", "Lyceum", "Kamikaze", "Antediluvian", "Xanthosis", "Vivisepulture", "Euonym", "Chiaroscurist", "Logorrhea", "Demarche", "Succedaneum", "Prospicience", "Pococurante", "Autochthonous", "Appoggiatura", "Ursprache", "Serrefine", "Guerdon", "Laodicean", "Stromuhr", "Cymotrichous", "Guetapens", "Knaidel", "Feuilleton", "Stichomythia", "Scherenschnitte", "Nunatak", "Feldenkrais", "Gesellschaft"])

let shakespeare = GameMode(title: "Shakespeare", phrases: ["Crack of doom", "Forever and a day", "Live long day", "Heart of hearts", "Break the ice", "To be or not to be", "Live Long Day", "Fancy-Free", "The Game Is Afoot", "All Our Yesterdays", "With Bated Breath", "Brave New World", "Break The Ice", "Cold Comfort", "Crack Of Doom", "Dead As A Doornail", "Devil Incarnate", "Faint Hearted", "Forever And A Day", "For Goodness Sake", "Foregone Conclusion", "Full Circle", "Good Riddance", "Heart of Gold", "In My Mind's Eye", "Laughing Stock", "Love is Blind", "One Fell Swoop", "Play Fast and Loose", "Set My Teeth On Edge", "Wild-Goose Chase", "Seen Better Days", "Fair Play", "Lie Low", "It's Greek To Me", "Love Is Blind", "Break The Ice", "Mum's The Word", "Not Slept One Wink", "In Stitches", "Bear a Charmed Life", "Better Foot Before", "Breathed His Last", "Catch A Cold", "Come What Come May", "Elbow Room", "Flaming Youth", "Tis High Time", "In A Pickle", "It Smells To Heaven", "It Is But So-So", "Knit Brow", "Melted Into Thin Air", "Strange Bedfellows", "Primrose Path", "Sea Change", "Sound And Fury", "This Mortal Coil", "Working-Day World"])
