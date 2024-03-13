//
//  TitlePreviewViewController.swift
//  Netflix Clone
//
//  Created by Vinayak Putta on 13/01/24.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {
    
    private let movietTitle: Title
    lazy var previewMoiveDataService = MoviePreviewDataService(httpClient: URLSession.shared, dataDecoder: DataDecoder())
    
    init(movietTitle: Title) {
        self.movietTitle = movietTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel: UILabel = {
       
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicatorView
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.layer.cornerRadius = 8
        button.setTitle("Download", for: .normal)
        button.layer.masksToBounds = true
        button.isHidden = true
        return button
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)
        view.addSubview(activityIndicatorView)
        activityIndicatorView.isHidden = false
        
        configureConstraints()
        view.bringSubviewToFront(activityIndicatorView)
        activityIndicatorView.startAnimating()

        previewMoiveDataService.getMovie(with: movietTitle) { [weak self] result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self?.configure(with: model)
                    self?.activityIndicatorView.isHidden = true
                    self?.activityIndicatorView.stopAnimating()
                }
            case .failure(let failure):
                print(failure.apiErrorString)
            }
        }
    }

    func configureConstraints() {
        NSLayoutConstraint.activate([
            
            // webViewConstraints
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300),
            
            // titleLabelConstraints
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            // overviewLabelConstraints
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // activityIndicatorViewConstraints
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // downloadButtonConstraints
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 25),
            downloadButton.widthAnchor.constraint(equalToConstant: 140),
            downloadButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    
    private func configure(with model: TitlePreviewViewModel) {
        titleLabel.text = model.title
        overviewLabel.text = model.titleOverview
        downloadButton.isHidden = false
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else {
            return
        }
        webView.load(URLRequest(url: url))
    }

}
