//
//  ViewController.swift
//  Twitter_Sentiment_Prediction
//
//  Created by Sai Naveen Katla on 06/11/20.
//

import UIKit
import SwifteriOS
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var sentimentLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var TextField: UITextField!
    
    let sentiClassifier = tweetSentiModel()
    
    let tweetCount = 100
    
    var bgView: UIView!
    
    let swifter = Swifter(consumerKey: Constants.consumerKey, consumerSecret: Constants.consumerSecret)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgView = view
        
        TextField.delegate = self
    }
    
    //Hide the keyboard when tapped anywhere on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func getTwitterData(_ sender: Any) {
        if let text = TextField.text {
            //fetching tweets
            swifter.searchTweet(using: text, lang: "en", count: tweetCount, tweetMode: .extended, success: { [weak self] (data, metadata) in
                var tweets = [tweetSentiModelInput]()
                //            print(data)
                for i in 0..<self!.tweetCount {
                    if let tweet = data[i]["full_text"].string {
                        let tweetInput = tweetSentiModelInput(text: tweet)
                        tweets.append(tweetInput)
                    }
                }
                do {
                    //making the prediction
                    let prediction = try self!.sentiClassifier.predictions(inputs: tweets)
                    var score = 0
                    for pred in prediction {
                        switch pred.label {
                        case "Pos":
                            score += 1
                        case "Neg":
                            score -= 1
                        case "Neutral":
                            score += 0
                        default:
                            score += 0
                        }
                    }
                    //setting the emoji
                    self?.setEmoji(num: score)
                    self?.scoreLabel.text = "Score: \(score)"
                }
                catch {
                    print(error)
                }
                
                
            }) { (error) in
                print("the error- \(error)")
            }
        }
    }
    
    func setEmoji(num: Int) {
        switch true {
        case num > 20:
            sentimentLabel.text = "🥰"
            bgView.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        case num > 10:
            sentimentLabel.text = "☺️"
            bgView.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        case num > 0:
            sentimentLabel.text = "🙃"
            bgView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        case num > -10:
            sentimentLabel.text = "😒"
            bgView.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        case num > -20:
            sentimentLabel.text = "😞"
            bgView.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        default:
            sentimentLabel.text = "🙃"
        }
    }


}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getTwitterData(self)
        return true
    }
    
}

