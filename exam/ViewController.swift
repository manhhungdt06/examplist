//
//  ViewController.swift
//  exam
//
//  Created by Techmaster on 11/19/16.
//  Copyright © 2016 Techmaster. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nationTextField: UITextField!
    
    @IBOutlet weak var capitalTextField: UITextField!
    
    @IBOutlet weak var popNum: UITextField!
    
    //    @IBOutlet weak var textTest: UITextView!
    
    var viewBgr: UIView!
    var backView: UIView!
    
    // detail text for file data
    var wordText: UITextView!
    var typeText: UITextView!
    var pronunText: UITextView!
    var sentenText: UITextView!
    var meanText: UITextView!
    
    var front: UIImageView!
    var back: UIImageView!
    var isFront = true
    
    var keyArr: [String] = []
    var keyArrDetail: [String] = []
    var word: String = ""
    var sente: String = ""
    var type: String = ""
    var mean: String = ""
    var vocal: String = ""
    var img: String = ""
    var audio: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        displayNationAndCapitalCityNames()
        self.nationTextField.delegate = self
        self.capitalTextField.delegate = self
        self.nationTextField.becomeFirstResponder()
        
        let docDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = docDirectory.appending("/items.plist")
        let data = NSMutableDictionary(contentsOfFile: path)
        
        print("items.plist data = \(path)")
        for key in (data?.allKeys)! {
            keyArr.append(key as! String)
            if (key as! String) == "balance" {
                word = key as! String
                let dictDetail = data?[key] as! NSDictionary
                
                for keyDetail in dictDetail.allKeys {
                    keyArrDetail.append(keyDetail as! String)
                }
                
                sente = dictDetail["sentence"] as! String
                type = dictDetail["type"] as! String
                mean = dictDetail["meaning"] as! String
                vocal = dictDetail["vocalization"] as! String
                img = dictDetail["image"] as! String
                audio = dictDetail["sound"] as! String
            }
        }
        
        print("keyArr = \(keyArr)")
        print("keyArrDetail = \(keyArrDetail)")
        
        wordText = UITextView(frame: CGRect(x: 8, y: 9, width: 328, height: 101))
        createText(wordText, word, UIColor.init(red: 78/255, green: 153/255, blue: 96/255, alpha: 1), UIFont.init(name: "MarkerFelt-Wide", size: 40)!)
        
        typeText = UITextView(frame: CGRect(x: 8, y: 118, width: 100, height: 51))
        createText(typeText, type, UIColor.init(red: 255/255, green: 142/255, blue: 93/255, alpha: 1), UIFont.init(name: "Menlo-Regular", size: 19)!)
        
        pronunText = UITextView(frame: CGRect(x: 116, y: 118, width: 220, height: 51))
        createText(pronunText, vocal, UIColor.init(red: 62/255, green: 188/255, blue: 255/255, alpha: 1), UIFont.init(name: "Menlo-Regular", size: 19)!)
        
        sentenText = UITextView(frame: CGRect(x: 8, y: 177, width: 328, height: 114))
        createText(sentenText, sente, UIColor.init(red: 147/255, green: 139/255, blue: 153/255, alpha: 1), UIFont.init(name: "HelveticaNeue-Italic", size: 20)!)
        
        isFront = true
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapped))
        singleTap.numberOfTapsRequired = 1
        
        let rect = CGRect(x: 16, y: 100, width: 344, height: 299)
        let rect2 = CGRect(x: 0, y: 0, width: 344, height: 299)
        let rect1 = CGRect(x: 8, y: 9, width: 344, height: 230)
        
        if self.viewBgr != nil {
            self.viewBgr.removeFromSuperview()
        }
        
        viewBgr = UIView(frame: rect)
        backView = UIView(frame: rect2)
        let backImg = img
        let backImgPath = fileInDocumentsDirectory(filename: backImg)
        
        if let loadedBackImg = loadImageFromPath(path: backImgPath) {
            print(" Loaded Image: \(loadedBackImg)")
            back = UIImageView(frame: rect1)
            
            let newBackImg = ResizeImage(image: loadedBackImg, targetSize: CGSize(width: 344, height: 230))
            back = UIImageView(image: newBackImg)
            
            meanText = UITextView(frame: CGRect(x: 8, y: 209, width: 328, height: 82))
            createText(meanText, mean, UIColor.init(red: 147/255, green: 192/255, blue: 145/255, alpha: 1), UIFont.init(name: "HelveticaNeue-Italic", size: 40)!)
            
            backView.addSubview(back)
            backView.addSubview(meanText)
        } else {
            print("some error message 2")
        }
        
        
        
        viewBgr.addGestureRecognizer(singleTap)
        viewBgr.isUserInteractionEnabled = true
        viewBgr.addSubview(wordText)
        viewBgr.addSubview(typeText)
        viewBgr.addSubview(pronunText)
        viewBgr.addSubview(sentenText)
        
        view.addSubview(viewBgr)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Get Path
    func getPath() -> String {
        let plistFileName = "data.plist"
        //        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let paths = "/Users/techmaster/examplist/exam"
        let documentPath = paths as NSString
        let plistPath = documentPath.appendingPathComponent(plistFileName)
        
        return plistPath
    }
    
    //Display Nation and Capital
    func displayNationAndCapitalCityNames() {
        let plistPath = self.getPath()
        print("plistPath display = \(plistPath)")
        if FileManager.default.fileExists(atPath: plistPath) {
            if let nationAndCapitalCitys = NSMutableDictionary(contentsOfFile: plistPath) {
                for (_, element) in nationAndCapitalCitys.enumerated() {
                    print("zzz: \(element.key) --> \(element.value) \n")
                }
            }
        }
    }
    
    func getDocumentsURL() -> NSURL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        print("documentsURL = \(documentsURL)")
        return documentsURL as NSURL
    }
    
    func fileInDocumentsDirectory(filename: String) -> String {
        
        let fileURL = getDocumentsURL().appendingPathComponent(filename)
//        print("fileURL path = \(fileURL!.path)")
        return fileURL!.path
        
    }
    
    @IBAction func readData(_ sender: UIButton) {
        
        var data : [String: String] = [:]
        let fileExam = FileManager.default
        let docDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = docDirectory.appending("/exam.plist")
        let path1 = docDirectory.appending("/exam1.plist")
        let path2 = docDirectory.appending("/exam2.plist")
        print("pathCity = \(path)")
        if (!fileExam.fileExists(atPath: path)) {
            
            if capitalTextField.text! == "" && nationTextField.text! == "" {
                print("Oops, can't empty this field")
            } else {
                data[capitalTextField.text!] = nationTextField.text!
                
                let someData = NSDictionary(dictionary: data)
                let isWritten = someData.write(toFile: path, atomically: true)
                print("is the file created: \(isWritten)")
                
                /* rewrite data not append Dict */
                
                let piePrice:Dictionary<String,Double> = [
                    "Apple":3.99,"Raspberry":0.35
                ]
                
                var examData1:[String: NSDictionary] = [:]
                examData1["accomplish"] =  piePrice as NSDictionary
                let someData1 = NSDictionary(dictionary: examData1)
                someData1.write(toFile: path2, atomically: true)
            }
            
        }
        else {
            let data = NSMutableDictionary(contentsOfFile: path)
            
            data?[capitalTextField.text!] = nationTextField.text!
            data?.write(toFile: path, atomically: true)

            var textInput: Dictionary<String,String> = [:]
            textInput["city"] = nationTextField.text!
            textInput["capital"] = capitalTextField.text!
            
            // if file exist
            let data2 = NSMutableDictionary(contentsOfFile: path2)
            data2?[popNum.text as Any] = textInput as NSDictionary
            data2?.write(toFile: path2, atomically: true)
            for dataKey in (data2?.allKeys)! {
                print("data2 keys = \(dataKey)")
            }
            // exam 1
            let examData:[String: NSDictionary] = [
                "abandon": data!
            ]
            let someData = NSDictionary(dictionary: examData)
            someData.write(toFile: path1, atomically: true)
            print("Exist File")
        }
        capitalTextField.text = ""
        nationTextField.text = ""
 
        
        
    }
    func createText(_ textField: UITextView,_ text: String,_ color: UIColor,_ font: UIFont) {
        textField.text = text
        textField.font = font
        textField.backgroundColor = color
        textField.textAlignment = .center
        textField.isEditable = false
    }
    @IBAction func exportData(_ sender: UIButton) {

    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        
        if image == nil {
            
            print("missing image at: \(path)")
        }
        return image
    }
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 8, y: 9, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func tapped() {
        if (isFront) {
            UIView.transition(from: wordText, to: backView, duration: 1, options: UIViewAnimationOptions.transitionFlipFromRight, completion: nil)
        } else {
            UIView.transition(from: backView, to: wordText, duration: 1, options: UIViewAnimationOptions.transitionFlipFromLeft, completion: nil)
        }
        isFront = !isFront
    }
}



