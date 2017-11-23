//
//  ViewController.h
//  NJULoginMac
//
//  Created by 宋 奎熹 on 2016/12/18.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (weak, nonatomic) IBOutlet NSTextField *usernameText;
@property (weak, nonatomic) IBOutlet NSTextField *passwordText;
@property (weak, nonatomic) IBOutlet NSButton *actionButton;
@property (weak, nonatomic) IBOutlet NSTextView *logView;

@end

