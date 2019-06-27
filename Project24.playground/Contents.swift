import UIKit

let name = "Taylor"

for letter in name {
    print("Give ma a \(letter)!")
}

// Subscripting with a bulit-in method
let letter = name[name.index(name.startIndex, offsetBy: 3)]

print(letter)

// Extending functionality of String by adding subscipting with Int by looping through letters
extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

let letter2 = name[3]

let password = "12345"
// Special methods for subscripting
let prefix = password.hasPrefix("123")
let suffix = password.hasSuffix("345")

extension String {
    // Custom deleting prefix if exists
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    // Custom deleting suffix if exists
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}

let weather = "it's going to rain"
print(weather.capitalized)

extension String {
    // Custom capitalized only first letter if exists
    // Character into String explain: https://www.hackingwithswift.com/read/24/3/working-with-strings-in-swift
    
    func capitalizeFirstLetter() -> String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
    }
}

let input = "Swift is like Objective-C without the C"
input.contains("Swift")

let languages = ["Python", "Ruby", "Swift"]
languages.contains("Swift")

// Custom check if a String contains an item of an array of String
extension String {
    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        
        return false
    }
}

input.containsAny(of: languages)

// Elegant way to check if an array of strings contains a specific string
languages.contains(where: input.contains)

// NSAttributedString

let string = "This is a test string"
let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 36)
]

// Basic attributed string (string + dictionary of NSAttributedString.Key)
let attributedString = NSAttributedString(string: string, attributes: attributes)

// NSMutableAttributedString is an attributed string which you can modify
let nsMutableAttributesString = NSMutableAttributedString(string: string)
nsMutableAttributesString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
nsMutableAttributesString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
nsMutableAttributesString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
nsMutableAttributesString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
nsMutableAttributesString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))

/// TODO: Challenge 1

// Custom withPrefix() adds a prefix to a tring if it doesn't exists already
extension String {
    func withPrefix(_ preFix: String) -> String {
        guard !self.hasPrefix(preFix) else { return self }
        return preFix + self
    }
}

"pet".withPrefix("car")
"carpet".withPrefix("car")

// TODO: Challenge 2

// Custom isNumeric check to see if a string contains any sort of number
extension String {
    var isNumeric: Bool {
        return self.contains("\(Int())") || self.contains("\(Double())") || self.contains("\(Float())") ? true : false
    }
}

"Hello, World".isNumeric
"H3ll0, W0rld1".isNumeric
"".isNumeric

// TODO: Challenge 3

// Custom lines property dividing String lines in array
extension String {
    var lines: [String] {
        guard !self.isEmpty else { return [""] }
        return self.components(separatedBy: "\n")
    }
}

"this\nis\na\ntest".lines
"".lines
