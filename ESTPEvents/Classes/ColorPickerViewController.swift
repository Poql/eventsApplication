//
//  ColorPickerViewController.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 20/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
    static let collectionViewsPadding: UIEdgeInsets = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
    static let detailCollectioViewItemSpacing: CGFloat = 8
    static let collectionViewItemSpacing: CGFloat = 0
    static let collectionViewItemHeight: CGFloat = 44
    static let detailCollectionViewItemHeight: CGFloat = 40
}

protocol ColorPickerViewControllerDelegate: class {
    func controller(controller: ColorPickerViewController, didPickColor color: Color)
}

class ColorPickerViewController: SharedViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    @IBOutlet private var colorsCollectionView: UICollectionView!
    @IBOutlet private var colorDetailsCollectionView: UICollectionView!

    private var currentSelectedColor: PickableColor = .red
    private var colors = PickableColor.possibleColors

    weak var delegate: ColorPickerViewControllerDelegate?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "color_picker_title".localized
        setupCollectionViews()
    }

    private func setupCollectionViews() {
        colorsCollectionView.delegate = self
        colorsCollectionView.dataSource = self
        colorDetailsCollectionView.delegate = self
        colorDetailsCollectionView.dataSource = self
        colorsCollectionView.registerView(RegistrableView<ColorTypePickerCollectionViewCell>.fromClass)
        colorDetailsCollectionView.registerView(RegistrableView<ColorPickerCollectionViewCell>.fromClass)
        colorsCollectionView.alwaysBounceVertical = true
        colorDetailsCollectionView.alwaysBounceVertical = true
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView == colorsCollectionView {
            let color = colors[indexPath.row]
            let cell: ColorTypePickerCollectionViewCell = collectionView.dequeueCell(forIndexPath: indexPath)
            cell.configure(color: color, selected: color == currentSelectedColor)
            return cell
        }
        let color = currentSelectedColor.declinaisons[indexPath.row]
        let cell: ColorPickerCollectionViewCell = collectionView.dequeueCell(forIndexPath: indexPath)
        cell.configure(color: color)
        return cell
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == colorsCollectionView {
            return PickableColor.count
        }
        return currentSelectedColor.declinaisons.count
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return Constant.collectionViewsPadding
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        if collectionView == colorsCollectionView {
            return Constant.collectionViewItemSpacing
        }
        return Constant.detailCollectioViewItemSpacing
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let extra = Constant.collectionViewsPadding.left + Constant.collectionViewsPadding.right
        let height: CGFloat
        if collectionView == colorDetailsCollectionView {
            height = Constant.detailCollectionViewItemHeight
        } else {
            height = Constant.collectionViewItemHeight
        }
        return CGSize(width: collectionView.frame.width - extra, height: height)
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == colorsCollectionView {
            currentSelectedColor = colors[indexPath.row]
            colorDetailsCollectionView.reloadData()
            colorDetailsCollectionView.contentOffset = CGPointZero
            colorsCollectionView.reloadData()
            return
        }
        let color = currentSelectedColor.declinaisons[indexPath.row]
        delegate?.controller(self, didPickColor: color)
    }
}
