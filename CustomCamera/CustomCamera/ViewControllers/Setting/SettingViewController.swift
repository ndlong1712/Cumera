//
//  SettingViewController.swift
//  CustomCamera
//
//  Created by Mac Mini on 1/6/18.
//  Copyright © 2018 FAYA Corporation. All rights reserved.
//

import UIKit

let CRSelectColor = "3799F4"
let CRSecond = "second"
let CRSelectCard = "selectCard"
let CRDelayCapture = "delayCapture"
let CRLanguage = "language"
let CRDone = "done"
let CRCancel = "cancel"
let CRTime = "time"

enum Language: String {
    case VN = "vi"
    case ENG = "en"
}

class SettingViewController: UIViewController {
    static let ClassName = "SettingViewController"

    @IBOutlet weak var lbLanguage: UILabel!
    @IBOutlet weak var lbTimerCapture: UILabel!
    @IBOutlet weak var lbPickCard: UILabel!
    @IBOutlet weak var lbSecond: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var btnVn: UIButton!
    @IBOutlet weak var btnEngFlag: UIButton!
    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var btnSpade: UIButton!
    @IBOutlet weak var btnClub: UIButton!
    @IBOutlet weak var btnDiamond: UIButton!
    @IBOutlet weak var btnHeart: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sliderTimer: UISlider!
    @IBOutlet weak var switchCapture: UISwitch!
    
