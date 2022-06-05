//
//  NewsViewController.swift
//  Basic
//
//  Created by pineone on 2021/09/16.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable
import SnapKit
import Then

// URL : https://newsapi.org/v2/top-headlines?country=kr&apiKey=API_KEY
// KEY : f202c130bd5d4aeb8f12418c86166e09
// https://newsapi.org/v2/top-headlines?country=kr&apiKey=f202c130bd5d4aeb8f12418c86166e09
struct NewsData : Codable {
    var status : String
    var totalResults : Int
    var articles : [Article]
}
struct Article : Codable {
    var title : String
    var url : String
    var publishedAt : String
}
class NewsViewController: UIBaseViewController, ViewModelProtocol {
    
    typealias ViewModel = NewsViewModel
    
    // MARK: - ViewModelProtocol
    var viewModel: ViewModel!
    
    // MARK: - Properties
    let tableViewTitle = "News"
    var newsData : NewsData?
    var tableView : UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadJson()
        // Do any additional setup after loading the view.
        setupLayout()
        bindingViewModel()
        self.tableViewSetting()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Binding
    func bindingViewModel() {
        _ = viewModel.transform(req: ViewModel.Input())
    }
    
    // MARK: - View
    let subView = NewsView()
    
    func setupLayout() {
        view.addSubview(subView)
        subView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-BaseTabBarController.shared.tabBarHeight)
        }
    }
    
    func tableViewSetting() {
        self.view.addSubview(self.tableView)
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.dataSource = self
    }
    
    // MARK: - Methods
    func loadJson() {
        let newsURL =  "https://newsapi.org/v2/top-headlines?country=kr&apiKey=f202c130bd5d4aeb8f12418c86166e09"
        if let url =  URL(string: newsURL) {
            let sessoion = URLSession(configuration: .default)
            let task = sessoion.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let JSONdata = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(NewsData.self, from: JSONdata)
                        //print(decodedData.articles[0].urlToImage)
                        //print(decodedData.articles[0].title)
                        //print(decodedData.articles[0].url)
                        //print(decodedData.articles[0].publishedAt)
                        self.newsData = decodedData
                        DispatchQueue.main.sync {
                            self.tableView.reloadData()
                        }
                    } catch {
                        print("ERROR: Parsing Failed")
                    }
                }
            }
            task.resume()
            
        }
    }
    
    func dateSplit(_ date: String) -> String {
        let temp1 = date.split(separator: "-")
        let temp2 = temp1[2].split(separator: "T")
        let temp3 = temp2[1].split(separator: ":")
        
        return "\(temp1[0])/\(temp1[1])/\(temp2[0]) \(temp3[0]):\(temp3[1])"
    }
}


// MARK: - Class Extension
extension NewsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webkitController = WebkitController()
        print(newsData?.articles[indexPath.row].url)
        webkitController.articleURL = newsData?.articles[indexPath.row].url
        self.navigationController?.pushViewController(webkitController, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let aTitle = newsData?.articles[indexPath.row].title
        let aDate = newsData?.articles[indexPath.row].publishedAt
        
        cell.cellLabelTitle.text = aTitle
        if let date = aDate {
            cell.cellLabelDate.text = dateSplit(date)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableViewTitle
    }
}
