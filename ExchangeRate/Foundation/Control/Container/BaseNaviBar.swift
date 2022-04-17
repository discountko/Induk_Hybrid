//
//  BaseNaviBar.swift
//  Basic
//
//  Created by pineone on 2021/09/02.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit
import NSObject_Rx

enum BaseNavigationActionType {
    case search
    case back
    case imageAugment
    case setting
    case more
    case delete
    case inspect
    case dismiss
}

enum BaseNavigationShowType {
    /// 없음
    case none
    /// 홈
    case home
    /// 기본 왼쪽 back
    case backTitle
    /// 기본 왼쪽 back 가운데 title
    case backCenterTitle
    /// 기본 왼쪽 back 가운데 title button
    case setting
    /// 왼쪽 back 우측 count
    case backTitleRightCount
    /// 왼쪽 back 우측 Setting
    case backTitleRightSetting
    /// 왼쪽 back 우측 More
    case backTitleRightMore
    /// 센터 title 우측 X
    // case conterTitleRightCancle
    /// 중간 title
    case centerTitle
    /// 중간 title, bottom line 없음
    case onlyCenterTitle
    /// 중앙 숫자 오른쪽 X
    case centerConutRightX
    /// 오른쪽 X
    case onlyRightX
    /// 왼쪽 back 가운데 title 우측 Delete
    case backTitleRightDelete
}


private let screenWidth = UIScreen.main.bounds.size.width

class BaseNavigationBar: UIView {
    var type: BaseNavigationShowType = .none
    let navigationAction = PublishRelay<BaseNavigationActionType>()

    lazy var containerView = UIView().then {
        $0.backgroundColor = .clear
    }

    var title: String? {
        willSet {
            titleLabel.isHidden = false
            titleLabel.text = newValue
        }
    }
    
    var titleButtonString: String? {
        willSet {
            titleButton.isHidden = false
            titleButton.setTitle(newValue, for: .normal)
        }
    }

