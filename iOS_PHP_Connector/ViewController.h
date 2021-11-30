//
//  ViewController.h
//  Nobu_iOS_App
//
//  Created by KNobuhara on 11/30/3 R.
//  Copyright © 3 Reiwa KNobuhara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSXMLParserDelegate> {
    IBOutlet UITextField* _userName;
    IBOutlet UITextField* _password;
    IBOutlet UILabel* _result;
    IBOutlet UILabel* _resultTitle;

    BOOL _isHtml;
    NSString* _elem;
}

- (IBAction)login:(id)sender;

@end

