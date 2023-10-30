//
//  newsMarket.swift
//  market
//
//  Created by Admin on 30/10/2023.
//

import SwiftUI
import SWXMLHash

struct newsMarket: View {
    @State private var rssItems: [RSSItem] = []
    func fetchRSSFeed() {
        guard let url = URL(string: "https://api-dev-poolswallet.poolsmobility.com/pools-wallet/news/rss") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                // Handle error
                print("Error fetching RSS feed: \(error)")
                return
            }
            
            if let data = data {
                let rssParser = RSSParser { rssItems in
                    DispatchQueue.main.async {
                        self.rssItems = rssItems
                    }
                }
                rssParser.parseRSSFeed(data: data)
            }
        }
        
        task.resume()
    }
    var body: some View {
        VStack {
            ScrollView {
                ForEach(rssItems) { item in
                    if item.isHeader {
                        VStack {
                            HStack(spacing: 0) {
                                Text(item.title)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .bold()
                                    .foregroundColor(Color.gray)
                                Spacer()
                                AsyncImage(
                                    url: URL(string: item.urlImage)!,
                                    
                                    placeholder: { Text("Loading ...") },
                                    
                                    image: {
                                        Image(uiImage: $0)
                                            .resizable()
                                    }
                                )
                                .scaledToFit()
                                .frame(width: 90)
                            }
                            .padding(10)
                        }
                        .background(Color.gray.opacity(0.15))
                    }
                    else {
                        VStack {
                            Link(
                                destination: URL(string: item.link)!,
                                label: {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text(item.title)
                                            .foregroundColor(Color.black)
                                            .font(.headline)
                                            .multilineTextAlignment(.leading)
                                        Text(item.description)
                                            .font(.subheadline)
                                            .multilineTextAlignment(.leading)
                                        Text(item.pubDate)
                                            .font(.caption)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .foregroundColor(Color.gray)
                                    .padding(10)
                                }
                            )
                            Divider()
                        }
                        
                    }
                }
            }
        }

        .onAppear {
            fetchRSSFeed()
        }
    }
}

struct newsMarket_Previews: PreviewProvider {
    static var previews: some View {
        newsMarket()
    }
}

