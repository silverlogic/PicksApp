//
//  UICollectionView+Extension.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/30/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

// MARK: - ResuableView
extension UICollectionViewCell: ResuableView {}


// MARK: - UICollectionView Registration
extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) where T: ResuableView {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UICollectionViewCell>(_: T.Type) where T: ResuableView, T: NibLoadableView {
        register(T.nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
}


// MARK: - UICollectionView Dequeue
extension UICollectionView {
    func dequeueCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ResuableView {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could Not Dequeue Cell With Identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}
