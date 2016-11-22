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

    
//    @IBOutlet weak var textTest: UITextView!
    
    var viewBgr: UIView!
    
    var wordText: UITextView!
    
    var front: UIImageView!
    var back: UIImageView!
    var isFront = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        displayNationAndCapitalCityNames()
        self.nationTextField.delegate = self
        self.capitalTextField.delegate = self
        
        self.nationTextField.becomeFirstResponder()
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
        print("documentsURL = \(documentsURL)")
        return documentsURL as NSURL
    }
    
    func fileInDocumentsDirectory(filename: String) -> String {
        
        let fileURL = getDocumentsURL().appendingPathComponent(filename)
        print("fileURL path = \(fileURL!.path)")
        return fileURL!.path
        
    }

    @IBAction func readData(_ sender: UIButton) {

    }
    
    @IBAction func exportData(_ sender: UIButton) {
        let plistPath = self.getPath()
        print("plistPath exportData = \(plistPath)")
        if FileManager.default.fileExists(atPath: plistPath) {
            print("Income")
            let nationAndCapitalCitys = NSMutableDictionary(contentsOfFile: plistPath)!
            if (capitalTextField.text! == "" || nationTextField.text! == "") {
                print("Oops, can't empty this field")
            } else {
                nationAndCapitalCitys.setValue(capitalTextField.text!, forKey: nationTextField.text!)
                nationAndCapitalCitys.write(toFile: plistPath, atomically: true)
            }
        }
        nationTextField.text = ""
        capitalTextField.text = ""
        displayNationAndCapitalCityNames()
        
        
        let textFile = "abandon.txt"
        let textPath = fileInDocumentsDirectory(filename: textFile)
        let fileContent = try? NSString(contentsOfFile: textPath as String, encoding: String.Encoding.utf8.rawValue)

        print(fileContent!)
        
        wordText = UITextView(frame: CGRect(x: 37, y: 8, width: 270, height: 177))
        
        wordText.text = (fileContent! as NSString) as String
        wordText.textAlignment = .center
        wordText.isEditable = false
        

//
//        
//        let contentSize = wordText.sizeThatFits(wordText.bounds.size)
//
//        var frame = wordText.frame
//        frame.size.height = contentSize.height
//        wordText.frame = frame
        
        // Define the specific path, image name
        let frontImg = "test1.png"
        let frontImgPath = fileInDocumentsDirectory(filename: frontImg)
        
        print(" imagePath: \(frontImgPath)")
        
        if let loadedFrontImg = loadImageFromPath(path: frontImgPath) {
            print(" Loaded Image: \(loadedFrontImg)")
            // 344/ 193
            front = UIImageView(image: loadedFrontImg)
        } else {
            print("some error message 2")
        }
        
        let backImg = "abandon.jpeg"
        let backImgPath = fileInDocumentsDirectory(filename: backImg)
        
        if let loadedBackImg = loadImageFromPath(path: backImgPath) {
            print(" Loaded Image: \(loadedBackImg)")
            let newBackImg = ResizeImage(image: loadedBackImg, targetSize: CGSize(width: 340, height: 190))
            
            back = UIImageView(image: newBackImg)
        } else {
            print("some error message 2")
        }
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapped))
        singleTap.numberOfTapsRequired = 1
        
        let rect = CGRect(x: 16, y: 417, width: 344, height: 193)
        
        viewBgr = UIView(frame: rect)
        viewBgr.addGestureRecognizer(singleTap)
        viewBgr.isUserInteractionEnabled = true
//        viewBgr.addSubview(front)
        viewBgr.addSubview(wordText)
        view.addSubview(viewBgr)
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        
        if image == nil {
            
            print("missing image at: \(path)")
        }
        print("Loading image from path: \(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        
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
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func tapped() {
        if (isFront) {
            UIView.transition(from: wordText, to: back, duration: 1, options: UIViewAnimationOptions.transitionFlipFromRight, completion: nil)
        } else {
            UIView.transition(from: back, to: wordText, duration: 1, options: UIViewAnimationOptions.transitionFlipFromLeft, completion: nil)
        }
        isFront = !isFront
    }
}



