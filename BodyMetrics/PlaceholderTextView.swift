//
//  PlaceholderTextView.swift
//

import Foundation
//import Hakawai

/**
This is a UITextView with a placeholder label. If the text is set either by user or programatically, then the
placeholder label is hidden.
*/
/*
public class PlaceholderTextView : HKWTextView {

    public static let kDefaultPlaceholderTextColor = Styles.Colors.Black
    // MARK: UI elements

    public lazy var placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.font = self.font
        placeholderLabel.textColor = self.placeholderTextColor
        placeholderLabel.textAlignment = self.textAlignment
        placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = UIColor.clearColor()
        placeholderLabel.layer.zPosition = -999
        placeholderLabel.isAccessibilityElement = false
        self.addSubview(placeholderLabel)
        return placeholderLabel
        }()


    // MARK: UI properties

    public var placeholderText: String = "" {
        didSet {
            placeholderLabel.text = placeholderText
            self.setNeedsLayout()
        }
    }

    public var placeholderTextColor: UIColor = PlaceholderTextView.kDefaultPlaceholderTextColor {
        didSet {
            placeholderLabel.textColor = placeholderTextColor
        }
    }

    public override var text: String! {
        didSet {
            textDidChange()
        }
    }

    public override var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }

    public override var font: UIFont! {
        didSet {
            placeholderLabel.font = font
        }
    }

    public override var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }

    // hold the reference to the mentions plugin to extract mentions
    public weak var mentionsPlugin: HKWMentionsPlugin?

    // MARK: Properties

    private var placeholderVisible = true

    // MARK: Initializers

    public init() {
        super.init(frame: CGRectZero, textContainer: nil)
        initialSetup()
    }

    public init(frame: CGRect) {
        super.init(frame: frame, textContainer: nil)
        initialSetup()
    }

    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        initialSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }

    public func initialSetup() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "textViewTextDidChangeNotification:",
            name: UITextViewTextDidChangeNotification,
            object: self)

        contentInset =  UIEdgeInsetsZero
        layoutMargins = UIEdgeInsetsZero
        textContainer.lineFragmentPadding = 0
    }

    // hack to not disable auto suggestions
    public override func overrideAutocorrectionWith(override: UITextAutocorrectionType) { }

    public override func layoutSubviews() {
        super.layoutSubviews()

        placeholderLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
    }

    public func textViewTextDidChangeNotification(notification: NSNotification) {
        if let notifiedTextView = notification.object as? PlaceholderTextView {
            if (notifiedTextView == self) {
                textDidChange()
            }
        }
    }

    public func textDidChange() {
        if ((!placeholderVisible && text.isEmpty) || (placeholderVisible && !text.isEmpty)) {
            placeholderVisible = text.isEmpty

            UIView.animateWithDuration(0.1) {
                self.placeholderLabel.alpha = (self.text.isEmpty) ? 1 : 0
            }
        }
    }

//    public func addMentionsPlugin(mentionsPlugin: HKWMentionsPlugin?, simpleDelegate: UITextViewDelegate?) {
//        self.mentionsPlugin = mentionsPlugin
//        if let mentionsPlugin = mentionsPlugin {
//            mentionsPlugin.delegate = MentionsCreationManager.sharedInstance
//            mentionsPlugin.resumeMentionsCreationEnabled = true
//            controlFlowPlugin = mentionsPlugin
//            if let simpleDelegate = simpleDelegate {
//                self.simpleDelegate = simpleDelegate
//            }
//        }
//    }

//    public func feedAnnotatedText() -> FeedAnnotatedText {
//        if let mentions = mentionsPlugin?.mentions() as? [HKWMentionsAttribute] {
//            let txt = text as NSString
//
//            var annotatedStrings: [FeedAnnotatedString?] = []
//            var currentLocation: Int = 0
//
//            // add first non mention chunk if any
//            if let firstMention = mentions.first where firstMention.range.location != 0 {
//                let builder = FeedAnnotatedStringBuilder()
//                builder.value = txt.substringWithRange(NSRange(location: 0, length: firstMention.range.location))
//                annotatedStrings.append(builder.build())
//                currentLocation = firstMention.range.location
//            }
//
//            for mention in mentions {
//                // add non mention chunk
//                if currentLocation < mention.range.location {
//                    let builder = FeedAnnotatedStringBuilder()
//                    builder.value = txt.substringWithRange(NSRange(location: currentLocation, length: mention.range.location - currentLocation))
//                    annotatedStrings.append(builder.build())
//                }
//
//                // add mention chunk
//                let builder = FeedAnnotatedStringBuilder()
//                builder.value = txt.substringWithRange(NSRange(location: mention.range.location, length: mention.range.length))
//                builder.entity = mention.entityMetadata()["entity"] as? FeedAnnotatedStringEntity
//                annotatedStrings.append(builder.build())
//
//
//                currentLocation = mention.range.location + mention.range.length
//            }
//
//            // add last non mention chunk if any
//            if currentLocation < txt.length {
//                let builder = FeedAnnotatedStringBuilder()
//                builder.value = txt.substringWithRange(NSRange(location: currentLocation, length: txt.length - currentLocation))
//                annotatedStrings.append(builder.build())
//            }
//
//            return FeedAnnotatedText.buildFrom(annotatedStrings)
//        } else {
//            return FeedAnnotatedText.buildFrom(text)
//        }
//    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: UITextViewTextDidChangeNotification,
            object: nil)
    }
    
}
*/