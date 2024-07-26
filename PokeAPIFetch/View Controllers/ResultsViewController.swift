//
//  ViewController.swift
//  PokeAPIFetch
//
//  Created by Space Wizard on 7/25/24.
//

import UIKit

class ResultsViewController: UIViewController {
    
    private let networkService: NetworkService
    
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
        
        view.backgroundColor = .red
        
        Task { [weak self] in
            guard let self = self else { return }
            let results = await self.networkService.fetchAllPokemon()
            print(results)
        }
    }


}

