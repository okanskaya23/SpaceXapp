//
//  DetailViewController.swift
//  SpaceX
//
//  Created by Okan Sarp Kaya on 14.05.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailDescription: UITextView!
    var viewModel:Launches!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailDescription.text = viewModel.details == nil ? "Detail not provided" : viewModel.details
    }
    
    init(viewModel: Launches){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
