//
//  File.swift
//  
//
//  Created by George Drag on 1/29/18.
//

import Foundation
import JSQMessagesViewController
import Kingfisher

class AsyncPhotoMediaItem: JSQPhotoMediaItem {
    var asyncImageView: UIImageView!
    
    override init!(maskAsOutgoing: Bool) {
        super.init(maskAsOutgoing: maskAsOutgoing)
    }
    
    init(withURL url: NSURL, imageSize: CGSize, isOperator: Bool) {
        super.init()
        appliesMediaViewMaskAsOutgoing = (isOperator == false)
        var size = (imageSize == CGSizeZero) ? super.mediaViewDisplaySize() : ImageType(withSize: imageSize).frameSize()
        let resizedImageSize = UbikHelper.resizeFrameWithSize(imageSize, targetSize: size)
        size.width = min(size.width, resizedImageSize.width)
        size.height = min(size.height, resizedImageSize.height)
        
        asyncImageView = UIImageView()
        asyncImageView.frame = CGRectMake(0, 0, size.width, size.height)
        asyncImageView.contentMode = .ScaleAspectFit
        asyncImageView.clipsToBounds = true
        asyncImageView.layer.cornerRadius = 20
        asyncImageView.backgroundColor = UIColor.jsq_messageBubbleLightGrayColor()
        
        let activityIndicator = JSQMessagesMediaPlaceholderView.viewWithActivityIndicator()
        activityIndicator.frame = asyncImageView.frame
        asyncImageView.addSubview(activityIndicator)
        
        KingfisherManager.sharedManager.cache.retrieveImageForKey(url.hashString(), options: nil) { (image, cacheType) -> () in
            
            if let image = image {
                self.asyncImageView.image = image
                activityIndicator.removeFromSuperview()
            } else {
                KingfisherManager.sharedManager.downloader.downloadImageWithURL(url, progressBlock: nil) { (image, error, imageURL, originalData) -> () in
                    
                    if let image = image {
                        self.asyncImageView.image = image
                        activityIndicator.removeFromSuperview()
                        
                        KingfisherManager.sharedManager.cache.storeImage(image, forKey: url.hashString(), toDisk: true, completionHandler: nil)
                    }
                }
            }
        }
    }
    
    override func mediaView() -> UIView! {
        return asyncImageView
    }
    
    override func mediaViewDisplaySize() -> CGSize {
        return asyncImageView.frame.size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
