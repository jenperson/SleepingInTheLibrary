//
//  ViewController.swift
//  SleepingInTheLibrary
//
//  Created by Jarrod Parkes on 11/3/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

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
        
        // TODO: Write the network code here!
        let url = NSURL(string: <#T##String#>)
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