    lazy var homeLogoImageView: UIView = {
        return UIImageView().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
//            $0.image = #imageLiteral(resourceName: "imgLogoNor")
            $0.isHidden = true
        }
    }()

    lazy var backButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(R.Image.Navi.btnCommonBefore, for: .normal)
        $0.isHidden = true
        $0.rx.tap.map { BaseNavigationActionType.back }.bind(to: self.navigationAction).disposed(by: rx.disposeBag)
    }

    lazy var titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .notoSans(.medium, size: 20)
        $0.textColor = .black
        $0.isHidden = true
    }
    
    lazy var titleButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.titleLabel?.font = .notoSans(.medium, size: 20)
        $0.setTitleColor(.black, for: .normal)
        $0.isHidden = true
        $0.rx.tap.map { BaseNavigationActionType.inspect }.bind(to: self.navigationAction).disposed(by: rx.disposeBag)
    }

    lazy var searchButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(#imageLiteral(resourceName: "icTabbarSearchNor"), for: .normal)
        $0.setImage(#imageLiteral(resourceName: "icTabbarSearchPre"), for: .highlighted)
        $0.isHidden = true
        $0.rx.tap.map { BaseNavigationActionType.search }.bind(to: self.navigationAction).disposed(by: rx.disposeBag)
    }

    lazy var imageAugmentationButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
//        $0.setImage(#imageLiteral(resourceName: "icTopScanNor"), for: .normal)
//        $0.setImage(#imageLiteral(resourceName: "icTopScanPre"), for: .highlighted)
        $0.isHidden = true
        $0.rx.tap.map { BaseNavigationActionType.imageAugment }.bind(to: self.navigationAction).disposed(by: rx.disposeBag)
    }

    lazy var countLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isHidden = true
    }

    lazy var bottomLine = UIView().then {
//        $0.backgroundColor = R.Color.default ~ 10%
        $0.isHidden = true
    }

    lazy var closeButton = UIButton().then {
        $0.isHidden = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(R.Image.Navi.btnClose, for: .normal)
        $0.contentMode = .scaleAspectFill
        $0.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1.2)
        $0.rx.tap.map { BaseNavigationActionType.dismiss }.bind(to: self.navigationAction).disposed(by: rx.disposeBag)
    }
    
    lazy var settingButton = UIButton().then {
        $0.isHidden = true
        $0.setImage(R.Image.Navi.btnCommonSettingsNor, for: .normal)
        $0.rx.tap.map { BaseNavigationActionType.setting }.bind(to: self.navigationAction).disposed(by: rx.disposeBag)
    }
    
    lazy var moreButton = UIButton().then {
        $0.isHidden = true
        $0.setImage(R.Image.Navi.btnCommonMoreNor, for: .normal)
        $0.rx.tap.map { BaseNavigationActionType.more }.bind(to: self.navigationAction).disposed(by: rx.disposeBag)
    }
    
    lazy var deleteButton = UIButton().then {
        $0.isHidden = true
        $0.setImage(R.Image.Navi.delNor, for: .normal)
        $0.rx.tap
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .map { .delete }.bind(to: navigationAction).disposed(by: rx.disposeBag)
    }

    lazy var navBarHeight: CGFloat = naviBarHeight()

    private func naviBarHeight() -> CGFloat {
        guard self.type != .home else { return 56 }
        return 56 //+ realSafeAreaInsetTop
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(type: BaseNavigationShowType = .none) {
        self.type = type
        super.init(frame: .zero)
        setupView()
    }

    func setupView() {
        backgroundColor = R.Color.white_1000
        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(56+UIDevice.topSafeArea)
            $0.top.equalToSafeAreaAuto(self)
        }

        containerView.addSubviews([homeLogoImageView, backButton, titleLabel, titleButton, searchButton, imageAugmentationButton, countLabel, bottomLine, closeButton, settingButton, moreButton, deleteButton])

        homeLogoImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(22)
            $0.leading.equalToSuperview().offset(24)
        }

        searchButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(42)
            $0.leading.equalToSuperview().offset(15)
        }

        imageAugmentationButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(42)
            $0.trailing.equalToSuperview().offset(-16)
        }

        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(42)
            $0.leading.equalToSuperview().offset(15)
        }

        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(backButton.snp.trailing)
        }
        
        titleButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(backButton.snp.trailing)
        }

        bottomLine.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }

        closeButton.snp.makeConstraints {
            $0.width.height.equalTo(42)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        settingButton.snp.makeConstraints {
            $0.width.height.equalTo(42)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        moreButton.snp.makeConstraints {
            $0.width.height.equalTo(42)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        deleteButton.snp.makeConstraints {
            $0.width.height.equalTo(42)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }

        countLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(22)
            $0.width.equalTo(100)
        }

        switch type {
        case .home:
            [homeLogoImageView, searchButton, imageAugmentationButton].forEach { $0.isHidden = false }
        case .backTitle:
            [backButton, titleLabel].forEach { $0.isHidden = false }
        case .backCenterTitle:
            [backButton, titleLabel].forEach { $0.isHidden = false }
            titleLabel.snp.remakeConstraints {
                $0.center.equalToSuperview()
            }
        case .setting:
            [backButton, titleButton].forEach { $0.isHidden = false }
            titleButton.snp.remakeConstraints {
                $0.center.equalToSuperview()
            }
        case .backTitleRightCount:
            [backButton, titleLabel, countLabel].forEach { $0.isHidden = false }
            titleLabel.snp.remakeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(backButton.snp.trailing)
                $0.trailing.equalTo(countLabel.snp.leading)
            }
        case .backTitleRightSetting:
            [backButton, titleLabel, settingButton].forEach { $0.isHidden = false }
            titleLabel.snp.remakeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(backButton.snp.trailing)
                $0.trailing.equalTo(settingButton.snp.leading)
            }
        case .backTitleRightMore:
            [backButton, titleLabel, moreButton].forEach { $0.isHidden = false }
            titleLabel.snp.remakeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(backButton.snp.trailing)
                $0.trailing.equalTo(moreButton.snp.leading)
            }
            
        case .centerTitle:
            [titleLabel, bottomLine].forEach { $0.isHidden = false }
            titleLabel.snp.remakeConstraints {
                $0.center.equalToSuperview()
            }
        case .onlyCenterTitle:
            titleLabel.isHidden = false
            bottomLine.isHidden = true
            titleLabel.snp.remakeConstraints {
                $0.center.equalToSuperview()
            }
        case .centerConutRightX:
            [titleLabel, closeButton].forEach { $0.isHidden = false }
            titleLabel.snp.remakeConstraints {
                $0.centerX.centerY.equalToSuperview()
            }
        case .onlyRightX:
            closeButton.isHidden = false
        case .backTitleRightDelete:
            [backButton, titleLabel, deleteButton].forEach { $0.isHidden = false }
            titleLabel.snp.remakeConstraints {
                $0.center.equalToSuperview()
//                $0.leading.equalTo(backButton.snp.trailing)
//                $0.trailing.equalTo(moreButton.snp.leading)
            }
            break
        case .none:
            break
        }
    }

    func setCurrentPage(currentIndex: Int, totalCount: Int) {
//        let indexStyle = StringStyle(.font(.notoSans(size: 15)), .color(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)))
//        let totalCountStyle = StringStyle(.font(.notoSans(size: 15)), .color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.4)))
//        countLabel.attributedText = NSAttributedString.composed(of: [
//        String(currentIndex).styled(with: indexStyle), "/\(String(totalCount))".styled(with: totalCountStyle)])
//        if let text = countLabel.attributedText {
//            countLabel.snp.updateConstraints {
//                $0.width.equalTo(text.width(withConstrainedHeight: 22))
//            }
//        }
    }
}

extension BaseNavigationBar {

    func applyBlackTheme() {
        self.backgroundColor = .black
        self.backButton.setImage(#imageLiteral(resourceName: "BtnCommonBeforeW"), for: .normal)
        
        // TODO: black을 적용할경우, 하얀색 계열로 이미지를 변경해 줘야 하듯... 추후 아래에 추가!!
    }
    
}

