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
    var selectedIndex:Int = 0
    var statusTimer:Timer?
    var imageObservavle = Variable<[UIImage]>([])
    var selectedImage : [UIImage] = []
    var selectedTag : [Int] = []
    
//MARK: - Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var graphImage: UIImageView!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnTop: UIButton!
    @IBOutlet weak var graphCenterView: UIView!
    
  
//MARK: - didLoad Function
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainVM(mainVCObj:self)
        bindingUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Updating chart data
        if(UserDefaults.standard.value(forKey: userDefaultsKey.bgColor.rawValue) != nil ){
            
            let bgColor:Data = UserDefaults.standard.value(forKey: userDefaultsKey.bgColor.rawValue) as! Data
            let color:UIColor = NSKeyedUnarchiver.unarchiveObject(with: bgColor) as! UIColor
            self.view.backgroundColor=color
            self.btnTop.backgroundColor=color
            self.btnHome.backgroundColor=color
            self.graphCenterView.backgroundColor=color
        }
        statusTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(updateStatus), userInfo: nil, repeats: true)
        
        imageObservavle.value.removeAll()
        selectedImage.removeAll()
        selectedTag .removeAll()
        
        var socialName:String
        var imageData:UIImage
        var selectedImageData:UIImage
        
        for index in 0..<8
        {
            
            switch (index) {
            case 0:
                socialName = "facebookShare"
                imageData = UIImage.init(named:"ic_facebook-2")!
                selectedImageData =  UIImage.init(named:"ic_fb_circle")!
            case 1:
                socialName = "instagramShare"
                imageData = UIImage.init(named:"ic_insta-1")!
                selectedImageData =  UIImage.init(named:"ic_insta_circle")!
            case 2:
                socialName = "twitterShare"
                imageData = UIImage.init(named:"ic_Twitter-2")!
                selectedImageData =  UIImage.init(named:"ic_twitter_clirce")!
            case 3:
                socialName = "tumblrShare"
                imageData = UIImage.init(named:"ic_tumbler")!
                selectedImageData =  UIImage.init(named:"ic_tumbler_circle")!
            case 4:
                socialName = "vineShare"
                imageData = UIImage.init(named:"ic_vine-3")!
                selectedImageData =  UIImage.init(named:"ic_vine_circle")!
            case 5:
                socialName = "pinterestShare"
                imageData = UIImage.init(named:"ic_pintrest-1")!
                selectedImageData = UIImage.init(named:"ic_pintrest_circle")!
            case 6:
                socialName = "linkedinShare"
                imageData = UIImage.init(named:"ic_linkedin-1")!
                selectedImageData =  UIImage.init(named:"ic_linkedin_circle")!
            case 7:
                socialName = "youtubeShare"
                imageData = UIImage.init(named:"ic_youtube-1")!
                selectedImageData =  UIImage.init(named:"ic_youtube_circle")!
            default:
                socialName = "Share"
                imageData = UIImage.init(named:"ic_facebook-2")!
                selectedImageData =  UIImage.init(named:"ic_fb_circle")!
            }
            
            
            if(UserDefaults.standard.value(forKey: socialName) != nil)
            {
                let value:String = UserDefaults.standard.value(forKey: socialName) as! String
                if(value != "0")
                {
                    imageObservavle.value.append(imageData)
                    selectedImage.append(selectedImageData)
                    selectedTag.append(index)
                }
            }
            else
            {
                imageObservavle.value.append(imageData)
                selectedImage.append(selectedImageData)
                selectedTag.append(index)
            }

        }
        
       //collView.reloadData()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        statusTimer?.invalidate()
    }
    
    
//MARK: - UI Binding
    func bindingUI(){
        
        
        imageObservavle.asObservable()
            .bindTo(collView.rx.items(cellIdentifier: "socialCell", cellType: SocialCell.self)) { (row, element, cell) in
                
                
                if(row == self.selectedIndex) {
                    cell.socialImage.image = self.selectedImage[row]
                }
                else {
                    cell.socialImage.image = element
                }
                
            }
            .addDisposableTo(disposeBag)
        
        
        collView.rx
            .modelSelected(UIImage.self)
            .subscribe(onNext:  { value in
                if let rowIndex :Int = self.collView.indexPathsForSelectedItems?[0].row {
                    if(self.selectedIndex==rowIndex){ return }
                    let selectedVal:Int = self.selectedTag[rowIndex]
                    self.viewModel?.socialBtnClicked(selectedVal)
                    self.selectedIndex=rowIndex
                    self.collView.reloadData()
                }
            })
            .addDisposableTo(disposeBag)
        
        
        //Creating Pie Chart using Google static chart api
        let url = URL(string: "https://chart.googleapis.com/chart?cht=p&chs=140x140&chd=t:0,0,0,0,0,0,0,0")
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.graphImage.image = UIImage(data: data!)
            }
        }
        
        //Binding buttons
        self.userName.text=(UserDefaults.standard.value(forKey: userDefaultsKey.userName.rawValue) as! String)
        
        
        btnHome.rx.tap.subscribe(onNext: { _ in
            self.viewModel?.homeClicked()
        }).addDisposableTo(disposeBag)
        
        btnTop.rx.tap.subscribe(onNext: { _ in
            self.viewModel?.topClicked()
        }).addDisposableTo(disposeBag)
        
    }
    
    //Update status method
    func updateStatus() {
        viewModel?.updateStatus()
        viewModel?.sendStatus()
    }
}

extension MainVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        let cellCount = CGFloat(imageObservavle.value.count)
        
        if cellCount > 0 {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidth = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing
            let totalCellWidth = cellWidth*cellCount + 5*(cellCount-1)
            let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right
            
            if (totalCellWidth < contentWidth) {
                let padding = (contentWidth - totalCellWidth) / 2.0
                return UIEdgeInsetsMake(0, padding, 0, padding)
            }
        }
        
        return UIEdgeInsets.zero
    }
}
 
