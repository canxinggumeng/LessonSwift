//
//  ActiveLabel.swift
//  ActiveLabel
//
//  Created by Johannes Schickling on 9/4/15.
//  Copyright © 2015 Optonaut. All rights reserved.
//

import Foundation
import UIKit

public protocol ActiveLabelDelegate: class {
    func didSelectText(text: String, type: ActiveType)
}

typealias ElementTuple = (range: NSRange, element: ActiveElement, type: ActiveType)

@IBDesignable public class ActiveLabel: UILabel {

    // MARK: - public properties
    public weak var delegate: ActiveLabelDelegate?

    public var enabledTypes: [ActiveType] = [.Mention, .Hashtag, .URL]

    public var urlMaximumLength: Int?

    @IBInspectable public var mentionColor: UIColor = UIColor.blue {
        didSet { updateTextStorage(parseText: false) }
    }
    @IBInspectable public var mentionSelectedColor: UIColor? {
        didSet { updateTextStorage(parseText: false) }
    }
    @IBInspectable public var hashtagColor: UIColor = UIColor.blue {
        didSet { updateTextStorage(parseText: false) }
    }
    @IBInspectable public var hashtagSelectedColor: UIColor? {
        didSet { updateTextStorage(parseText: false) }
    }
    @IBInspectable public var URLColor: UIColor = UIColor.blue {
        didSet { updateTextStorage(parseText: false) }
    }
    @IBInspectable public var URLSelectedColor: UIColor? {
        didSet { updateTextStorage(parseText: false) }
    }
    public var customColor: [ActiveType : UIColor] = [:] {
        didSet { updateTextStorage(parseText: false) }
    }
    public var customSelectedColor: [ActiveType : UIColor] = [:] {
        didSet { updateTextStorage(parseText: false) }
    }
    @IBInspectable public var lineSpacing: Float = 0 {
        didSet { updateTextStorage(parseText: false) }
    }

    // MARK: - public methods
    public func handleMentionTap(handler: @escaping (String) -> ()) {
        mentionTapHandler = handler
    }

    public func handleHashtagTap(handler: @escaping (String) -> ()) {
        hashtagTapHandler = handler
    }

    public func handleURLTap(handler: @escaping (NSURL) -> ()) {
        urlTapHandler = handler
    }

    public func handleCustomTap(for type: ActiveType, handler: @escaping (String) -> ()) {
        customTapHandlers[type] = handler
    }

    public func filterMention(predicate: @escaping (String) -> Bool) {
        mentionFilterPredicate = predicate
        updateTextStorage()
    }

    public func filterHashtag(predicate: @escaping (String) -> Bool) {
        hashtagFilterPredicate = predicate
        updateTextStorage()
    }

    // MARK: - override UILabel properties
    override public var text: String? {
        didSet { updateTextStorage() }
    }

    override public var attributedText: NSAttributedString? {
        didSet { updateTextStorage() }
    }

    override public var font: UIFont! {
        didSet { updateTextStorage(parseText: false) }
    }

    override public var textColor: UIColor! {
        didSet { updateTextStorage(parseText: false) }
    }

    override public var textAlignment: NSTextAlignment {
        didSet { updateTextStorage(parseText: false)}
    }

    public override var numberOfLines: Int {
        didSet { textContainer.maximumNumberOfLines = numberOfLines }
    }

    public override var lineBreakMode: NSLineBreakMode {
        didSet { textContainer.lineBreakMode = lineBreakMode }
    }

    // MARK: - init functions
    override public init(frame: CGRect) {
        super.init(frame: frame)
        _customizing = false
        setupLabel()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _customizing = false
        setupLabel()
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        updateTextStorage()
    }

    public override func drawText(in rect: CGRect) {
        let range = NSRange(location: 0, length: textStorage.length)

        textContainer.size = rect.size
        let newOrigin = textOrigin(inRect: rect)

        layoutManager.drawBackground(forGlyphRange: range, at: newOrigin)
        layoutManager.drawGlyphs(forGlyphRange: range, at: newOrigin)
    }


    // MARK: - customzation
    public func customize(block: (_ label: ActiveLabel) -> ()) -> ActiveLabel {
        _customizing = true
        block(self)
        _customizing = false
        updateTextStorage()
        return self
    }

    // MARK: - Auto layout

    
    public override var intrinsicContentSize: CGSize {
        let superSize = super.intrinsicContentSize
        textContainer.size = CGSize(width: superSize.width, height: CGFloat.greatestFiniteMagnitude)
        let size = layoutManager.usedRect(for: textContainer)
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }

