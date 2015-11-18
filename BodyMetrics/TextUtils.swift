//
//  TextUtils.swift
//  FeedTest
//
//  Created by Ken Yu on 3/13/15.
//  Copyright (c) 2015 Ken Yu. All rights reserved.
//

import Foundation
import UIKit

final public class TextUtils {

        static let linksExpression: NSRegularExpression? =  try? NSRegularExpression(pattern: WebUrlRegularExpressionConstants.kWebUrlPattern, options: [.CaseInsensitive])
    
    /**
    Dummy UIlabel created to avoid creating it everytime we require to compute sizes.
    */
    public static var dummyLabel: UILabel = {
        let label = UILabel()
        return label
        }()

    /**
    Returns the height of the text in specified bounding width.

    This method is faster than computing height using boundingRectWithSize.
    https://iwww.corp.linkedin.com/wiki/cf/pages/viewpage.action?pageId=126485100
    */
    public class func textHeight(text: String, font: UIFont, boundingWidth width: CGFloat, numberOfLines: Int = 0, attributedText: NSMutableAttributedString? = nil, minimumScaleFactor: CGFloat = 0.0) -> CGFloat {
        if text.isEmpty {
            return 0
        }

        let size = CGSize(width: width, height: CGFloat.max)
        dummyLabel.numberOfLines = 0
        dummyLabel.font = font
        dummyLabel.text = text
        dummyLabel.minimumScaleFactor = minimumScaleFactor

        if let attributedText = attributedText {
            dummyLabel.attributedText = attributedText
        }

        let height = ceil(dummyLabel.sizeThatFits(size).height)
        if (numberOfLines > 0) {
            let heightForLines = ceil(CGFloat(numberOfLines) * font.lineHeight)
            return min(heightForLines, height)
        } else {
            return height
        }
    }

    /**
    Returns the width of the text in specified font.
    */
    public class func textWidth(text: String, font: UIFont) -> CGFloat {
        return (text as NSString).sizeWithAttributes([NSFontAttributeName: font]).width
    }

    /**
    Returns the height of the text using boundingRectWithpoSize api, this is helpful when computing heights on background thread
    */
    public class func nonUITextHeight(text: String, font: UIFont, boundingWidth width: CGFloat, numberOfLines: Int = 0) -> CGFloat {
        if text.isEmpty {
            return 0
        }

        let size = CGSize(width: width, height: CGFloat.max)
        let rect = text.boundingRectWithSize(
            size,
            options: [NSStringDrawingOptions.UsesLineFragmentOrigin, NSStringDrawingOptions.UsesFontLeading],
            attributes: [NSFontAttributeName: font],
            context: nil)

        let height = ceil(rect.height)
        if numberOfLines > 0 {
            let heightForLines = ceil(CGFloat(numberOfLines) * font.lineHeight)
            return min(heightForLines, height)
        }

        return height
    }

    /**
    A convenience function that returns text height for a given label and text

    :param: text of the label
    :param: label defines the label we are going to show the text in
    :param: width is the bounding width of the label
    */
    public class func textHeight(text: String, forLabel label: UILabel, boundingWidth width: CGFloat) -> CGFloat {
        return textHeight(text, font: label.font, boundingWidth: width, numberOfLines: label.numberOfLines)
    }

    /**
    Dummy UITextView created to compute sizes.
    */
    public static var dummyTextView: UITextView = {
        let textView = UITextView()
        textView.contentInset = UIEdgeInsetsZero
        textView.layoutMargins = UIEdgeInsetsZero
        textView.textContainerInset = UIEdgeInsetsZero
        textView.textContainer.lineFragmentPadding = 0
        return textView
        }()

    /**
    Returns the height of the textview, when rendered with text in boundingWidth and using font
    */
    public class func textViewHeight(text: String, font: UIFont, boundingWidth width: CGFloat, numberOfLines: Int = 0) -> CGFloat {
        if text.isEmpty {
            return 0
        }

        let size = CGSize(width: width, height: CGFloat.max)
        dummyTextView.font = font
        dummyTextView.text = text
        let height = ceil(dummyTextView.sizeThatFits(size).height)

        if numberOfLines > 0 {
            let heightForLines = CGFloat(numberOfLines) * ceil(font.lineHeight)
            return min(heightForLines, height)
        }

        return height
    }

    /**
    Return url strings from text
    */
    public class func urlsFromText(text: String) -> [String] {
        var urlMatches = [String]()

        if let regularExpression = linksExpression {
            // Returns the array of matches for given regular expression.
            let urlRanges = regularExpression.matchesInString(text, options: NSMatchingOptions(), range: NSRange(location: 0, length: text.length))

            // Get array of Urls using range from NSTextCheckingResult.
            urlMatches = urlRanges.map { (text as NSString).substringWithRange(($0).range) }
        }

        // If regular expression returns no matches, use NSDataDetector
        if urlMatches.isEmpty {
            do {
                let urlDetector = try NSDataDetector(types: NSTextCheckingType.Link.rawValue)
                let notFoundRange = NSMakeRange(NSNotFound, 0)

                urlDetector.enumerateMatchesInString(text, options: [], range: NSMakeRange(0, text.utf16.count)) { (checkingResult, flags, mutablePointer) -> Void in
                    if let checkingResult = checkingResult {
                        let matchingRange = checkingResult.range
                        if !NSEqualRanges(matchingRange, notFoundRange) {
                            let matchingString = (text as NSString).substringWithRange(matchingRange)
                            urlMatches.append(matchingString)
                        }
                    }
                }
            } catch {
                return urlMatches
            }
        }
        
        return urlMatches
    }
}
