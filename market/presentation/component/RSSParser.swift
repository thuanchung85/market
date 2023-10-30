//
//  RSSParser.swift
//  market
//
//  Created by Admin on 30/10/2023.
//

import Foundation


struct RSSItem: Identifiable {
    let id = UUID()
    let title: String
    let link: String
    let description: String
    let pubDate: String
    let urlImage: String
    let isHeader: Bool
}

class RSSParser: NSObject, XMLParserDelegate {
    private var currentElement: String = ""
    private var currentTitle: String = ""
    private var currentLink: String = ""
    private var currentDescription: String = ""
    private var currentPubDate: String = ""
    private var currentImage: String = ""
    private var rssItems: [RSSItem] = []
    
    private var completion: ([RSSItem]) -> Void
    
    init(completion: @escaping ([RSSItem]) -> Void) {
        self.completion = completion
    }
    
    func parseRSSFeed(data: Data) {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        rssItems.removeAll()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentTitle = currentTitle == "" ? string : currentTitle
        case "link":
            currentLink = currentLink == "" ? string : currentLink
        case "description":
            currentDescription = currentDescription == "" ? string : currentDescription
        case "pubDate":
            currentPubDate = currentPubDate == "" ? string : currentPubDate
        case "url":
            currentImage = currentImage == "" ? string : currentImage
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let rssItem = RSSItem(title: currentTitle, link: currentLink, description: currentDescription, pubDate: currentPubDate, urlImage: currentImage, isHeader: rssItems.isEmpty ? true : false)
            rssItems.append(rssItem)
            
            currentTitle = ""
            currentLink = ""
            currentDescription = ""
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        completion(rssItems)
    }
}
