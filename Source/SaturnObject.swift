//
//  SaturnObject.swift
//  Saturn
//
//  Created by Quinn McHenry on 11/14/15.
//  Copyright © 2015 Small Planet. All rights reserved.
//

import Foundation

public protocol SaturnObject {
    func loadIntoParent(parent: AnyObject)
    func setAttribute(attribute: String, forProperty property: String)
    func setAttributes(attributes:[String:String]?)
    func objectsWithId(id: String) -> [AnyObject]
}

extension SaturnObject {
    public static func readFromString(string: String, prepare: Bool = true) -> SaturnObject? {
        if let xmlData = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            do {
                let xmlDoc = try AEXMLDocument(xmlData: xmlData, processNamespaces: false)
                if let parsedElement = parseElement(xmlDoc.root) {
                    return parsedElement
                }
            } catch {
                return nil
            }
        }
        return nil
    }
    
    public static func parseElement(element: AEXMLElement) -> SaturnObject? {
        if let entityClass = NSClassFromString(element.name) as? NSObject.Type {
            let entity = entityClass.init()
            entity.setAttributes(element.attributes as? [String:String])
            element.children.forEach { child in
                if let subEntity = parseElement(child) {
                    subEntity.loadIntoParent(entity)
                }
            }
            return entity
        }
        return nil
    }
}
