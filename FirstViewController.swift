//
//  FirstViewController.swift
//  IdealGasLawApp
//
//  Created by Maliha Islam on 2017-05-11.
//  Copyright © 2017 Maliha Islam. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit
import GoogleMobileAds

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound - r.lowerBound)
        return self[Range(start ..< end)]
    }
}

class FirstViewController: UIViewController {
    
    // MARK: Properties and Variables
    
    @IBOutlet weak var pButton: UIButton!
    @IBOutlet weak var tButton: UIButton!
    @IBOutlet weak var vButton: UIButton!
    @IBOutlet weak var nButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var instrLabel: UILabel!
    @IBOutlet weak var calcLabel: UILabel!
    @IBOutlet weak var errLabel: UILabel!
    
    @IBOutlet weak var nLabel: UILabel!
    @IBOutlet weak var pTxt: UIButton!
    @IBOutlet weak var tTxt: UIButton!
    @IBOutlet weak var vTxt: UIButton!
    @IBOutlet weak var nTxt: UIButton!
    
    @IBOutlet weak var pSegCtrl: UISegmentedControl!
    @IBOutlet weak var tSegCtrl: UISegmentedControl!
    @IBOutlet weak var vSegCtrl: UISegmentedControl!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var buttonDot: UIButton!
    @IBOutlet weak var buttonE: UIButton!
    @IBOutlet weak var buttonNeg: UIButton!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonClr: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    var pStr: String = ""
    var tStr: String = ""
    var vStr: String = ""
    var nStr: String = ""
    var unitStr: String = ""
    
    var p: Float?
    var t: Float?
    var v: Float?
    var n: Float?
    var R: Float?
    
    var pTxtSel: Bool = false
    var tTxtSel: Bool = false
    var vTxtSel: Bool = false
    var nTxtSel: Bool = false
    
    var pCalc: Bool = false
    var tCalc: Bool = false
    var vCalc: Bool = false
    var nCalc: Bool = false
    
    var atmSel: Bool = true
    var PaSel: Bool = false
    var KSel: Bool = true
    var CSel: Bool = false
    var LSel: Bool = true
    var cubicmSel: Bool = false
    
    var keyPad = [UIButton]()
    
    let screenSize = UIScreen.main.bounds
    let iphone7plusW: CGFloat = 414
    let iphone7plusH: CGFloat = 736
    let screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var bannerView: GADBannerView!
    
    var posSound = AVAudioPlayer()
    var negSound = AVAudioPlayer()
    
    var freeSpacing : CGFloat = 0.0 //will be used depending on whether or not the app is for free or paid for
    
    // MARK: Actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        /* setting up click sound */
        
