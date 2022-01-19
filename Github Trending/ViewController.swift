//
//  ViewController.swift
//  Github Trending
//
//  Created by Fatma Mohamed on 16/01/2022.
//

import UIKit
import RxSwift
import RxCocoa
import SkeletonView
import DropDown

class ViewController: UIViewController {
  

    @IBOutlet weak var trendingsTableView: UITableView!
    @IBOutlet weak var trendingsContainerView: UIView!
    
    //MARK: Constants
    let trendingsCell = "TrendingsTableViewCell"
    let trendingsViewModel = TrendingsViewModel()
    let disposeBag = DisposeBag()
    let reachability = Reachability()
    private let refreshControl = UIRefreshControl()
    let rightBarDropDown = DropDown()
    
        
    //MARK: Variables
    var selectedIndex : IndexPath?//Delecre this global
    var indexPaths: [IndexPath] = []
    var repositories: [Repository]?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(refreshTrendings), for: .valueChanged)
        self.title = "Trending"
        setupTableView()
        subcribeToResponse()
        self.getTrendings()
        subscribeOnTableState()
        setNavBar()
    }
    
    
    
    fileprivate func setNavBar() {
        let button1 = UIBarButtonItem(image: UIImage(named: "more-black-24"), style: .plain, target: self, action: #selector(moreSettings))
        self.navigationItem.rightBarButtonItem = button1
        rightBarDropDown.anchorView = button1
        rightBarDropDown.dataSource = ["Sort by stars", "Sort by name"]
        rightBarDropDown.cellConfiguration = { (index, item) in return "\(item)" }
    }
    
    
    fileprivate func setupTableView() {
        if #available(iOS 10.0, *) {
        trendingsTableView.refreshControl = refreshControl
    } else {
        trendingsTableView.addSubview(refreshControl)
    }
        trendingsTableView.register(UINib(nibName: trendingsCell, bundle: nil), forCellReuseIdentifier: trendingsCell)
    }

    @objc func refreshTrendings() {
        self.getTrendings()
        self.refreshControl.endRefreshing()
    }
 
    @objc func moreSettings() {
            rightBarDropDown.selectionAction = { (index: Int, item: String) in
                switch index {
                case 0:
                    self.repositories?.sort(by: {
                        $0.totalStars < $1.totalStars
                    })
                    self.trendingsTableView.reloadData()
                default:
                    self.repositories?.sort(by: {
                        $0.repositoryName < $1.repositoryName
                    })
                    self.trendingsTableView.reloadData()
                }
               print("Selected item: \(item) at index: \(index)")
                
            }

             rightBarDropDown.width = 140
             rightBarDropDown.bottomOffset = CGPoint(x: 0, y:(rightBarDropDown.anchorView?.plainView.bounds.height)!)
             rightBarDropDown.show()
          }
    
    
    
    private func subscribeOnTableState() {
        self.trendingsViewModel.isTableviewHiddenObservable.bind(to: self.trendingsContainerView.rx.isHidden).disposed(by: disposeBag)
    }
    
        private func subcribeToResponse() {
            self.trendingsViewModel.repositoriesModelObservable.subscribe(onNext: { [weak self] repos in
                self?.repositories = repos
                self?.trendingsTableView.reloadData()
            }).disposed(by: disposeBag)
        }
        
    
    private func getTrendings() {
        trendingsViewModel.getTrendings()
    }
   
    
}

extension ViewController: UITableViewDelegate, SkeletonTableViewDataSource {
    
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return trendingsCell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories?.count ?? 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: trendingsCell, for: indexPath) as! TrendingsTableViewCell
        if let repos = self.repositories {
            cell.hideAnimation()
            cell.configure(trending: repos[indexPath.row])
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        if !self.indexPaths.contains(selectedIndex!) {
            indexPaths += [selectedIndex!]
        } else {
            let index = indexPaths.firstIndex(of: selectedIndex!)
            indexPaths.remove(at: index!)
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPaths.count > 0 {
               if indexPaths.contains(indexPath){
                   return 170
               }
               else {
                   return 80
               }
           }
             return 80
    }
 
}
