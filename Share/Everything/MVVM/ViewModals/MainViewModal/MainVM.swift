//
//  MainVM.swift
//  Share
//
//  Created by Iqbinder Brar on 20/11/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Moya
import Moya_ModelMapper
class MainVM
{

//MARK: - local Variables
    let disposeBag = DisposeBag()
    let viewControllerIdentifiers = ["facebook","instagram","twitter","tumblr","vine","pinterest"]
    var facebookVC:UIViewController!
    var instagramVC:UIViewController!
    var twitterVC:UIViewController!
    var tumblrVC:UIViewController!
    var vineVC:UIViewController!
    var pinterestVC:UIViewController!
    let MainVCObj:MainVC
    var userTracker: UserTrackerModal!
    var provider: RxMoyaProvider<Share>!
    
//MARK: - Initializing ViewModel
  init(mainVCObj:MainVC) {
    
    MainVCObj = mainVCObj
    
    facebookVC =  (MainVCObj.storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifiers[0]))! as UIViewController
    
    instagramVC =  (MainVCObj.storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifiers[1]))! as UIViewController
    
    twitterVC =  (MainVCObj.storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifiers[2]))! as UIViewController
    
    tumblrVC =  (MainVCObj.storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifiers[3]))! as
        UIViewController
    
    vineVC = (MainVCObj.storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifiers[4]))! as
        UIViewController
    
    pinterestVC = (MainVCObj.storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifiers[5]))! as UIViewController
    
    let endpointClosure = { (target: Share) -> Endpoint<Share> in
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(target)
        let authkey = "bearer " + (UserDefaults.standard.value(forKey: "share_auth_token") as! String)
        return defaultEndpoint.adding(newHttpHeaderFields: ["authorization": authkey])
    }
    
    let providerWithHeader = RxMoyaProvider<Share>(endpointClosure: endpointClosure)
    self.provider = RxMoyaProvider<Share>()
    
    userTracker = UserTrackerModal(provider: self.provider, providerWithHeader:providerWithHeader)
    
    setIndicatorColor(0)
  }
  
//MARK: - Social Button Clicked
    func socialBtnClicked(_ btn:UIButton) {
        changeChildView(btn.tag)
        setIndicatorColor(btn.tag)
    }    
    
//MARK: - Change Child View controller
  func changeChildView(_ tag:Int) {
    var newController:UIViewController!
    
    switch (tag) {
    case 0:
      newController = facebookVC
      break
    case 1:
      newController = instagramVC
      break
    case 2:
      newController = twitterVC
      break
    case 3:
      newController = tumblrVC
      break
    case 4:
      newController = vineVC
      break
    case 5:
      newController = pinterestVC
      break
    default:
      break
    }
    
    let oldController = MainVCObj.childViewControllers.last! as UIViewController
    
    oldController.willMove(toParentViewController: nil)
    MainVCObj.addChildViewController(newController)
    newController.view.frame = oldController.view.frame
    
    MainVCObj.transition(from: oldController, to: newController, duration: 0.25, options: .transitionCrossDissolve, animations:{ () -> Void in
      }, completion: { (finished) -> Void in
        oldController.removeFromParentViewController()
        newController.didMove(toParentViewController: self.MainVCObj)
    })
  }
  
//MARK: - Set Indicator
  func setIndicatorColor(_ tag:Int)
  {
    MainVCObj.indicatorCollection.forEach{
      $0.backgroundColor=UIColor.white
    }
    
    switch tag {
    case 0:
      MainVCObj.indicatorCollection[0].backgroundColor=UIColor.purple
      break
    case 1:
      MainVCObj.indicatorCollection[1].backgroundColor=UIColor.cyan
      break
    case 2:
      MainVCObj.indicatorCollection[2].backgroundColor=UIColor.yellow
      break
    case 3:
      MainVCObj.indicatorCollection[3].backgroundColor=UIColor.green
      break
    case 4:
      MainVCObj.indicatorCollection[4].backgroundColor=UIColor.orange
      break
    case 5:
      MainVCObj.indicatorCollection[5].backgroundColor = UIColor.brown
    default: break
      
    }
  }
    
//MARK: - Updating Graph Status    
    func updateStatus() {
       
        self.userTracker.getStatus()
            .subscribe { event in
                switch event {
                case .next(let userMap):
                    if(userMap?.UstatusCode == 200)
                    {
                        let urlStr:String = "https://chart.googleapis.com/chart?cht=p&chs=211x211&chd=t:\((userMap?.UserData?.facebookTime)!),\((userMap?.UserData?.instagramTime)!),\((userMap?.UserData?.tumblrTime)!),\((userMap?.UserData?.twitterTime)!),\((userMap?.UserData?.pinterestTime)!),\((userMap?.UserData?.vineTime)!)"
                        let url = URL(string:urlStr)
                        
                        DispatchQueue.global().async {
                            let data = try? Data(contentsOf: url!)
                            DispatchQueue.main.async {
                                self.MainVCObj.graphImage.image = UIImage(data: data!)
                            }
                        }
                    }
                    break
                case .error(let error):
                    print("Failed:",error.localizedDescription)
                    self.MainVCObj.presentError(title:"Attention",message:(error.localizedDescription),okText:"OK")
                    break
                default:break
                }
            }.addDisposableTo(self.disposeBag)

    }
}
