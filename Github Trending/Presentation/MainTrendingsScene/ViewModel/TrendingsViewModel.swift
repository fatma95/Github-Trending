//
//  TrendingsViewModel.swift
//  Github Trending
//
//  Created by Fatma Mohamed on 17/01/2022.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire

class TrendingsViewModel {
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    private var isTrendingsHidden = BehaviorRelay<Bool>(value: false)
    
    private var respositoriesSubject = PublishSubject<[Repository]>()
    var repositoriesModelObservable: Observable<[Repository]> {
        return respositoriesSubject
    }

    var isTableviewHiddenObservable: Observable<Bool> {
        return isTrendingsHidden.asObservable()
    }
    
    func getTrendings() {
        loadingBehavior.accept(true)
        APIService.instance.getData(url:"https://gh-trending-api.herokuapp.com/repositories", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, completion: { [weak self] (repositoriesResponse: [Repository]?, error) in
            guard let self = self else { return }
            if let error = error {
                self.isTrendingsHidden.accept(true)
                print(error.localizedDescription)
            } else {
                guard let trendingsModel = repositoriesResponse else {
                    return
                }
                if trendingsModel.count > 0 {
                    self.respositoriesSubject.onNext(trendingsModel)
                    self.isTrendingsHidden.accept(false)
                } else {
                    self.isTrendingsHidden.accept(true)
                }
            }
        })
    }    
}
