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
import PNChart

class MainVC: UIViewController,PiechartDelegate {
    
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
    func bindingUI() {
       
        let url = URL(string: "https://chart.googleapis.com/chart?cht=p&chs=211x211&chd=t:20,20,10,10,30,10")
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.graphImage.image = UIImage(data: data!)
            }
        }
        
        self.userName.text=(UserDefaults.standard.value(forKey: "share_user_name") as! String)
      btnCollection.forEach{
        let btn:UIButton = $0
        btn.rx.tap.subscribe(onNext:{ _ in
            self.viewModel?.socialBtnClicked(btn)
        }).addDisposableTo(disposeBag)
        
      }
    }
    
    func setSubtitle(_ total: CGFloat, slice: Piechart.Slice) -> String {
        return "\(Int(slice.value / total * 100))% \(slice.text!)"
    }
    
    func setInfo(_ total: CGFloat, slice: Piechart.Slice) -> String {
        return "\(Int(slice.value))/\(Int(total))"
    }
}


