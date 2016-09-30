//
//  TagStyles.swift
//
//  Created by Brian King on 8/12/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation

/// TagStyles stores styles, and allows them to be looked up by name. This is primarily used for supporting
/// Interface builder and styling markup.
@objc(BONTagStyles)
public class TagStyles: NSObject {

    /// A shared repository of styles. The shared TagStyle is used by the Interface Builder styleName property.
    /// This singleton is per-populated with 3 values for Dynamic Text. "control", "body", and "preferred"
    #if os(iOS) || os(tvOS)
    public static var shared = TagStyles(
        styles: [
            "control": BonMot(.adapt(.control)),
            "body": BonMot(.adapt(.body)),
            "preferred": BonMot(.adapt(.preferred)) ,
        ]
    )
    #else
    public static var shared = TagStyles()
    #endif

    /// Define a closure to be invoked when an unregistered style is requested. By default
    /// an error is printed.
    public static var unregisteredStyleClosure: (String) -> Void = { name in
        print("Requesting unregistered style \(name)")
    }

    public init(styles: [String: AttributedStringStyle] = [:]) {
        self.styles = styles
    }

    public var styles: [String: AttributedStringStyle]

    public func registerStyle(forName name: String, style: AttributedStringStyle) {
        styles[name] = style
    }

    /// The style lookup can be passed a set of intial attributes. This is done so UI Elements can
    /// pass their configured font in as a hint for what font to use by the style.
    ///
    /// The primary purpose of this is so the style name can be set to 'control' or 'body' and whatever font is
    /// in the chain can be adapted.
    ///
    /// - parameter forName: The name of the style to lookup
    /// - parameter initialAttributes: The initial attributes to pass to the style chain
    /// - returns: the configured style, or nil if none is found
    public func style(forName name: String, initialAttributes: StyleAttributes = [:]) -> AttributedStringStyle? {
        guard var style = styles[name] else {
            TagStyles.unregisteredStyleClosure(name)
            return nil
        }
        style.update(attributes: initialAttributes)
        return style
    }

}
