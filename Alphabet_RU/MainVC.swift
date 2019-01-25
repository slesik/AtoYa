//
//  ViewController.swift
//  Alphabet_RU
//
//  Created by Svetlana Lesik on 09/12/2018.
//  Copyright © 2018 Svetlana Lesik. All rights reserved.
//

import UIKit

class MainVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let cellId = "cellId"
    var addToLeftInset: CGFloat = 0.0
    
    func getCellSize() -> CGSize {
        // safeAreaLatoutGuide -> safe space for iPhoneX
        let cellHeight : CGFloat = floor((CGFloat(view.safeAreaLayoutGuide.layoutFrame.size.height) - 8.0) / 7.0)
        // floor is used for eliminate automatic rounded of numbers (otherwise there're an incorrect nombers of cells in line for iPhone 5s & SE
        // st of 5 cells in each line + interspace (8) between cells & borders
        let width: CGFloat = floor(((CGFloat(view.frame.width) - 8.0) / 5.0) - 8.0)
        // adjust of interspaces
        self.addToLeftInset = (CGFloat(view.frame.width) - ((width + 8.0) * 5.0 + 8.0)) * 0.50
        // autoresize of cells
        let height: CGFloat = (cellHeight < 70.0) ? 62.0 : cellHeight - 8.0
        return CGSize(width: width, height: height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // gradient background set
        if collectionView != nil {
            setGradientColor()
        }
        // creation of new collectionview by using of dequeueReusableCell
        collectionView?.register(TabCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    // Hide the VCs' Navigation Bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // Size of collections' cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 33 cells for letters + 1 empty cell (center) + 1 cell for cleanButton
        return 35
    }
    
    // call the detailVC when we tap on a letter
    @objc func switchToController(sender: UITapGestureRecognizer){
        let cell: TabCell = sender.view! as! TabCell
        
        cell.layer.backgroundColor = UIColor.init(cgColor: #colorLiteral(red: 0.7688863277, green: 0.9598543048, blue: 1, alpha: 0.8223458904)).cgColor
        
        let detailVC = DetailVC(index: cell.index)
 
        present(detailVC, animated: true)
        
    }
    
    // Link collection cells with data & set gesture recognaser target
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TabCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TabCell
        var index: Int = 0
        
        //ajust of interspace bug (add +1 to left Edge
        if (indexPath.item == 0) {
            if let collectionViewFlowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                collectionViewFlowLayout.sectionInset.left += self.addToLeftInset
            }
            index = indexPath.item
        } else if (indexPath.item == 30) {
            // creation of empty cell (center of three last cells)
            cell.clearCell()
            return cell
        } else if (indexPath.item > 30) {
            //updage of three last index
            index = indexPath.item - 1
        } else {
            index = indexPath.item
        }
        // put letters in cells & set parameters
        cell.setLabel(index)
        if (index == 33) {
            // set parameters of cleanButton
            setCleanBtn(cell)
        } else {
            // set parameters of cells
            setCells(cell)
        }
        return cell
    }
    
     // set collection cell dimension
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.getCellSize()
    }
    
    //clean selected background of cells
    @objc func cleanButtonTapped() {
        let NbrCell: Int = collectionView!.numberOfItems(inSection: 0) - 1
        //minus one because of last cell which is cleanButton
        for i in 0..<NbrCell {
            let cell: TabCell = collectionView!.cellForItem(at: IndexPath(row: i, section: 0)) as! TabCell
            cell.layer.backgroundColor = UIColor.init(cgColor: #colorLiteral(red: 0.7688863277, green: 0.9598543048, blue: 1, alpha: 0.4512788955)).cgColor
        }
    }
    
    func setGradientColor(){
        let gradientLayer = CAGradientLayer()
        let vw = UIView()
        
        vw.frame = collectionView.frame
        gradientLayer.frame = collectionView.frame
        gradientLayer.colors = [UIColor(rgb: 0xA1D6E2, a: 1.0).cgColor, UIColor(rgb: 0x1995AD, a: 1.0).cgColor]
        vw.layer.insertSublayer(gradientLayer, at: 0)
        collectionView.backgroundView = vw
    }
    
    func setCleanBtn(_ cell: TabCell) {
        let cleanBtn = UITapGestureRecognizer(target: self, action: #selector(cleanButtonTapped))
        cell.addGestureRecognizer(cleanBtn)
        cell.imageView.image = UIImage(named: "Broom")
        
        let imageRatio: CGFloat = cell.imageView.image!.size.height / cell.imageView.image!.size.width
        let imageHeightOffset: CGFloat = (0.25 * self.getCellSize().height) * 0.5
        cell.imageView.translatesAutoresizingMaskIntoConstraints = true
        cell.imageView.frame = CGRect(origin: CGPoint(x: 0.0, y: imageHeightOffset), size: CGSize(width: self.getCellSize().width, height: (self.getCellSize().width * imageRatio)))
        cell.imageView.backgroundColor = UIColor(rgb: 0x136f80, a: 0.01)
        cell.addSubview(cell.imageView)
    }
    
    func setCells(_ cell: TabCell) {
        cell.letterLabel.frame = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: self.getCellSize())
        cell.letterLabel.font = UIFont(name: "Nord-Medium", size: self.getCellSize().height - 30)
        
        // offset manage center of label in cell
        let Offset = (self.getCellSize().height - (cell.letterLabel.frame.size.height * 0.75)) / 2.0
        cell.letterLabel.frame.origin.y += Offset
        cell.letterLabel.frame.size.height -= Offset
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(switchToController))
        cell.addGestureRecognizer(tap)
        
        cell.addSubview(cell.letterLabel)
    }
}


class TabCell: UICollectionViewCell {
    
    let letterLabel = UILabel()
    var index: Int = 0
    let imageView = UIImageView()
    
    func setLabel(_ letter: Int) {
        if (letter < 33) {
            index = letter
            letterLabel.translatesAutoresizingMaskIntoConstraints = true
            letterLabel.text = lettersMin[index]
            letterLabel.textColor = UIColor(rgb: 0x136f80, a: 1.0)
            letterLabel.textAlignment = .center
            letterLabel.numberOfLines = 0
            letterLabel.clipsToBounds = true
            
            self.layer.masksToBounds = true
            self.layer.cornerRadius = 5
            self.layer.backgroundColor = UIColor.init(cgColor: #colorLiteral(red: 0.7688863277, green: 0.9598543048, blue: 1, alpha: 0.4512788955)).cgColor
            self.layer.borderColor = UIColor.init(cgColor: #colorLiteral(red: 0.7688863277, green: 0.9598543048, blue: 1, alpha: 0.1964094606)).cgColor
            self.layer.borderWidth = 3
        }
    }
    
    func clearCell() {
        self.layer.isHidden = true
        self.layer.sublayers = nil
    }

}
