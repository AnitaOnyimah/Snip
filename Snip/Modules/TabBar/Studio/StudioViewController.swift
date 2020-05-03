//
//  StudioViewController.swift
//  Snap
//
//  Created by Amitabha Saha on 01/05/20.
//  Copyright © 2020 Amitabha. All rights reserved.
//

import UIKit
import SwiftyDraw
import Kingfisher

class StudioViewController: BaseViewController {
    
    var images: [(String, String)] = [(String, String)]()
    private var colorPicker: ColorPickerView?
    
    var lineWidth: CGFloat = 3.0 {
        didSet {
            drawView.brush.width = lineWidth
        }
    }
    
    var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var studioView: UIView!
    @IBOutlet weak var drawView: SwiftyDrawView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        reloadCollectionView()
        studioView.isHidden = true
        
        saveButton = UIBarButtonItem.init(title: "Save", style: .done, target: self, action: #selector(saveAction))
    }
    
    @objc func saveAction() {
        
        self.showSpinner()
        self.drawView.backgroundColor = .white
        guard let drawnimage = imageWithView(view: self.drawView) else { return }
        self.drawView.backgroundColor = .clear
        
        TextAlertView.showAlert(on: self, title: "Enter project title here", placeHolder: "Type your project title here") { (val) in
            if let val = val {
                print(val)
                
                FirebaseHelper.setDataInStudio(for: val, image: drawnimage) { (success) in
                    if success {
                        self.hideSpinner()
                        self.drawView.clear()
                        self.showError(message: "Your project has been saved successfully.")
                    } else {
                        self.hideSpinner()
                        self.showError(message: "Failed to save your project. Please Try again.")
                    }
                }
            } else {
                self.hideSpinner()
            }
        }
    }
    
    func imageWithView(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    func reloadCollectionView() {
        
        configureCollectionView()
        fetchStudioData()
    }
    
    func fetchStudioData() {
        
        self.showSpinner()
        
        if let path = FirebaseHelper.getBasePath(for: "studio") {
            path.observeSingleEvent(of: .value) { (snap) in
                
                self.hideSpinner()
                self.images.removeAll()
                
                if let postDict = snap.value as? [String : String] {
                    self.images = postDict.map { (($0, $1)) }
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        } else {
            self.hideSpinner()
        }
    }
    
    func configureCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ProjectCollectionViewCell.self, forCellWithReuseIdentifier: "ProjectCollectionViewCell")
        collectionView.register(UINib(nibName: "ProjectCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProjectCollectionViewCell")
        
        let width = (UIScreen.main.bounds.size.width-23)/3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: width, height: width)
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 2
        flowLayout.minimumLineSpacing = 2
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        
    }
    
    @IBAction func segmentControlActio(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            showCreations()
        } else {
            showStudio()
        }
    }
    
    @IBAction func colorWheelSelected(_ sender: UIButton) {
        
        let blockView = UIView.init(frame: self.view.bounds)
        blockView.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        self.view.addSubview(blockView)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        colorPicker = ColorPickerView(frame: CGRect(x: 30, y: (UIScreen.main.bounds.size.height - UIScreen.main.bounds.size.width +  60)/2, width: UIScreen.main.bounds.size.width - 60, height: UIScreen.main.bounds.size.width - 30))
        colorPicker?.didSelectColor = {
            color in
            self.drawView.brush.color = Color(color)
        }
        
        colorPicker?.didClose = {
            blockView.removeFromSuperview()
            self.colorPicker?.removeFromSuperview()
            self.colorPicker = nil
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        self.view.addSubview(colorPicker!)
    
    }
    
    @IBAction func pencilSelected(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showLineSize", sender: nil)
    }
    
    @IBAction func eraserSelected(_ sender: UIButton) {
        drawView.clear()
    }
    
    func showStudio() {
        studioView.isHidden = false
        collectionView.isHidden = true
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    func showCreations() {
        
        studioView.isHidden = true
        collectionView.isHidden = false
        collectionView.reloadData()
        self.navigationItem.rightBarButtonItem = nil
        
        fetchStudioData()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showLineSize"{
            let popOver: LineWidthViewController = segue.destination  as! LineWidthViewController
            
            popOver.modalPresentationStyle = .currentContext
            popOver.presentationController?.delegate = self
            popOver.preferredContentSize = CGSize(width: 60, height: 153)
            
            popOver.setValue(self.lineWidth)
            
            popOver.valueChanged = {
                (value: CGFloat) -> () in
                
                self.lineWidth = value
            }
        }
    }
}

extension StudioViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // return UIModalPresentationStyle.FullScreen
        return UIModalPresentationStyle.none
    }
}


extension StudioViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell: ProjectCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectCollectionViewCell", for: indexPath) as? ProjectCollectionViewCell {
            fetchImageFrom(url: images[indexPath.row].1, imageView: cell.itemIMageView)
            cell.itemTitle.text = images[indexPath.row].0
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func fetchImageFrom(url: String, imageView: UIImageView) {
        
        guard let url = URL(string: url) else {
            return
        }
        
        let processor = DownsamplingImageProcessor(size: imageView.frame.size)
            |> RoundCornerImageProcessor(cornerRadius: 20)
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholer"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
                case .success(let value):
                    imageView.image = value.image
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
            }
        }
    }
}

 
