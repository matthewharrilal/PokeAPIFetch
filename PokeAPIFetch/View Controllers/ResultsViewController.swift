//
//  ViewController.swift
//  PokeAPIFetch
//
//  Created by Space Wizard on 7/25/24.
//

import UIKit

class ResultsViewController: UIViewController {
    
    private let networkService: NetworkService
    private var pokemonWithImages: [PokemonWithImage] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.register(ResultsTableViewCell.self, forCellReuseIdentifier: ResultsTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setup()
        
        Task {
            await fetchPokemonWithImages()
        }
    }
}

private extension ResultsViewController {
    
    func setup() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func fetchPokemonWithImages() async {
        async let pokemonWithImageStream = networkService.fetchImagesForPokemon(pokemonStream: networkService.fetchAllPokemonDetails())
        
        for await pokemonWithImage in await pokemonWithImageStream {
            if let pokemonWithImage = pokemonWithImage {
                pokemonWithImages.append(pokemonWithImage)
                
                tableView.insertRows(at: [IndexPath(row: pokemonWithImages.count - 1, section: 0)], with: .bottom)
            }
        }
    }
}

extension ResultsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pokemonWithImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultsTableViewCell.identifier, for: indexPath) as? ResultsTableViewCell else { return UITableViewCell() }
        
        let pokemonWithImage = pokemonWithImages[indexPath.row]
        cell.configure(pokemonWithImage)
        
        return cell
    }
}


