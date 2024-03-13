//
//  UpcomingViewController.swift
//  Netflix Clone
//
//  Created by Vinayak Putta on 13/01/24.
//

import UIKit

class UpcomingViewController: UIViewController {
    private var titles: [Title] = [Title]()
    
    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    var isLoadingMore = false
    var pageNo = 1

    lazy var dataService = UpcomingMoviesDataService(httpClient: URLSession.shared, dataDecoder: DataDecoder())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true

        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        fetchUpcoming()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }

    private func fetchUpcoming() {
        dataService.getUpcomingMovies(pageCount: pageNo) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.titles.append(contentsOf: response.results)
                    self?.upcomingTable.reloadData()
                    self?.isLoadingMore = false
                }
            case .failure(let error):
                print(error.apiErrorString)
            }
        }
    }
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: (title.original_title ?? title.original_name) ?? "Unknown title name", posterURL: title.poster_path ?? ""))
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        let previewVC = TitlePreviewViewController(movietTitle: title)
        self.navigationController?.pushViewController(previewVC, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !isLoadingMore {
                isLoadingMore = true
                pageNo += 1
                fetchUpcoming()
            }
        }
    }
}

