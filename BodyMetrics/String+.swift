//
//  String+.swift
//
//  Created by Ken Yu
//

import Foundation


public extension String {

    /**
    This function allows you to get i th char in the string by string[i]
    */
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }

    /**
    This function allow you to get i th char in the string as a String by string[i]
    */
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }

    /**
    This function allow you to get subString by string[i...j]
    */
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: startIndex.advancedBy(r.startIndex), end: startIndex.advancedBy(r.endIndex)))
    }

    /**
    This function allow you to get substring using NSRange
    */
    func substringWithRange(range: NSRange) -> String {
        var start = self.startIndex
        start = start.advancedBy(range.location)
        let end = start.advancedBy(range.length)

        return self.substringWithRange(Range<String.Index>(start: start,end: end))
    }

    /*
    :returns the floatValue of a string using NSString's method.
    */
    public var floatValue: Float {
        return (self as NSString).floatValue
    }

    /*
    Returns a copy of the string, with leading and trailing whitespace omitted.
    */
    public func trim() -> String {
        return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }

    /**
    Returns true if the text has any printable characters else returns false
    */
    public func hasPrintableCharacters() -> Bool {
        let trimmedText = stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        return !trimmedText.isEmpty
    }

    // return the length of string
    public var length: Int {
        return self.utf16.count
    }

    public func contains(find: String) -> Bool {
        return self.rangeOfString(find) != nil
    }

    // Validation for string entered into email field
    public func isEmail() -> Bool {
        let regex = try? NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .CaseInsensitive)
        return regex?.firstMatchInString(self, options: [], range: NSMakeRange(0, self.characters.count)) != nil
    }

    public func filter(pred: Character -> Bool) -> String {
        return String(self.characters.filter(pred))
    }
}