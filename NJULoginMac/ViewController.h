//
//  ViewController.h
//  NJULoginMac
//
//  Created by 宋 奎熹 on 2016/12/18.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (nonnull, nonatomic) IBOutlet NSTextField *usernameText;
@property (nonnull, nonatomic) IBOutlet NSTextField *passwordText;
@property (nonnull, nonatomic) IBOutlet NSButton *actionButton;
@property (nonnull, nonatomic) IBOutlet NSTextView *logView;

@end