    // MARK: - touch events
    func onTouch(touch: UITouch) -> Bool {
        let location = touch.location(in: self)
        var avoidSuperCall = false

        switch touch.phase {
        case .began, .moved:
            if let element = elementAtLocation(location: location) {
                if element.range.location != selectedElement?.range.location || element.range.length != selectedElement?.range.length {
                    updateAttributesWhenSelected(isSelected: false)
                    selectedElement = element
                    updateAttributesWhenSelected(isSelected: true)
                }
                avoidSuperCall = true
            } else {
                updateAttributesWhenSelected(isSelected: false)
                selectedElement = nil
            }
        case .ended:
            guard let selectedElement = selectedElement else { return avoidSuperCall }

            switch selectedElement.element {
            case .Mention(let userHandle): didTapMention(username: userHandle)
            case .Hashtag(let hashtag): didTapHashtag(hashtag: hashtag)
            case .URL(let originalURL, _): didTapStringURL(stringURL: originalURL)
            case .Custom(let element): didTap(element: element, for: selectedElement.type)
            }

//            let when = dispatch_time(dispatch_time_t(DispatchTime.now), Int64(0.25 * Double(NSEC_PER_SEC)))
//            dispatch_after(when, dispatch_get_main_queue()) {
//                self.updateAttributesWhenSelected(false)
//                self.selectedElement = nil
//            }
            
            let deadlineTime = DispatchTime.now() + DispatchTimeInterval.seconds(Int(Int64(0.25 * Double(NSEC_PER_SEC))))
            
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.updateAttributesWhenSelected(isSelected: false)
                self.selectedElement = nil

            }
            
            
            
            
            avoidSuperCall = true
        case .cancelled:
            updateAttributesWhenSelected(isSelected: false)
            selectedElement = nil
        case .stationary:
            break
        }

        return avoidSuperCall
    }

    // MARK: - private properties
    private var _customizing: Bool = true
    private var defaultCustomColor: UIColor = UIColor.black

    private var mentionTapHandler: ((String) -> ())?
    private var hashtagTapHandler: ((String) -> ())?
    private var urlTapHandler: ((NSURL) -> ())?
    private var customTapHandlers: [ActiveType : ((String) -> ())] = [:]

    private var mentionFilterPredicate: ((String) -> Bool)?
    private var hashtagFilterPredicate: ((String) -> Bool)?

    private var selectedElement: ElementTuple?
    private var heightCorrection: CGFloat = 0
    private lazy var textStorage = NSTextStorage()
    private lazy var layoutManager = NSLayoutManager()
    private lazy var textContainer = NSTextContainer()
    lazy var activeElements = [ActiveType: [ElementTuple]]()

    // MARK: - helper functions
    private func setupLabel() {
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines
        isUserInteractionEnabled = true
    }

    private func updateTextStorage(parseText: Bool = true) {
        if _customizing { return }
        // clean up previous active elements
        guard let attributedText = attributedText , attributedText.length > 0 else {
            clearActiveElements()
            textStorage.setAttributedString(NSAttributedString())
            setNeedsDisplay()
            return
        }

        let mutAttrString = addLineBreak(attrString: attributedText)

        if parseText {
            clearActiveElements()
            let newString = parseTextAndExtractActiveElements(attrString: mutAttrString)
            mutAttrString.mutableString.setString(newString)
        }

        addLinkAttribute(mutAttrString: mutAttrString)
        textStorage.setAttributedString(mutAttrString)
        _customizing = true
        text = mutAttrString.string
        _customizing = false
        setNeedsDisplay()
    }

    private func clearActiveElements() {
        selectedElement = nil
        for (type, _) in activeElements {
            activeElements[type]?.removeAll()
        }
    }

    private func textOrigin(inRect rect: CGRect) -> CGPoint {
        let usedRect = layoutManager.usedRect(for: textContainer)
        heightCorrection = (rect.height - usedRect.height)/2
        let glyphOriginY = heightCorrection > 0 ? rect.origin.y + heightCorrection : rect.origin.y
        return CGPoint(x: rect.origin.x, y: glyphOriginY)
    }

    /// add link attribute
    private func addLinkAttribute(mutAttrString: NSMutableAttributedString) {
        var range = NSRange(location: 0, length: 0)
        var attributes = mutAttrString.attributes(at: 0, effectiveRange: &range)

        attributes[NSFontAttributeName] = font!
        attributes[NSForegroundColorAttributeName] = textColor
        mutAttrString.addAttributes(attributes, range: range)

        attributes[NSForegroundColorAttributeName] = mentionColor

        for (type, elements) in activeElements {

            switch type {
            case .Mention: attributes[NSForegroundColorAttributeName] = mentionColor
            case .Hashtag: attributes[NSForegroundColorAttributeName] = hashtagColor
            case .URL: attributes[NSForegroundColorAttributeName] = URLColor
            case .Custom: attributes[NSForegroundColorAttributeName] = customColor[type] ?? defaultCustomColor
            }

            for element in elements {
                mutAttrString.setAttributes(attributes, range: element.range)
            }
        }
    }

    /// use regex check all link ranges
    private func parseTextAndExtractActiveElements(attrString: NSMutableAttributedString) -> String {
        var textString = attrString.string
        var textLength = textString.utf16.count
        var textRange = NSRange(location: 0, length: textLength)

        if enabledTypes.contains(.URL) {
            let tuple = ActiveBuilder.createURLElements(from: textString, range: textRange, maximumLenght: urlMaximumLength)
            let urlElements = tuple.0
            let finalText = tuple.1
            textString = finalText
            textLength = textString.utf16.count
            textRange = NSRange(location: 0, length: textLength)
            activeElements[.URL] = urlElements
        }

        for type in enabledTypes where type != .URL{
            var filter: ((String) -> Bool)? = nil
            if type == .Mention {
                filter = mentionFilterPredicate
            } else if type == .Hashtag {
                filter = hashtagFilterPredicate
            }
            let hashtagElements = ActiveBuilder.createElements(type: type, from: textString, range: textRange, filterPredicate: filter)
            activeElements[type] = hashtagElements
        }

        return textString
    }


    /// add line break mode
    private func addLineBreak(attrString: NSAttributedString) -> NSMutableAttributedString {
        let mutAttrString = NSMutableAttributedString(attributedString: attrString)

        var range = NSRange(location: 0, length: 0)
        var attributes = mutAttrString.attributes(at: 0, effectiveRange: &range)

        let paragraphStyle = attributes[NSParagraphStyleAttributeName] as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineSpacing = CGFloat(lineSpacing)

        attributes[NSParagraphStyleAttributeName] = paragraphStyle
        mutAttrString.setAttributes(attributes, range: range)

        return mutAttrString
    }

    private func updateAttributesWhenSelected(isSelected: Bool) {
        guard let selectedElement = selectedElement else {
            return
        }

        var attributes = textStorage.attributes(at: 0, effectiveRange: nil)
        let type = selectedElement.type

        if isSelected {
            let selectedColor: UIColor
            switch type {
            case .Mention: selectedColor = mentionSelectedColor ?? mentionColor
            case .Hashtag: selectedColor = hashtagSelectedColor ?? hashtagColor
            case .URL: selectedColor = URLSelectedColor ?? URLColor
            case .Custom:
                let possibleSelectedColor = customSelectedColor[selectedElement.type] ?? customColor[selectedElement.type]
                selectedColor = possibleSelectedColor ?? defaultCustomColor
            }
            attributes[NSForegroundColorAttributeName] = selectedColor
        } else {
            let unselectedColor: UIColor
            switch type {
            case .Mention: unselectedColor = mentionColor
            case .Hashtag: unselectedColor = hashtagColor
            case .URL: unselectedColor = URLColor
            case .Custom: unselectedColor = customColor[selectedElement.type] ?? defaultCustomColor
            }
            attributes[NSForegroundColorAttributeName] = unselectedColor
        }

        textStorage.addAttributes(attributes, range: selectedElement.range)

        setNeedsDisplay()
    }

    private func elementAtLocation(location: CGPoint) -> ElementTuple? {
        guard textStorage.length > 0 else {
            return nil
        }

        var correctLocation = location
        correctLocation.y -= heightCorrection
        let boundingRect = layoutManager.boundingRect(forGlyphRange: NSRange(location: 0, length: textStorage.length), in: textContainer)
        guard boundingRect.contains(correctLocation) else {
            return nil
        }

        let index = layoutManager.glyphIndex(for: correctLocation, in: textContainer)

        for element in activeElements.map({ $0.1 }).joined() {
            if index >= element.range.location && index <= element.range.location + element.range.length {
                return element
            }
        }

        return nil
    }


    //MARK: - Handle UI Responder touches
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if onTouch(touch: touch) { return }
        super.touchesBegan(touches, with: event)
    }
