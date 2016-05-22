//
//  PDFViewController.h
//  Khodro service shahr
//
//  Created by adb on 5/23/16.
//  Copyright © 2016 aDb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFViewController : UIViewController
{
    IBOutlet UIWebView *webView;
}
@property (strong, nonatomic) NSString *pdfUrl;
@end