        let posSoundPath =  Bundle.main.path(forResource: "possound", ofType: "wav")
        do{
            posSound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: posSoundPath!))
        } catch{
            print(error)
        }
        
        let negSoundPath =  Bundle.main.path(forResource: "negsound", ofType: "wav")
        do{
            negSound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: negSoundPath!))
        } catch{
            print(error)
        }
        
        /* Initializing keypad */
        
        keyPad = [button1, button2, button3, buttonBack, button4, button5, button6, buttonClr, button7, button8, button9, button0, buttonDot, buttonE, buttonNeg]
        
        disableCalc()
        
        
        /* Setting element constraints */
        
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
       
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        if GlobalConstants.isFree == true {
         self.view.addSubview(bannerView)
            screenHeight = screenHeight - bannerView.frame.height
            freeSpacing = bannerView.frame.height
        }
        
        screenHeight = screenHeight - 50
        
        //positioning and sizing keypad buttons
        var x = CGFloat()
        var y = CGFloat()
        var buttonW = CGFloat()
        let buttonH: CGFloat = 0.1*screenHeight
        
        for button in keyPad{
            x = 0
            y = 0.6*screenHeight
            buttonW = screenWidth/4
            
            if keyPad[4...7].contains(button){
                y = 0.7*screenHeight
            }else if keyPad[8...11].contains(button){
                y = 0.8*screenHeight
            }else if keyPad[12...14].contains(button){
                y = 0.9*screenHeight
            }
            if button == button2 || button == button5 || button == button8{
                x = 0.25*screenWidth
            }else if button == button3 || button == button6 || button == button9{
                x = 0.5*screenWidth
            }else if button == buttonBack || button == buttonClr || button == button0{
                x = 0.75*screenWidth
            }else if button == buttonDot || button == buttonE || button == buttonNeg{
                buttonW = screenWidth/3
                if button == buttonE{
                    x = screenWidth/3
                }else if button == buttonNeg{
                    x = 2*(screenWidth/3)
                }
            }
            
            button.frame = CGRect(x: x, y: y + freeSpacing, width: buttonW, height: buttonH)
            button.titleLabel?.font = UIFont.init(name:"HelveticaNeue-Light", size: 40*(screenHeight/iphone7plusH))
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            
        }
        
        
        //positioning and sizing input area
        
        pButton.frame = CGRect(x: 20*(screenWidth/iphone7plusW), y: 183*(screenHeight/iphone7plusH) + freeSpacing, width: 50*(screenWidth/iphone7plusW), height: 50*(screenWidth/iphone7plusW))
        tButton.frame = CGRect(x: 348*(screenWidth/iphone7plusW), y: 183*(screenHeight/iphone7plusH) + freeSpacing,width: 50*(screenWidth/iphone7plusW), height: 50*(screenWidth/iphone7plusW))
        vButton.frame = CGRect(x: 20*(screenWidth/iphone7plusW), y: 271*(screenHeight/iphone7plusH) + freeSpacing,width: 50*(screenWidth/iphone7plusW), height: 50*(screenWidth/iphone7plusW))
        nButton.frame = CGRect(x: 348*(screenWidth/iphone7plusW), y: 271*(screenHeight/iphone7plusH) + freeSpacing,width: 50*(screenWidth/iphone7plusW), height: 50*(screenWidth/iphone7plusW))
        
        createCircButton(button: pButton)
        createCircButton(button: tButton)
        createCircButton(button: vButton)
        createCircButton(button: nButton)
        
        pTxt.frame = CGRect(x: 74*(screenWidth/iphone7plusW), y: 185*(screenHeight/iphone7plusH) + freeSpacing, width: 125*(screenWidth/iphone7plusW), height: 33*(screenHeight/iphone7plusH))
        tTxt.frame = CGRect(x: 215*(screenWidth/iphone7plusW), y: 185*(screenHeight/iphone7plusH) + freeSpacing,width: 125*(screenWidth/iphone7plusW), height: 33*(screenHeight/iphone7plusH))
        vTxt.frame = CGRect(x: 74*(screenWidth/iphone7plusW), y: 273*(screenHeight/iphone7plusH) + freeSpacing,width: 125*(screenWidth/iphone7plusW), height: 33*(screenHeight/iphone7plusH))
        nTxt.frame = CGRect(x: 215*(screenWidth/iphone7plusW), y: 273*(screenHeight/iphone7plusH) + freeSpacing,width: 125*(screenWidth/iphone7plusW), height: 33*(screenHeight/iphone7plusH))
        
        pTxt.layer.cornerRadius = GlobalConstants.cornerR
        pTxt.layer.borderWidth = GlobalConstants.borderW
        pTxt.layer.borderColor = GlobalConstants.lightpurple.cgColor
        tTxt.layer.cornerRadius = GlobalConstants.cornerR
        tTxt.layer.borderWidth = GlobalConstants.borderW
        tTxt.layer.borderColor = GlobalConstants.lightpurple.cgColor
        vTxt.layer.cornerRadius = GlobalConstants.cornerR
        vTxt.layer.borderWidth = GlobalConstants.borderW;
        vTxt.layer.borderColor = GlobalConstants.lightpurple.cgColor
        nTxt.layer.cornerRadius = GlobalConstants.cornerR;
        nTxt.layer.borderWidth = GlobalConstants.borderW;
        nTxt.layer.borderColor = GlobalConstants.lightpurple.cgColor
        
        pSegCtrl.frame = CGRect(x: 74*(screenWidth/iphone7plusW), y: 223*(screenHeight/iphone7plusH) + freeSpacing, width: 125*(screenWidth/iphone7plusW), height: 33*(screenHeight/iphone7plusH))
        tSegCtrl.frame = CGRect(x: 215*(screenWidth/iphone7plusW), y: 223*(screenHeight/iphone7plusH) + freeSpacing, width: 125*(screenWidth/iphone7plusW), height: 33*(screenHeight/iphone7plusH))
        vSegCtrl.frame = CGRect(x: 74*(screenWidth/iphone7plusW), y: 312*(screenHeight/iphone7plusH) + freeSpacing,width: 125*(screenWidth/iphone7plusW), height: 33*(screenHeight/iphone7plusH))
        nLabel.frame = CGRect(x: 215*(screenWidth/iphone7plusW), y: 312*(screenHeight/iphone7plusH) + freeSpacing, width: 125*(screenWidth/iphone7plusW), height: 33*(screenHeight/iphone7plusH))
        nLabel.layer.masksToBounds = true
        nLabel.layer.cornerRadius = GlobalConstants.cornerR
        
        /* font styles and sizes */
        tSegCtrl.setTitleTextAttributes([NSFontAttributeName: UIFont.init(name:"HelveticaNeue-Light", size: 14*(screenWidth/iphone7plusW)) as Any], for: .normal)
        pSegCtrl.setTitleTextAttributes([NSFontAttributeName: UIFont.init(name:"HelveticaNeue-Light", size: 14*(screenWidth/iphone7plusW)) as Any], for: .normal)
        vSegCtrl.setTitleTextAttributes([NSFontAttributeName: UIFont.init(name:"HelveticaNeue-Light", size: 14*(screenWidth/iphone7plusW)) as Any], for: .normal)
        nLabel.font = nLabel.font.withSize(14*(screenWidth/iphone7plusW))
        
        resetButton.frame = CGRect(x: 307*(screenWidth/iphone7plusW), y: 130*(screenHeight/iphone7plusH) + freeSpacing, width: 87*(screenWidth/iphone7plusW), height: 37*(screenHeight/iphone7plusH))
        resetButton.layer.cornerRadius = GlobalConstants.cornerR
        
        /* font styles and sizes */
        resetButton.titleLabel?.font = UIFont.init(name:"HelveticaNeue-Light", size: 17*(screenWidth/iphone7plusW))
        resetButton.titleLabel?.adjustsFontSizeToFitWidth = true
        pButton.titleLabel?.font = UIFont.init(name:"HelveticaNeue-Light", size: 20*(screenWidth/iphone7plusW))
        tButton.titleLabel?.font = UIFont.init(name:"HelveticaNeue-Light", size: 20*(screenWidth/iphone7plusW))
        vButton.titleLabel?.font = UIFont.init(name:"HelveticaNeue-Light", size: 20*(screenWidth/iphone7plusW))
        nButton.titleLabel?.font = UIFont.init(name:"HelveticaNeue-Light", size: 20*(screenWidth/iphone7plusW))
        pTxt.titleLabel?.font = UIFont.init(name:"HelveticaNeue-Light", size: 17*(screenWidth/iphone7plusW))
        tTxt.titleLabel?.font = UIFont.init(name:"HelveticaNeue-Light", size: 17*(screenWidth/iphone7plusW))
        vTxt.titleLabel?.font = UIFont.init(name:"HelveticaNeue-Light", size: 17*(screenWidth/iphone7plusW))
        nTxt.titleLabel?.font = UIFont.init(name:"HelveticaNeue-Light", size: 17*(screenWidth/iphone7plusW))
        
        
        //positioning and sizing labels
        instrLabel.frame = CGRect(x: 20*(screenWidth/iphone7plusW), y: 131*(screenHeight/iphone7plusH) + freeSpacing,width: 282*(screenWidth/iphone7plusW), height: 37*(screenHeight/iphone7plusH))
        errLabel.frame = CGRect(x: 20*(screenWidth/iphone7plusW), y: 348*(screenHeight/iphone7plusH) + freeSpacing,width: 374*(screenWidth/iphone7plusW), height: 31*(screenHeight/iphone7plusH))
        calcLabel.frame = CGRect(x: 20*(screenWidth/iphone7plusW), y: 63*(screenHeight/iphone7plusH) + freeSpacing,width: 374*(screenWidth/iphone7plusW), height: 59*(screenHeight/iphone7plusH))
        titleLabel.frame = CGRect(x: 20*(screenWidth/iphone7plusW), y: 28*(screenHeight/iphone7plusH) + freeSpacing ,width: 374*(screenWidth/iphone7plusW), height: 35*(screenHeight/iphone7plusH))
        //titleLabel.frame = CGRect(x: 20*(screenWidth/iphone7plusW), y: 15 + freeSpacing,width: screenWidth - 40, height: 150)
        
        /* font styles and sizes */
        instrLabel.font = instrLabel.font.withSize(17*(screenWidth/iphone7plusW))
        errLabel.font = errLabel.font.withSize(16*(screenWidth/iphone7plusW))
        calcLabel.font = calcLabel.font.withSize(20*(screenWidth/iphone7plusW))
        titleLabel.font = titleLabel.font.withSize(screenWidth*0.075)//(25*(screenWidth/iphone7plusW))
        //titleLabel.sizeToFit()
        
        /* Tag text buttons */
        
        pTxt.tag = 1
        tTxt.tag = 2
        vTxt.tag = 3
        nTxt.tag = 4
        
        // adding ads
        
        screenHeight = UIScreen.main.bounds.height
        
        
        
        //let request = GADRequest()
        //request.testDevices = [ kGADSimulatorID,            "2077ef9a63d2b398840261c8221a0c9b"];
        
        bannerView.frame.origin.y = 0.0
        bannerView.frame.origin.x = screenWidth/2 - bannerView.frame.width/2
        
       
    }
    
    
   
    
    /* Creating circular buttons */
    
    func createCircButton(button: UIButton){
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        view.addSubview(button)
    }
    
    /* Pulsating calculation buttons */
    
    func pulsate(button: UIButton){
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.duration = 0.1
        pulse.fromValue = 1.0
        pulse.toValue = 1.1
        pulse.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulse.repeatCount = 1.0
        pulse.autoreverses = true
        button.layer.add(pulse, forKey: "animateTransform")
    }
    
    /* Calculator button actions */
    
    func numButtonHandling(button: UIButton, numStr: String){
        if pTxtSel == true{
            pButton.backgroundColor = GlobalConstants.lightpink
            if pStr.characters.count != 11{
                let newStr: String = pStr + String(numStr)
                pStr = newStr
                pTxt.setTitle(pStr, for: .normal)
            }else{
                errMsg(error: "maxDigit")
            }
            calcButtonSetUp()
            pButton.backgroundColor = GlobalConstants.lightpink
            if tCalc{
                self.tButton(nil)
            }else if vCalc{
                self.vButton(nil)
            }else if nCalc{
                self.nButton(nil)
            }
            
        } else if tTxtSel == true{
            tButton.backgroundColor = GlobalConstants.lightpink
            if tStr.characters.count != 11{
                let newStr: String = tStr + String(numStr)
                tStr = newStr
                tTxt.setTitle(tStr, for: .normal)
            }else{
                errMsg(error: "maxDigit")
            }
            calcButtonSetUp()
            tButton.backgroundColor = GlobalConstants.lightpink
            if pCalc{
                self.pButton(nil)
            }else if vCalc{
                self.vButton(nil)
            }else if nCalc{
                self.nButton(nil)
            }
            
        } else if nTxtSel == true{
            nButton.backgroundColor = GlobalConstants.lightpink
            if nStr.characters.count != 11{
                let newStr: String = nStr + String(numStr)
                nStr = newStr
                nTxt.setTitle(nStr, for: .normal)
            }else{
                errMsg(error: "maxDigit")
            }
            calcButtonSetUp()
            nButton.backgroundColor = GlobalConstants.lightpink
            if tCalc{
                self.tButton(nil)
            }else if vCalc{
                self.vButton(nil)
            }else if pCalc{
                self.pButton(nil)
            }
            
        } else if vTxtSel == true{
            vButton.backgroundColor = GlobalConstants.lightpink
            if vStr.characters.count != 11{
                let newStr: String = vStr + String(numStr)
                vStr = newStr
                vTxt.setTitle(vStr, for: .normal)
            }else{
                errMsg(error: "maxDigit")
            }
            calcButtonSetUp()
            vButton.backgroundColor = GlobalConstants.lightpink
            if tCalc{
                self.tButton(nil)
            }else if pCalc{
                self.pButton(nil)
            }else if nCalc{
                self.nButton(nil)
            }
        }
        
    }
    
    @IBAction func button1(_ sender: UIButton) {
        posSound.play()
        numButtonHandling(button: button1, numStr:"1")
        
    }
    
    @IBAction func button2(_ sender: UIButton) {
        posSound.play()
        numButtonHandling(button: button2, numStr:"2")
    }
    
    @IBAction func button3(_ sender: UIButton) {
        posSound.play()
        numButtonHandling(button: button3, numStr:"3")
    }
    
    @IBAction func button4(_ sender: UIButton) {
        posSound.play()
        numButtonHandling(button: button4, numStr:"4")
    }
    
    @IBAction func button5(_ sender: UIButton) {
        posSound.play()
        numButtonHandling(button: button5, numStr:"5")
    }
    
    @IBAction func button6(_ sender: UIButton) {
        posSound.play()
        numButtonHandling(button: button6, numStr:"6")
    }
    
    @IBAction func button7(_ sender: UIButton) {
        posSound.play()
        numButtonHandling(button: button7, numStr:"7")
    }
    
    @IBAction func button8(_ sender: UIButton) {
        posSound.play()
        numButtonHandling(button: button8, numStr:"8")
    }
    
    @IBAction func button9(_ sender: UIButton) {
        posSound.play()
        numButtonHandling(button: button9, numStr:"9")
    }
    
    @IBAction func button0(_ sender: UIButton) {
        posSound.play()
        numButtonHandling(button: button0, numStr:"0")
    }
    
    @IBAction func buttonDot(_ sender: UIButton) {
        posSound.play()
        numButtonHandling(button: buttonDot, numStr:".")
    }
    
    @IBAction func buttonE(_ sender: UIButton) {
        posSound.play()
        numButtonHandling(button: buttonE, numStr:"E")
    }
    
    @IBAction func buttonNeg(_ sender: UIButton) {
        posSound.play()
        numButtonHandling(button: buttonNeg, numStr:"-")
    }
    
    @IBAction func buttonBack(_ sender: UIButton) {
        negSound.play()
        if pTxtSel == true{
            pButton.backgroundColor = GlobalConstants.lightpink
            pStr = String(pStr.characters.dropLast())
            pTxt.setTitle(pStr, for: .normal)
        } else if tTxtSel == true{
            tButton.backgroundColor = GlobalConstants.lightpink
            tStr = String(tStr.characters.dropLast())
            tTxt.setTitle(tStr, for: .normal)
        } else if nTxtSel == true{
            nButton.backgroundColor = GlobalConstants.lightpink
            nStr = String(nStr.characters.dropLast())
            nTxt.setTitle(nStr, for: .normal)
        } else if vTxtSel == true{
            vButton.backgroundColor = GlobalConstants.lightpink
            vStr = String(vStr.characters.dropLast())
            vTxt.setTitle(vStr, for: .normal)
        }
        
        if tCalc{
            self.tButton(nil)
        }else if pCalc{
            self.pButton(nil)
        }else if nCalc{
            self.nButton(nil)
        }else if vCalc{
            self.vButton(nil)
        }
    }
    
    @IBAction func buttonClr(_ sender: UIButton) {
        negSound.play()
        if pTxtSel == true{
            pButton.backgroundColor = GlobalConstants.lightpink
            pStr = ""
            pTxt.setTitle(pStr, for: .normal)
        } else if tTxtSel == true{
            tButton.backgroundColor = GlobalConstants.lightpink
            tStr = ""
            tTxt.setTitle(tStr, for: .normal)
        } else if nTxtSel == true{
            nButton.backgroundColor = GlobalConstants.lightpink
            nStr = ""
            nTxt.setTitle(nStr, for: .normal)
        } else if vTxtSel == true{
            vButton.backgroundColor = GlobalConstants.lightpink
            vStr = ""
            vTxt.setTitle(vStr, for: .normal)
        }
        
        if tCalc{
            self.tButton(nil)
        }else if pCalc{
            self.pButton(nil)
        }else if nCalc{
            self.nButton(nil)
        }else if vCalc{
            self.vButton(nil)
        }
    }
    
    
    /* Text button handling */
    
    @IBAction func pTxt(_ sender: UIButton) {
        buttonTapped(sender: pTxt)
    }
    @IBAction func tTxt(_ sender: UIButton) {
        buttonTapped(sender: tTxt)
    }
    @IBAction func vTxt(_ sender: UIButton) {
        buttonTapped(sender: vTxt)
    }
    @IBAction func nTxt(_ sender: UIButton) {
        buttonTapped(sender: nTxt)
    }
    
    
    /* Calculating values */
    
    @IBAction func pButton(_ sender: AnyObject?) {
        pulsate(button: pButton)
        t = Float(tStr)
        v = Float(vStr)
        n = Float(nStr)
        
        if t == nil || v == nil || n == nil || vStr[0] == "-" || nStr[0] == "-" || (tStr[0] == "-" && KSel) || (tStr[0] == "-" && CSel && t! < -273.15){
            errMsg(error: "invalid")
            calcLabel.text = ""
            pStr = ""
            pTxt.contentHorizontalAlignment = .center
            pTxt.setTitleColor(GlobalConstants.lightpurple, for: .normal)
            pTxt.backgroundColor = UIColor.clear
            pTxt.setTitle("pressure", for: .normal)
        }else if v==0{
            errMsg(error: "divby0")
            calcLabel.text = ""
            pStr = ""
            pTxt.contentHorizontalAlignment = .center
            pTxt.setTitleColor(GlobalConstants.lightpurple, for: .normal)
            pTxt.backgroundColor = UIColor.clear
            pTxt.setTitle("pressure", for: .normal)
        }else {
            pCalc = true
            tCalc = false
            vCalc = false
            nCalc = false
            
            errMsg(error: "none")
            
            // if C is selected, convert Celsius to Kelvins
            if CSel{
                t = t! + 273.15
            }
            if LSel{
                if atmSel{
                    R = 8.20575E-2
                    unitStr = "atm"
                }else if PaSel{
                    R = 8.31447E3
                    unitStr = "Pa"
                }
            }else if cubicmSel{
                if atmSel{
                    R = 8.20575E-5
                    unitStr = "atm"
                }else if PaSel{
                    R = 8.31447
                    unitStr = "Pa"
                }
            }
            p = (n!*R!*t!)/v!
            pStr = String(format:"%.2E", p!)
            pTxt.contentHorizontalAlignment = .right
            pTxt.setTitleColor(GlobalConstants.darkpurple, for: .normal)
            pTxt.backgroundColor = GlobalConstants.yellow
            pTxt.setTitle(pStr, for: .normal)
            
            calcLabel.text = "P = (nRT)/V = \(pStr) \(unitStr)"
        }
    }
    
    @IBAction func tButton(_ sender: AnyObject?) {
        pulsate(button: tButton)
        p = Float(pStr)
        v = Float(vStr)
        n = Float(nStr)
        
        if p == nil || v == nil || n == nil || vStr[0] == "-" || nStr[0] == "-" || pStr[0] == "-"{
            errMsg(error: "invalid")
            calcLabel.text = ""
            tStr = ""
            tTxt.contentHorizontalAlignment = .center
            tTxt.setTitleColor(GlobalConstants.lightpurple, for: .normal)
            tTxt.backgroundColor = UIColor.clear
            tTxt.setTitle("temperature", for: .normal)
        }else if n==0{
            errMsg(error: "divby0")
            calcLabel.text = ""
            tStr = ""
            tTxt.contentHorizontalAlignment = .center
            tTxt.setTitleColor(GlobalConstants.lightpurple, for: .normal)
            tTxt.backgroundColor = UIColor.clear
            tTxt.setTitle("temperature", for: .normal)
        }else{
            tCalc = true
            pCalc = false
            vCalc = false
            nCalc = false
            
            errMsg(error: "none")
            
            if LSel{
                if atmSel{
                    R = 8.20575E-2
                }else if PaSel{
                    R = 8.31447E3
                }
            }else if cubicmSel{
                if atmSel{
                    R = 8.20575E-5
                }else if PaSel{
                    R = 8.31447
                }
            }
            t = (p!*v!)/(n!*R!) //in Kelvins, default
            
            
            if CSel{
                t = t! - 273.15
                unitStr = "°C"
            }else if KSel{
                unitStr = "K"
            }
            tStr = String(format:"%.2f", t!)
            tTxt.contentHorizontalAlignment = .right
            tTxt.setTitleColor(GlobalConstants.darkpurple, for: .normal)
            tTxt.backgroundColor = GlobalConstants.yellow
            tTxt.setTitle(tStr, for: .normal)
            
            calcLabel.text = "T = (PV)/(nR) = \(tStr) \(unitStr)"
            
        }
    }
    
    @IBAction func vButton(_ sender: AnyObject?) {
        pulsate(button: vButton)
        t = Float(tStr)
        p = Float(pStr)
        n = Float(nStr)
        
        if t == nil || p == nil || n == nil || pStr[0] == "-" || nStr[0] == "-" || (tStr[0] == "-" && KSel) || (tStr[0] == "-" && CSel && t! < -273.15){
            errMsg(error: "invalid")
            calcLabel.text = ""
            vStr = ""
            vTxt.contentHorizontalAlignment = .center
            vTxt.setTitleColor(GlobalConstants.lightpurple, for: .normal)
            vTxt.backgroundColor = UIColor.clear
            vTxt.setTitle("volume", for: .normal)
        }else if p==0{
            errMsg(error: "divby0")
            calcLabel.text = ""
            vStr = ""
            vTxt.contentHorizontalAlignment = .center
            vTxt.setTitleColor(GlobalConstants.lightpurple, for: .normal)
            vTxt.backgroundColor = UIColor.clear
            vTxt.setTitle("volume", for: .normal)
        }else{
            vCalc = true
            tCalc = false
            pCalc = false
            nCalc = false
            
            errMsg(error: "none")
            
            // convert Celsius to Kelvins
            if CSel{
                t = t! + 273.15
            }
            if LSel{
                unitStr = "L"
                if atmSel{
                    R = 8.20575E-2
                }else if PaSel{
                    R = 8.31447E3
                }
            }else if cubicmSel{
                unitStr = "m³"
                if atmSel{
                    R = 8.20575E-5
                }else if PaSel{
                    R = 8.31447
                }
            }
            v = (n!*R!*t!)/p!
            vStr = String(format:"%.2E", v!)
            vTxt.contentHorizontalAlignment = .right
            vTxt.setTitleColor(GlobalConstants.darkpurple, for: .normal)
            vTxt.backgroundColor = GlobalConstants.yellow
            vTxt.setTitle(vStr, for: .normal)
            
            calcLabel.text = "V = (nRT)/P = \(vStr) \(unitStr)"
        }
        
    }
    
    @IBAction func nButton(_ sender: AnyObject?) {
        pulsate(button: nButton)
        t = Float(tStr)
        v = Float(vStr)
        p = Float(pStr)
        
        if t == nil || v == nil || p == nil || vStr[0] == "-" || pStr[0] == "-" || (tStr[0] == "-" && KSel) || (tStr[0] == "-" && CSel && t! < -273.15){
            errMsg(error: "invalid")
            calcLabel.text = ""
            nStr = ""
            nTxt.contentHorizontalAlignment = .center
            nTxt.setTitleColor(GlobalConstants.lightpurple, for: .normal)
            nTxt.backgroundColor = UIColor.clear
            nTxt.setTitle("amount", for: .normal)
        }else if t==0{
            errMsg(error: "divby0")
            calcLabel.text = ""
            nStr = ""
            nTxt.contentHorizontalAlignment = .center
            nTxt.setTitleColor(GlobalConstants.lightpurple, for: .normal)
            nTxt.backgroundColor = UIColor.clear
            nTxt.setTitle("amount", for: .normal)
        }else{
            nCalc = true
            tCalc = false
            vCalc = false
            pCalc = false
            
            unitStr = "g mol"
            errMsg(error: "none")
            
            // convert Celsius to Kelvins
            if CSel{
                t = t! + 273.15
            }
            if LSel{
                if atmSel{
                    R = 8.20575E-2
                }else if PaSel{
                    R = 8.31447E3
                }
            }else if cubicmSel{
                if atmSel{
                    R = 8.20575E-5
                }else if PaSel{
                    R = 8.31447
                }
            }
            n = (p!*v!)/(R!*t!)
            nStr = String(format:"%.2E", n!)
            nTxt.contentHorizontalAlignment = .right
            nTxt.setTitleColor(GlobalConstants.darkpurple, for: .normal)
            nTxt.backgroundColor = GlobalConstants.yellow
            nTxt.setTitle(nStr, for: .normal)
            
            calcLabel.text = "n = (PV)/(RT) = \(nStr) \(unitStr)"
        }
        
    }
    
    /* Unit controls */
    
    @IBAction func pSegCtrl(_ sender: UISegmentedControl) {
        switch pSegCtrl.selectedSegmentIndex{
        case 0:
            atmSel = true
            PaSel = false
            if tCalc{
                self.tButton(nil)
            }else if pCalc{
                self.pButton(nil)
            }else if nCalc{
                self.nButton(nil)
            }else if vCalc{
                self.vButton(nil)
            }
        case 1:
            PaSel = true
            atmSel = false
            if tCalc{
                self.tButton(nil)
            }else if pCalc{
                self.pButton(nil)
            }else if nCalc{
                self.nButton(nil)
            }else if vCalc{
                self.vButton(nil)
            }
        default:
            break
        }
    }
    
    @IBAction func tSegCtrl(_ sender: UISegmentedControl) {
        switch tSegCtrl.selectedSegmentIndex{
        case 0:
            KSel = true
            CSel = false
            if tCalc{
                self.tButton(nil)
            }else if pCalc{
                self.pButton(nil)
            }else if nCalc{
                self.nButton(nil)
            }else if vCalc{
                self.vButton(nil)
            }
        case 1:
            CSel = true
            KSel = false
            if tCalc{
                self.tButton(nil)
            }else if pCalc{
                self.pButton(nil)
            }else if nCalc{
                self.nButton(nil)
            }else if vCalc{
                self.vButton(nil)
            }
        default:
            break
        }
    }
    
    @IBAction func vSegCtrl(_ sender: UISegmentedControl) {
        switch vSegCtrl.selectedSegmentIndex{
        case 0:
            LSel = true
            cubicmSel = false
            if tCalc{
                self.tButton(nil)
            }else if pCalc{
                self.pButton(nil)
            }else if nCalc{
                self.nButton(nil)
            }else if vCalc{
                self.vButton(nil)
            }
        case 1:
            cubicmSel = true
            LSel = false
            if tCalc{
                self.tButton(nil)
            }else if pCalc{
                self.pButton(nil)
            }else if nCalc{
                self.nButton(nil)
            }else if vCalc{
                self.vButton(nil)
            }
        default:
            break
        }
    }
    
    /* Error handling */
    
    func errMsg(error: String){
        switch error{
        case "tooManyVal":
            calcButtonSetUp()
            errLabel.text = "Error: Cannot enter more than three values"
            disableCalc()
            break
        case "invalid":
            errLabel.text = "Error: One or more values are invalid or missing"
            break
        case "maxDigit":
            errLabel.text = "Error: Maximum number of digits reached"
            disableCalc()
            break
        case "invalidTemp":
            errLabel.text = "Error: Invalid temperature calculated. Check all values."
            break
        case "divby0":
            errLabel.text = "Error: Undefined value (division by 0). Check all values."
            break
        case "none":
            errLabel.text = ""
            break
            
        default:
            break
        }
    }
    
    /* Disabling the calculator */
    func disableCalc(){
        for key in keyPad{
            key.isEnabled = false
        }
    }
    
    /* Enabling the calculator */
    func enableCalc(){
        for key in keyPad{
            key.isEnabled = true
        }
    }
    
    /* Resetting the textfields */
    
    @IBAction func resetButton(_ sender: UIButton) {
        pulsate(button: resetButton)
        negSound.play()
        
        //enabling text buttons
        
        pTxt.isEnabled = true
        tTxt.isEnabled = true
        vTxt.isEnabled = true
        nTxt.isEnabled = true
        
        //retting calculation buttons
        
        instrLabel.text = "Enter any three values"
        
        pButton.isEnabled = false
        tButton.isEnabled = false
        vButton.isEnabled = false
        nButton.isEnabled = false
        
        pCalc = false
        tCalc = false
        vCalc = false
        nCalc = false
        
        pButton.backgroundColor = GlobalConstants.pink
        tButton.backgroundColor = GlobalConstants.pink
        vButton.backgroundColor = GlobalConstants.pink
        nButton.backgroundColor = GlobalConstants.pink
        
        //disabling calculator
        disableCalc()
        
        //resetting text buttons
        pStr = ""
        pTxt.setTitleColor(GlobalConstants.lightpurple, for: .normal)
        pTxt.backgroundColor = UIColor.clear
        pTxt.setTitle("pressure", for: .normal)
        pTxt.contentHorizontalAlignment = .center
        
        tStr = ""
        tTxt.setTitleColor(GlobalConstants.lightpurple, for: .normal)
        tTxt.backgroundColor = UIColor.clear
        tTxt.setTitle("temperature", for: .normal)
        tTxt.contentHorizontalAlignment = .center
        
        vStr = ""
        vTxt.setTitleColor(GlobalConstants.lightpurple, for: .normal)
        vTxt.backgroundColor = UIColor.clear
        vTxt.setTitle("volume", for: .normal)
        vTxt.contentHorizontalAlignment = .center
        
        nStr = ""
        nTxt.setTitleColor(GlobalConstants.lightpurple, for: .normal)
        nTxt.backgroundColor = UIColor.clear
        nTxt.setTitle("amount", for: .normal)
        nTxt.contentHorizontalAlignment = .center
        
        calcLabel.text = ""
        errLabel.text = ""
    }
    
    /* Calculator button press handling */
    func buttonTapped(sender: UIButton){
        switch sender.tag {
        case 1:
            if tStr == "" || vStr == "" || nStr == "" || !pCalc{
                //setting up pressure text button
                
                errMsg(error: "none")
                pTxtSel = true
                pButton.backgroundColor = GlobalConstants.lightpink
                pTxt.setTitle(pStr, for: .normal)
                pTxt.contentHorizontalAlignment = .right
                pTxt.backgroundColor = UIColor.white
                pTxt.setTitleColor(GlobalConstants.darkpurple, for: .normal)
                
                // Unselecting other text buttons
                
                tTxtSel = false
                nTxtSel = false
                vTxtSel = false
                
                tButton.backgroundColor = GlobalConstants.pink
                nButton.backgroundColor = GlobalConstants.pink
                vButton.backgroundColor = GlobalConstants.pink
                
                tTxt.backgroundColor = UIColor.clear
                nTxt.backgroundColor = UIColor.clear
                vTxt.backgroundColor = UIColor.clear
                
                if vStr == ""{
                    vTxt.setTitleColor(GlobalConstants.lightpurple, for: .normal)
                    vTxt.contentHorizontalAlignment = .center
                    vTxt.setTitle("volume", for: .normal)
                    
                }
                if tStr == ""{
                    tTxt.setTitleColor(GlobalConstants.lightpurple, for: .normal)
                    tTxt.contentHorizontalAlignment = .center
                    tTxt.setTitle("temperature", for: .normal)
                }
                if nStr == ""{
                    nTxt.setTitleColor(GlobalConstants.lightpurple, for: .normal)
                    nTxt.contentHorizontalAlignment = .center
                    nTxt.setTitle("amount", for: .normal)
                }
                
                
                // Enabling calculator input
                enableCalc()
                
            }
            else{
                errMsg(error: "tooManyVal")
                
            }
            break
            
        case 2:
            if pStr == "" || vStr == "" || nStr == "" || !tCalc{
                //setting up temperature text button
                
                errMsg(error: "none")
                tTxtSel = true
                tButton.backgroundColor = GlobalConstants.lightpink
                tTxt.setTitle(tStr,for: .normal)
                tTxt.contentHorizontalAlignment = .right
                tTxt.backgroundColor = UIColor.white
                tTxt.setTitleColor(GlobalConstants.darkpurple, for: .normal)
                
                //unselecting other text buttons
                
                pTxtSel = false
                vTxtSel = false
                nTxtSel = false
                
                pButton.backgroundColor = GlobalConstants.pink
                vButton.backgroundColor = GlobalConstants.pink
                nButton.backgroundColor = GlobalConstants.pink
                
                pTxt.backgroundColor = UIColor.clear
                nTxt.backgroundColor = UIColor.clear
                vTxt.backgroundColor = UIColor.clear
                
                if pStr == ""{
                    pTxt.setTitleColor(GlobalConstants.lightpurple, for: .normal)
                    pTxt.contentHorizontalAlignment = .center
                    pTxt.setTitle("pressure", for: .normal)
                    
                }
                if vStr == ""{
                    vTxt.setTitleColor(GlobalConstants.lightpurple, for: .normal)
                    vTxt.contentHorizontalAlignment = .center
                    vTxt.setTitle("volume", for: .normal)
                }
                if nStr == ""{
                    nTxt.setTitleColor(GlobalConstants.lightpurple, for: .normal)
                    nTxt.contentHorizontalAlignment = .center
                    nTxt.setTitle("amount", for: .normal)
                }
                
                //enabling calculator input
                enableCalc()
                
            }else{
                errMsg(error: "tooManyVal")
                
            }
            
            break
        case 3:
            if pStr == "" || tStr == "" || nStr == "" || !vCalc{
                //setting up volume text button
                
                errMsg(error: "none")
                vTxtSel = true
                vButton.backgroundColor = GlobalConstants.lightpink
                vTxt.setTitle(vStr,for: .normal)
                vTxt.contentHorizontalAlignment = .right
                vTxt.backgroundColor = UIColor.white
                vTxt.setTitleColor(GlobalConstants.darkpurple, for: .normal)
                
                //unselecting other buttons
                
                tTxtSel = false
                nTxtSel = false
                pTxtSel = false
                
                tButton.backgroundColor = GlobalConstants.pink
                nButton.backgroundColor = GlobalConstants.pink
                pButton.backgroundColor = GlobalConstants.pink
                
                tTxt.backgroundColor = UIColor.clear
                nTxt.backgroundColor = UIColor.clear
                pTxt.backgroundColor = UIColor.clear
                
                if pStr == ""{
                    pTxt.setTitleColor(GlobalConstants.lightpurple, for: .normal)
                    pTxt.contentHorizontalAlignment = .center
                    pTxt.setTitle("pressure", for: .normal)
                    
                }
                if tStr == ""{
                    tTxt.setTitleColor(GlobalConstants.lightpurple, for: .normal)
                    tTxt.contentHorizontalAlignment = .center
                    tTxt.setTitle("temperature", for: .normal)
                }
                if nStr == ""{
                    nTxt.setTitleColor(GlobalConstants.lightpurple, for: .normal)
                    nTxt.contentHorizontalAlignment = .center
                    nTxt.setTitle("amount", for: .normal)
                }
                
                //enabling calculator input
                enableCalc()
                
            } else{
                errMsg(error: "tooManyVal")
                
            }
            break
            
        case 4:
            if pStr == "" || vStr == "" || tStr == "" || !nCalc{
                //setting up amount text button
                
                errMsg(error: "none")
                nTxtSel = true
                nButton.backgroundColor = GlobalConstants.lightpink
                nTxt.setTitle(nStr,for: .normal)
                nTxt.contentHorizontalAlignment = .right
                nTxt.backgroundColor = UIColor.white
                nTxt.setTitleColor(GlobalConstants.darkpurple, for: .normal)
                
                //unselecting other buttons
                
                tTxtSel = false
                vTxtSel = false
                pTxtSel = false
                
                tButton.backgroundColor = GlobalConstants.pink
                vButton.backgroundColor = GlobalConstants.pink
                pButton.backgroundColor = GlobalConstants.pink
                
                tTxt.backgroundColor = UIColor.clear
                vTxt.backgroundColor = UIColor.clear
                pTxt.backgroundColor = UIColor.clear
                
                if pStr == ""{
                    pTxt.setTitleColor(GlobalConstants.lightpurple, for: .normal)
                    pTxt.contentHorizontalAlignment = .center
                    pTxt.setTitle("pressure", for: .normal)
                    
                }
                if tStr == ""{
                    tTxt.setTitleColor(GlobalConstants.lightpurple, for: .normal)
                    tTxt.contentHorizontalAlignment = .center
                    tTxt.setTitle("temperature", for: .normal)
                }
                if vStr == ""{
                    vTxt.setTitleColor(GlobalConstants.lightpurple, for: .normal)
                    vTxt.contentHorizontalAlignment = .center
                    vTxt.setTitle("volume", for: .normal)
                }
                
                //enabling calculator input
                enableCalc()
                
            }else{
                errMsg(error: "tooManyVal")
            }
            break
            
        default:
            break
        }
    }
    
    func calcButtonSetUp(){
        
        if pStr != "" && tStr != "" && vStr != "" && nStr != ""{
            instrLabel.text = "Start Over to Calculate Another Value"
            if pCalc{
                pTxt.isEnabled = false
                tTxt.isEnabled = true
                vTxt.isEnabled = true
                nTxt.isEnabled = true
            }else if tCalc{
                tTxt.isEnabled = false
                pTxt.isEnabled = true
                vTxt.isEnabled = true
                nTxt.isEnabled = true
            }else if vCalc{
                vTxt.isEnabled = false
                tTxt.isEnabled = true
                pTxt.isEnabled = true
                nTxt.isEnabled = true
            }else if nCalc{
                nTxt.isEnabled = false
                tTxt.isEnabled = true
                vTxt.isEnabled = true
                pTxt.isEnabled = true
            }else{
                nTxt.isEnabled = true
                tTxt.isEnabled = true
                vTxt.isEnabled = true
                pTxt.isEnabled = true
            }
            
        } else if pStr != "" && tStr != "" && nStr != ""{
            //vButton.isEnabled = true
            vButton.backgroundColor = GlobalConstants.yellow
            vCalc = true
            //instrLabel.text = "Press the Yellow Button to Calculate"
            
            //tButton.isEnabled = false
            //pButton.isEnabled = false
            //nButton.isEnabled = false
            tCalc = false
            pCalc = false
            nCalc = false
            
            tButton.backgroundColor = GlobalConstants.pink
            pButton.backgroundColor = GlobalConstants.pink
            nButton.backgroundColor = GlobalConstants.pink
            
            vTxt.isEnabled = false
            tTxt.isEnabled = true
            pTxt.isEnabled = true
            nTxt.isEnabled = true
            
        }else if tStr != "" && nStr != "" && vStr != ""{
            //pButton.isEnabled = true
            pCalc = true
            pButton.backgroundColor = GlobalConstants.yellow
            //instrLabel.text = "Press the Yellow Button to Calculate"
            
            //tButton.isEnabled = false
            //vButton.isEnabled = false
            //nButton.isEnabled = false
            tCalc = false
            vCalc = false
            nCalc = false
            
            tButton.backgroundColor = GlobalConstants.pink
            vButton.backgroundColor = GlobalConstants.pink
            nButton.backgroundColor = GlobalConstants.pink
            
            pTxt.isEnabled = false
            tTxt.isEnabled = true
            vTxt.isEnabled = true
            nTxt.isEnabled = true
            
        }else if pStr != "" && vStr != "" && nStr != ""{
            //tButton.isEnabled = true
            tCalc = true
            tButton.backgroundColor = GlobalConstants.yellow
            //instrLabel.text = "Press the Yellow Button to Calculate"
            
            //vButton.isEnabled = false
            //pButton.isEnabled = false
            //nButton.isEnabled = false
            vCalc = false
            pCalc = false
            nCalc = false
            
            vButton.backgroundColor = GlobalConstants.pink
            pButton.backgroundColor = GlobalConstants.pink
            nButton.backgroundColor = GlobalConstants.pink
            
            tTxt.isEnabled = false
            vTxt.isEnabled = true
            pTxt.isEnabled = true
            nTxt.isEnabled = true
            
        }else if pStr != "" && tStr != "" && vStr != ""{
            //nButton.isEnabled = true
            nCalc = true
            nButton.backgroundColor = GlobalConstants.yellow
            //instrLabel.text = "Press the Yellow Button to Calculate"
            
            //tButton.isEnabled = false
            //pButton.isEnabled = false
            //vButton.isEnabled = false
            tCalc = false
            pCalc = false
            vCalc = false
            
            tButton.backgroundColor = GlobalConstants.pink
            pButton.backgroundColor = GlobalConstants.pink
            vButton.backgroundColor = GlobalConstants.pink
            
            nTxt.isEnabled = false
            tTxt.isEnabled = true
            pTxt.isEnabled = true
            vTxt.isEnabled = true
            
        }else{
            instrLabel.text = "Enter any three values"
            
            pButton.isEnabled = false
            tButton.isEnabled = false
            vButton.isEnabled = false
            nButton.isEnabled = false
            
            nTxt.isEnabled = true
            tTxt.isEnabled = true
            vTxt.isEnabled = true
            pTxt.isEnabled = true
            
            tCalc = false
            pCalc = false
            nCalc = false
            vCalc = false
            
            pButton.backgroundColor = GlobalConstants.pink
            tButton.backgroundColor = GlobalConstants.pink
            vButton.backgroundColor = GlobalConstants.pink
            nButton.backgroundColor = GlobalConstants.pink
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nTxt.backgroundColor = UIColor.clear
        tTxt.backgroundColor = UIColor.clear
        vTxt.backgroundColor = UIColor.clear
        pTxt.backgroundColor = UIColor.clear
        
        if pStr == ""{
            pTxt.setTitleColor(GlobalConstants.lightpurple, for: .normal)
            pTxt.contentHorizontalAlignment = .center
            pTxt.setTitle("pressure", for: .normal)
            
        }
        if tStr == ""{
            tTxt.setTitleColor(GlobalConstants.lightpurple, for: .normal)
            tTxt.contentHorizontalAlignment = .center
            tTxt.setTitle("temperature", for: .normal)
        }
        if vStr == ""{
            vTxt.setTitleColor(GlobalConstants.lightpurple, for: .normal)
            vTxt.contentHorizontalAlignment = .center
            vTxt.setTitle("volume", for: .normal)
        }
        if nStr == ""{
            nTxt.setTitleColor(GlobalConstants.lightpurple, for: .normal)
            nTxt.contentHorizontalAlignment = .center
            nTxt.setTitle("amount", for: .normal)
        }
        
        disableCalc()
        calcButtonSetUp()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


