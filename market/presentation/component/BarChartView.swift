//
//  BarChartView.swift
//  market
//
//  Created by Admin on 30/10/2023.
//

import SwiftUI
import LightweightCharts


struct BarChartView: UIViewControllerRepresentable {
    typealias UIViewControllerType = CustomLocaleViewController
    var id: Int
    func makeUIViewController(context: Context) -> CustomLocaleViewController {
        let view = CustomLocaleViewController()
        view.id = id
        return view
    }

    func updateUIViewController(_ uiViewController: CustomLocaleViewController, context: Context) {
        // Update the view controller if needed
    }
}



class CustomLocaleViewController: UIViewController {
    var data: [BaselineData] = []
    var id: Int = 1
    private var chart: LightweightCharts?
    private var series: BaselineSeries?
    
    func fetchData() {
        guard let urlComponents = URLComponents(string: "https://api-dev-poolswallet.poolsmobility.com/pools-wallet/market/chart/\(id)") else {
            return
        }
        // Create the request
        guard let url = urlComponents.url else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(QuotesChartData.self, from: data)
                DispatchQueue.main.async {
                    if decodedData.quotes?.count ?? 0 > 40 {
                        self.data = decodedData.quotes?.map { quotesChartItemData in
                            return BaselineData(
                                time: .string(quotesChartItemData.time ?? ""),
                                value: Double(quotesChartItemData.value ?? 0.0)
                            )
                        } ?? []
                        self.setupUI()
                        self.setupData()
                        self.chart?.timeScale().fitContent()
                    }
                }
            } catch {
                print("Error decoding API response: \(error)")
            }
        }.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        self.setupUI()
        self.setupData()
        self.chart?.timeScale().fitContent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
    }
    
    private func setupUI() {
        let options = ChartOptions(
            rightPriceScale: VisiblePriceScaleOptions(
                scaleMargins: PriceScaleMargins(top: 0.1, bottom: 0.1)
            )
        )
        let chart = LightweightCharts(options: options)
        view.addSubview(chart)
        chart.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                chart.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                chart.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                chart.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                chart.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                chart.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                chart.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                chart.topAnchor.constraint(equalTo: view.topAnchor),
                chart.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
        self.chart = chart
    }
    
    private func setupData() {
        let series = chart?.addBaselineSeries(options: BaselineSeriesOptions(
            baseValue: BaseValueType.baseValuePrice(BaseValuePrice(price: data.count > 40 ? data[data.count - 30].value ?? 0.0 : 0.0, type: .price)),
                topFillColor1: "rgba( 38, 166, 154, 0.28)",
                topFillColor2: "rgba( 38, 166, 154, 0.05)",
                topLineColor: "rgba( 38, 166, 154, 1)",
                bottomFillColor1: "rgba( 239, 83, 80, 0.05)",
                bottomFillColor2: "rgba( 239, 83, 80, 0.28)",
                bottomLineColor: "rgba( 239, 83, 80, 1)"
            )
        )
        
        series?.setData(data: data)
        self.series = series
    }

}
