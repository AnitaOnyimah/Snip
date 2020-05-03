//
//  ProfileViewController.swift
//  Snap
//
//  Created by Amitabha Saha on 01/05/20.
//  Copyright © 2020 Amitabha. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Kingfisher
import Hashtags

class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var centerConstarintSelectTab: NSLayoutConstraint!
    @IBOutlet weak var greenPointLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var sellView: UIView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var hashTagView: HashtagView!
    @IBOutlet weak var hashtagTextField: PaddedTextField!
    @IBOutlet weak var pricetextField: PaddedTextField!
    
    
    var selecctedIndex = -1
    var mainDataSource: [[String: Any]]?
    var isSaleEnabled = false
    
    var dataSource: [[String: Any]]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let images = [UIImage(named: "girl1.jpg"), UIImage(named: "girl2.jpeg"), UIImage(named: "girl3.jpeg"), UIImage(named: "girl4.jpg"), UIImage(named: "girl5.jpeg"), UIImage(named: "man1.jpg"), UIImage(named: "pants.jpg"),UIImage(named: "girl1.jpg"), UIImage(named: "girl2.jpeg"), UIImage(named: "girl3.jpeg"), UIImage(named: "girl4.jpg"), UIImage(named: "girl5.jpeg"), UIImage(named: "man1.jpg"), UIImage(named: "pants.jpg")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.sellView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    
    func fetchProfileData() {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        userName.text = currentUser.displayName
        
        if let url = currentUser.photoURL {
            
            let processor = DownsamplingImageProcessor(size: imageView.frame.size)
            
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "person.crop.circle"),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .cacheOriginalImage
                ])
            {
                result in
                switch result {
                    case .success(let value):
                        self.imageView.image = value.image
                        self.imageView.layer.cornerRadius = 48.0
                        self.imageView.layer.borderColor = UIColor(named: "color1")?.cgColor
                        self.imageView.layer.borderWidth = 3
                        self.imageView.layer.masksToBounds = true
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                }
            }
        } else {
            self.imageView.image = UIImage(systemName: "person.crop.circle")
        }
        
        FirebaseHelper.getBasePath(for: "post")?.observeSingleEvent(of: .value, with: { (snap) in
            if let values = snap.value as? [String:Any] {
                
                var allPosts = values.map { (key, value) -> [String: Any] in
                    
                    var dic = value as! [String: Any]
                    dic["key"] = key
                    return dic
                    
                }
                
                allPosts.sort { (first, second) -> Bool in
                    if let fkey = first["key"] as? String, let lkey = second["key"] as? String {
                        return fkey > lkey
                    } else {
                        return false
                    }
                }
                
                self.mainDataSource = allPosts
                self.dataSource = allPosts
                
                self.greenPointLabel.text = "\(Array(values.keys).count) green points"
                self.collectionView.reloadData()
            } else {
                self.greenPointLabel.text = "0 green points"
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        fetchProfileData()
        centerConstarintSelectTab.constant = -80.0
    }
    
    @IBAction func diyAction(_ sender: Any) {
        self.menuButton.isHidden = false
        centerConstarintSelectTab.constant = -80.0
        
        self.dataSource = self.mainDataSource
    }
    
    @IBAction func storeAction(_ sender: Any) {
        
        self.menuButton.isHidden = true
        centerConstarintSelectTab.constant = 80.0
        
        let saleable = self.mainDataSource?.filter({ (item) -> Bool in
            if let forSale = item["forSale"] as? Bool, forSale {
                return true
            } else {
                return false
            }
        })
        
        self.dataSource = saleable
    }
    
    @IBAction func menuAction(_ sender: Any) {
        showSimpleActionSheet()
    }
    
    @IBAction func profilePhotoAction(_ sender: Any) {
        
        let alert = UIAlertController.init(title: "", message: "Choose your option", preferredStyle: .actionSheet)
        
        let camera = UIAlertAction.init(title: "Capture From Camera", style: UIAlertAction.Style.default) { (action) in
            
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
            
        }
        
        let library = UIAlertAction.init(title: "Choose From Library", style: UIAlertAction.Style.default) { (action) in
            
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
            
        }
        
        alert.addAction(camera)
        alert.addAction(library)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSimpleActionSheet() {
        
        let alert = UIAlertController(title: "Settings", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Sell", style: .default, handler: { (_) in
            self.showError(message: "Select Any of your DIYs that want to sell")
            self.isSaleEnabled = true
        }))
        
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (_) in
            print("User click Delete button")
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    func reloadCollectionView() {
        
        configureCollectionView()
        collectionView.reloadData()
    }
    
    func configureCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(DIYCollectionViewCell.self, forCellWithReuseIdentifier: "DIYCollectionViewCell")
        collectionView.register(UINib(nibName: "DIYCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DIYCollectionViewCell")
        
        let width = (UIScreen.main.bounds.size.width-76)/2
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: width, height: width)
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 25
        flowLayout.minimumLineSpacing = 25
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        
    }
    
    func showSellView(with image: UIImage, row: Int) {
        
        self.sellView.isHidden = false
        postImage.image = image
        self.selecctedIndex = row
        
        if let dataSource = dataSource, let tagsA = dataSource[row]["tags"] as? [String] {
            
            let tags = tagsA.map { (tag) -> HashTag in
                return HashTag(word: tag, withHashSymbol: false, isRemovable: false)
            }
            hashTagView.addTags(tags: tags)
        }
    }
    
    @IBAction func addAction(_ sender: Any) {
        
        if let text = hashtagTextField.text, !text.isEmpty {
            let tag = HashTag(word: text, withHashSymbol: true, isRemovable: false)
            hashTagView.addTag(tag: tag)
            hashtagTextField.text = ""
        }
    }
    
    @IBAction func postAction(_ sender: Any) {
        
        if self.selecctedIndex > -1 {
            
            guard let dataSource = dataSource else { return }
            
            let model = dataSource[selecctedIndex]
            
            let tags = hashTagView.hashtags.map{ $0.text }
            let price = pricetextField.text ?? ""
            
            
            if let key = model["key"] as? String,
                let postPath = FirebaseHelper.getBasePath(for: "post") {
                
                let postPath = postPath.child(key)
                
                postPath.child("forSale").setValue(true)
                postPath.child("tags").setValue(tags)
                postPath.child("price").setValue(price)
                
            }
            
            self.sellView.isHidden = true
            self.isSaleEnabled = false
            self.menuButton.isEnabled = true
            
            
            self.selecctedIndex = -1
            fetchProfileData()
        }
    }
    
    @IBAction func postCancelAction(_ sender: Any) {
        self.isSaleEnabled = false
        self.sellView.isHidden = true
        self.menuButton.isEnabled = true
        self.selecctedIndex = -1
    }
    
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell: DIYCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DIYCollectionViewCell", for: indexPath) as? DIYCollectionViewCell {
            cell.backgroundColor = .lightGray
            
            if let afterPhoto = dataSource?[indexPath.row]["afterPhoto"] as? String, let imgurl = URL(string: afterPhoto) {
                cell.itemIMageView.kf.setImage(with: imgurl)
            } else {
                cell.itemIMageView.image = #imageLiteral(resourceName: "placeholer")
            }
            
            if self.menuButton.isHidden, let forSale = dataSource?[indexPath.row]["forSale"] as? Bool, forSale, let price = dataSource?[indexPath.row]["price"] as? String {
                cell.priceLabel.text = price
                cell.priceLabel.isHidden = false
            } else {
                cell.priceLabel.isHidden = true
            }
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.isSaleEnabled {
            if let cell: DIYCollectionViewCell = collectionView.cellForItem(at: indexPath) as? DIYCollectionViewCell {
                showSellView(with: cell.itemIMageView.image!, row: indexPath.row)
                menuButton.isEnabled = false
            }
        }
    }
    
    func fetchImageFrom(url: String, imageView: UIImageView) {
        
        guard let url = URL(string: url) else {
            return
        }
        
        let processor = DownsamplingImageProcessor(size: imageView.frame.size)
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholer"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
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


extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: {
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                
                self.imageView.image = pickedImage
                
                self.imageView.layer.cornerRadius = 48.0
                self.imageView.layer.borderColor = UIColor(named: "color1")?.cgColor
                self.imageView.layer.borderWidth = 3
                self.imageView.layer.masksToBounds = true
                
                FirebaseHelper.uploadUserProfile(image: pickedImage) { (url) in
                    
                    let userun = Auth.auth().currentUser!
                    
                    let changeRequest = userun.createProfileChangeRequest()
                    changeRequest.photoURL = url
                    changeRequest.commitChanges { (error) in
                        
                    }
                }
            }
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


extension UIImage {
    func autofixImageOrientation() -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        self.draw(at: .zero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
}
