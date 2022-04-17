//
//  TabPagerHeaderCell.swift
//  Basic
//
//  Created by pineone on 2021/12/16.
//

//import BonMot
import Reusable
import SnapKit
import Then
import UIKit

class TabPagerHeaderCell: UICollectionViewCell, Reusable {
    static let identifier = String(describing: TabPagerHeaderCell.self)

    var displayNewIcon: Bool?

    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }

    // MARK: View
    lazy var title = UILabel().then {
        $0.font = selectedFont
        $0.textColor = selectedColor
        $0.textAlignment = .center
    }

    var selectedFont: UIFont = TabPagerHeaderDefault.selectedFont
    var deSelectedFont: UIFont = TabPagerHeaderDefault.deSelectedFont

    var selectedColor: UIColor = TabPagerHeaderDefault.selectedColor
    var deSelectedColor: UIColor = TabPagerHeaderDefault.deSelectedColor

    var selectedImage: UIImage?
    var deSelectedImage: UIImage?

    override var isSelected: Bool {
        didSet {
            self.title.font = isSelected ? selectedFont : deSelectedFont
//            self.indicatorView.isHidden = !isSelected
            self.title.textColor = isSelected ? selectedColor : deSelectedColor
            if selectedImage != nil && deSelectedImage != nil {
                self.iconView.image = isSelected ? selectedImage : deSelectedImage
            }
            if isSelected {
                displayNewIcon = false
                newBadgeIcon.isHidden = true
            }
        }
    }

    lazy var indicatorView = UIView().then {
        $0.isHidden = true
        $0.layer.cornerRadius = 1.5
    }

    lazy var newBadgeIcon = UIView().then {
        $0.cornerRadius = 3.5
        $0.isHidden = true
    }

    lazy var iconView = UIImageView()

    func setupLayout() {
//        self.addSubview(title)
//        self.addSubview(indicatorView)
//        self.addSubview(newBadgeIcon)

        isSelected = false
    }

    func cellClear() {
        subviews.forEach { $0.removeFromSuperview() }
        self.selectedImage = nil
        self.deSelectedImage = nil
    }

    func cellset(_ data: TabPagerHeaderCellModel?) {
        cellClear()
        self.title.attributedText = data?.title.styling(.letterSpace(-0.4))

        self.indicatorView.backgroundColor = data?.indicatorColor ?? TabPagerHeaderDefault.indicatorColor

        self.selectedFont = data?.selectedFont ?? TabPagerHeaderDefault.selectedFont
        self.deSelectedFont = data?.deSelectedFont ?? TabPagerHeaderDefault.deSelectedFont

        self.selectedColor = data?.titleSelectedColor ?? TabPagerHeaderDefault.selectedColor
        self.deSelectedColor = data?.titleDeSelectedColor ?? TabPagerHeaderDefault.deSelectedColor

        guard let string = data?.title else { return }
        let width = string.widthOfString(usingFont: TabPagerHeaderDefault.selectedFont)

        if let deSelectImage = data?.iconImage, let selectImage = data?.iconSelectedImage {
            selectedImage = selectImage
            deSelectedImage = deSelectImage
            iconView.image = deSelectedImage

            addSubview(iconView)
            iconView.snp.remakeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(6)
                $0.trailing.equalToSuperview().offset(-6)
            }
        } else {
            addSubviews([title, indicatorView, newBadgeIcon])
            title.snp.remakeConstraints {
                $0.center.equalToSuperview()
//                $0.height.equalTo(56 - TabPagerHeaderDefault.indicatorHeight)
//                $0.top.equalToSuperview()
                $0.width.equalTo(width)
            }

            indicatorView.snp.remakeConstraints {
                $0.bottom.equalToSuperview()
                //$0.leading.equalTo(title.snp.leading).offset(-10)
                //$0.trailing.equalTo(title.snp.trailing).offset(10)
                $0.leading.equalToSuperview()//.offset(5).priority(.medium)
                $0.trailing.equalToSuperview()//.offset(-5).priority(.medium)
                $0.height.equalTo(TabPagerHeaderDefault.indicatorHeight)
//                $0.top.equalTo(title.snp.bottom).priority(.medium)
            }

            newBadgeIcon.snp.remakeConstraints {
//                $0.width.height.equalTo(7)
//                $0.left.equalTo(title.snp.right)
//                $0.bottom.equalTo(title.snp.top).offset(20)
                $0.width.height.equalTo(7)
                $0.top.equalToSuperview().offset(14)
                $0.trailing.equalToSuperview().offset(3)
            }

            if displayNewIcon == nil {
                displayNewIcon = data?.displayNewIcon ?? false
            }
            newBadgeIcon.isHidden = !(displayNewIcon!)

            layoutSubviews()

            self.title.font = isSelected ? selectedFont : deSelectedFont
//            self.indicatorView.isHidden = !isSelected
            self.title.textColor = isSelected ? selectedColor : deSelectedColor
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        newBadgeIcon.addGradient(colors: [ #colorLiteral(red: 0.9607843137, green: 0.4352941176, blue: 0.5764705882, alpha: 1).cgColor,  #colorLiteral(red: 0.9098039216, green: 0.2352941176, blue: 0.3529411765, alpha: 1).cgColor])
    }
}