//    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        if onTouch(touch: touch) { return }
//        super.touchesBegan(touches, with: event)
//    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if onTouch(touch: touch) { return }
        super.touchesMoved(touches, with: event)
    }
//    public override func touchesMoved(_touches: Set<UITouch>, withEvent event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        if onTouch(touch: touch) { return }
//        super.touchesMoved(touches, with: event)
//    }

    
    public override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        guard let touch = touches?.first else { return }
        let _ = onTouch(touch: touch)
        super.touchesCancelled(touches!, with: event)
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if onTouch(touch: touch) { return }
        super.touchesEnded(touches, with: event)
    }
//    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        if onTouch(touch: touch) { return }
//        super.touchesEnded(touches, with: event)
//    }

    //MARK: - ActiveLabel handler
    private func didTapMention(username: String) {
        guard let mentionHandler = mentionTapHandler else {
            delegate?.didSelectText(text: username, type: .Mention)
            return
        }
        mentionHandler(username)
    }

    private func didTapHashtag(hashtag: String) {
        guard let hashtagHandler = hashtagTapHandler else {
            delegate?.didSelectText(text: hashtag, type: .Hashtag)
            return
        }
        hashtagHandler(hashtag)
    }

    private func didTapStringURL(stringURL: String) {
        guard let urlHandler = urlTapHandler, let url = NSURL(string: stringURL) else {
            delegate?.didSelectText(text: stringURL, type: .URL)
            return
        }
        urlHandler(url)
    }

    private func didTap(element: String, for type: ActiveType) {
        guard let elementHandler = customTapHandlers[type] else {
            delegate?.didSelectText(text: element, type: type)
            return
        }
        elementHandler(element)
    }
}

extension ActiveLabel: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