    var setting: SettingModel?
//    var lang: Language = .VN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewTimerMode(isOn: switchCapture.isOn)
        let lg = UserDefaultHelper.getLanguage()
        setUpLocalize(lang: lg)
    }
    
    func setUpLocalize(lang: String) {
        lbPickCard.text = CRSelectCard.localized(lang: lang)
        lbTimerCapture.text = CRDelayCapture.localized(lang: lang)
//        lbLanguage.text = CRLanguage.localized(lang: lang)
        btnCancel.setTitle(CRCancel.localized(lang: lang), for: .normal)
        btnDone.setTitle(CRDone.localized(lang: lang), for: .normal)
        lbTime.text = CRTime.localized(lang: lang)
        lbSecond.text = "\(Int(sliderTimer.value)) \(CRSecond.localized(lang: lang))"
    }
    
    func setupView() {
        sliderTimer.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
        let cardName = UserDefaultHelper.getCardName()
        let cardType = UserDefaultHelper.getCardType()
        let isCaptureTimer = UserDefaultHelper.getStatusIsCaptureTimer()
        let timer = UserDefaultHelper.getCaptureTimer()
        let language = UserDefaultHelper.getLanguage()
        setting = SettingModel(cardName: CardName(rawValue: cardName)!, cardType: CardType(rawValue: cardType)!, isCaptureTimer: isCaptureTimer, timer: timer, language: Language(rawValue: language)!)
        selectTypeCard(type: CardType(rawValue: cardType)!)
        setImageCard(set: self.setting!)
        switchCapture.isOn = isCaptureTimer
        sliderTimer.value = Float(timer)
        lbSecond.text = "\(timer) \(CRSecond.localized())"
        self.view.layoutIfNeeded()
        btnHeart.layer.cornerRadius = btnHeart.frame.width/2
        btnDiamond.layer.cornerRadius = btnHeart.frame.width/2
        btnClub.layer.cornerRadius = btnHeart.frame.width/2
        btnSpade.layer.cornerRadius = btnHeart.frame.width/2
        
//        setupButtonLanguage(lang: language)
    }
    
    func selectTypeCard(type: CardType) {
        if type == .hearts {
            selectTypeButton(btn: btnHeart)
            deselectTypeButton(btn: btnDiamond)
            deselectTypeButton(btn: btnSpade)
            deselectTypeButton(btn: btnClub)
        } else if type == .diamonds {
            selectTypeButton(btn: btnDiamond)
            deselectTypeButton(btn: btnHeart)
            deselectTypeButton(btn: btnSpade)
            deselectTypeButton(btn: btnClub)
        } else if type == .spades {
            selectTypeButton(btn: btnSpade)
            deselectTypeButton(btn: btnDiamond)
            deselectTypeButton(btn: btnHeart)
            deselectTypeButton(btn: btnClub)
        } else if type == .clubs {
            selectTypeButton(btn: btnClub)
            deselectTypeButton(btn: btnDiamond)
            deselectTypeButton(btn: btnSpade)
            deselectTypeButton(btn: btnHeart)
        }
    }
    
    func setImageCard(set: SettingModel) {
        let img = Utilities.showCard(cardName: (set.cardName), cardType: (set.cardType))
        self.imgCard.image = img
    }
    
    func selectTypeButton(btn: UIButton) {
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor().hexToColor(hexString: CRSelectColor, alpha: 1)
    }
    
    func deselectTypeButton(btn: UIButton) {
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func didTapSpadeButton(_ sender: Any) {
        selectTypeCard(type: .spades)
        self.setting?.cardType = .spades
        setImageCard(set: self.setting!)
    }
    
    @IBAction func didTapClubButton(_ sender: Any) {
        selectTypeCard(type: .clubs)
        self.setting?.cardType = .clubs
        setImageCard(set: self.setting!)
    }
    
    @IBAction func didTapDiamondButton(_ sender: Any) {
        selectTypeCard(type: .diamonds)
        self.setting?.cardType = .diamonds
        setImageCard(set: self.setting!)
    }
    
    @IBAction func didTapHeartButton(_ sender: Any) {
        selectTypeCard(type: .hearts)
        self.setting?.cardType = .hearts
        setImageCard(set: self.setting!)
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        UserDefaultHelper.saveSetting(setting: self.setting!)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapEngFlag(_ sender: Any) {
        setupButtonLanguage(lang: Language.ENG.rawValue)
        setting?.language = .ENG
        setUpLocalize(lang: (setting?.language.rawValue)!)
    }
    
    @IBAction func didTapVnFlag(_ sender: Any) {
        setupButtonLanguage(lang: Language.VN.rawValue)
        setting?.language = .VN
        setUpLocalize(lang: (setting?.language.rawValue)!)
    }
    
    func setupButtonLanguage(lang: String) {
        if lang == Language.ENG.rawValue {
            btnEngFlag.layer.borderWidth = 2
            btnEngFlag.layer.cornerRadius = 2
            btnEngFlag.layer.borderColor = UIColor.blue.cgColor
            btnVn.layer.borderWidth = 0
        } else { // VN
            btnVn.layer.borderWidth = 2
            btnVn.layer.cornerRadius = 2
            btnVn.layer.borderColor = UIColor.blue.cgColor
            btnEngFlag.layer.borderWidth = 0
        }
    }
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:break
            case .moved:
                lbSecond.text = "\(Int(sliderTimer.value)) \(CRSecond.localized())"
                break
            case .ended:
                let timer = Int(sliderTimer.value)
                self.setting?.timer = timer
                break
            default:
                break
            }
        }
    }
    
    @IBAction func didTapSwitch(_ sender: Any) {
        self.setting?.isCaptureTimer = switchCapture.isOn
        setupViewTimerMode(isOn: switchCapture.isOn)
    }
    
    func setupViewTimerMode(isOn: Bool) {
        lbTime.isHidden = !isOn
        lbSecond.isHidden = !isOn
        sliderTimer.isHidden = !isOn
    }
    
}

extension SettingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return CardModel.ofCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.ClassName,
                                                      for: indexPath) as! CardCollectionViewCell
        let cardModel = CardModel.ofCards[indexPath.row]
        cell.labelCardName.text = cardModel.name.rawValue
        cell.setupView()
        if cardModel.name == self.setting?.cardName {
            cell.isSelected = true
        }
        if cardModel.kind == self.setting?.cardType {
            selectTypeCard(type: (self.setting?.cardType)!)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cardName = CardModel.ofCards[indexPath.row].name.rawValue
        self.setting?.cardName = CardName(rawValue: cardName)!
        setImageCard(set: self.setting!)
        self.collectionView.reloadData()
    }
    
}

extension SettingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthScreen = UIScreen.main.bounds.size.width
        return CGSize(width: widthScreen/13 - 4.3 , height: widthScreen/13 - 4.3)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}
