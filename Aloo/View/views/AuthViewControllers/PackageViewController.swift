//
//  BunchViewController.swift
//  Aloo
//
//  Created by Dev. Hany Alkahlout on 01/12/2021.
//

import UIKit

class PackageViewController: UIViewController {

    @IBOutlet weak var packagesCollectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    private let presnter = PackagePresnter()
    private var data = [Packages]()
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        // Do any additional setup after loading the view.
    }
    
    
    private func initlization(){
        presnter.delegate = self
        setUpCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if L102Language.currentAppleLanguage() == "ar"{
            pageControl.transform = .init(rotationAngle: .pi)
        }
        presnter.getPackages()
    }

    
    @IBAction func skipAction(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func requestPackageAction(_ sender: Any) {
    }
    
    
    
}

extension PackageViewController: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    private func setUpCollectionView(){
        packagesCollectionView.contentInsetAdjustmentBehavior = .never
        packagesCollectionView.delegate = self
        packagesCollectionView.dataSource = self
        
        packagesCollectionView.register(.init(nibName: "PackageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PackageCollectionViewCell")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PackageCollectionViewCell", for: indexPath) as! PackageCollectionViewCell
        cell.delegate = self
        cell.setData(data: data[indexPath.row])
        return cell
    }
    
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: packagesCollectionView.bounds.width, height: packagesCollectionView.bounds.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = CGFloat(scrollView.contentOffset.x/view.frame.width).rounded()
        pageControl.currentPage = Int(currentPage)
    }
    
}

extension PackageViewController: PackagePresnterDelegate,PackageCollectionViewCellDelegate{
    func showCustomAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(.init(title: "Ok", style: .cancel, handler: { action in
            self.navigationController?.dismiss(animated: true, completion: nil)
        }))
        present(alertVC, animated: true, completion: nil)
    }
    
    func setPackages(data: PackageData) {
        self.data = data.packages ?? []
        packagesCollectionView.reloadData()
        pageControl.numberOfPages = self.data.count
    }
    
    func showAlert(title: String, message: String) {
        GeneralActions.shard.showAlert(viewController: self, title: title, message: message)
    }
    
}
