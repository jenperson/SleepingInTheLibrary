//
//  ViewController.swift
//  SleepingInTheLibrary
//
//  Created by Jarrod Parkes on 11/3/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit
import Foundation

// MARK: - ViewController: UIViewController

class ViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoTitleLabel: UILabel!
    @IBOutlet weak var grabImageButton: UIButton!
    
    // MARK: Actions
    
    @IBAction func grabNewImage(sender: AnyObject) {
        setUIEnabled(false)
        getImageFromFlickr()
    }
    
    // MARK: Configure UI
    
    private func setUIEnabled(enabled: Bool) {
        photoTitleLabel.enabled = enabled
        grabImageButton.enabled = enabled
        
        if enabled {
            grabImageButton.alpha = 1.0
        } else {
            grabImageButton.alpha = 0.5
        }
    }
    
    // MARK: Make Network Request
    
    private func getImageFromFlickr() {
        
        let methodParameters = [
            Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.GalleryPhotosMethod,
            Constants.FlickrParameterKeys.APIKey : Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.GalleryID : Constants.FlickrParameterValues.GalleryID,
            Constants.FlickrParameterKeys.Extras : Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.Format : Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NoJSONCallback : Constants.FlickrParameterValues.DisableJSONCallback]
        
        let urlString = Constants.Flickr.APIBaseURL + escapedParameters(methodParameters)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ (data, response, error) in
            // if no error is found
            if error == nil {
                // unwrap data found
                if let data = data {
                    
                    let parsedResult : AnyObject!
                    do  {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                    } catch {
                        //displayError("Could not parse the data as JSON: '\(data)' ")
                        print("Could not parse the data as JSON: '\(data)' ")
                        return
                    }
                    
                    // unwrapping value in case a dictionary/key value isn't found
                    if let photosDictionary =
                        parsedResult[Constants.FlickrResponseKeys.Photos] as? [String:AnyObject],
                            photoArray = photosDictionary["photo"] as?
                                [[String:AnyObject]] {
                                    
                            // choose a random member of the array
                            let randomPhotoIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
                            let photoDictionary = photoArray[randomPhotoIndex] as [String:AnyObject]
                            
                            // get the image URL and photo title from the random member of the array
                            if let imageURLString = photoDictionary[Constants.FlickrResponseKeys.MediumURL] as? String,
                                let photoTitle = photoDictionary[Constants.FlickrResponseKeys.Title] as? String {
                                    
                                    // show the image in the image view
                                    let imageURL = NSURL(string: imageURLString)
                                    if let imageData = NSData(contentsOfURL: imageURL!){
                                        
                                        performUIUpdatesOnMain(){
                                            self.photoImageView.image = UIImage(data: imageData)
                                            self.photoTitleLabel.text = photoTitle
                                            // so user can grab another image if desired
                                            self.setUIEnabled(true)
                                        }
                                    }
                                }
                                    
                                    
                    }
                    
                }
            }
        }
        
        task.resume()
        
    }

    private func escapedParameters(parameters: [String:AnyObject]) -> String {
        
        // if a parameter isn't found, assign it a blank string
        if parameters.isEmpty {
            return ""
        } else {
            // if a parameter is found
            var keyValuePairs = [String]()
            
            for (key, value) in parameters {
                
                // make sure all returned values are strings
                let stringValue = "\(value)"
                
                // escape it -- converts string to ASCII URL compliant string
                let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                
                // append it to the array
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
            }
            
            // return the array with & in between to build the URL
            return "?\(keyValuePairs.joinWithSeparator("&"))"
            
        }
    }
    
}