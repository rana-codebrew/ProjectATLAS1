//
//  MainVC.swift
//  Share
//
//  Created by Aseem 7 on 17/10/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MainVC: UIViewController {
    
//MARK: - Local Variables
    let disposeBag = DisposeBag()
    var viewModel:MainVM?
    var selectedBtn:UIButton?
    
    
//MARK: - Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet var btnCollection: [UIButton]!
    @IBOutlet var indicatorCollection: [UIView]!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var graphImage: UIImageView!
  
//MARK: - didLoad Function
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainVM(mainVCObj:self)
      bindingUI()
    }
    
//MARK: - UI Binding
    func bindingUI(){
        
        //Creating Pie Chart using Google static chart api
        let url = URL(string: "https://chart.googleapis.com/chart?cht=p&chs=140x140&chd=t:0,0,0,0,0,0")
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.graphImage.image = UIImage(data: data!)
            }
        }
        
        // Updating chart data
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(updateStatus), userInfo: nil, repeats: true)
        
        //Binding buttons
        self.userName.text=(UserDefaults.standard.value(forKey: "share_user_name") as! String)
      btnCollection.forEach{
        let btn:UIButton = $0
        btn.rx.tap.subscribe(onNext:{ _ in
            self.viewModel?.socialBtnClicked(btn)
        }).addDisposableTo(disposeBag)
        
      }
    }
    
    //Update status method
    func updateStatus() {
        viewModel?.updateStatus()
    }
}
 
