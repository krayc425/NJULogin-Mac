//
//  AppDelegate.m
//  NJULoginMac
//
//  Created by 宋 奎熹 on 2016/12/18.
//  Copyright © 2016年 宋 奎熹. All rights reserved.
//

#import "AppDelegate.h"
#import "Carbon/Carbon.h"
#import "LoginManager.h"
#import "TouchBar.h"
#import <ServiceManagement/ServiceManagement.h>
#import "TouchButton.h"
#import "TouchDelegate.h"
#import <Cocoa/Cocoa.h>

static const NSTouchBarItemIdentifier njuTouchBarIdentifier = @"krayc.njulogin";

@interface AppDelegate () <TouchDelegate>

@end

@implementation AppDelegate

NSButton *touchBarButton;

@synthesize statusBar;

TouchButton *button;

NSString *STATUS_ICON_BLACK = @"tray-unactive-black";

//用于保存快捷键事件回调的引用，以便于可以注销
static EventHandlerRef g_EventHandlerRef = NULL;

//用于保存快捷键注册的引用，便于可以注销该快捷键
static EventHotKeyRef a_HotKeyRef = NULL;
static EventHotKeyRef b_HotKeyRef = NULL;

//快捷键注册使用的信息，用在回调中判断是哪个快捷键被触发
static EventHotKeyID a_HotKeyID = {'keyA',1};
static EventHotKeyID b_HotKeyID = {'keyB',2};

//快捷键的回调方法
OSStatus myHotKeyHandler(EventHandlerCallRef inHandlerCallRef, EventRef inEvent, void *inUserData){
    //判定事件的类型是否与所注册的一致
    if (GetEventClass(inEvent) == kEventClassKeyboard && GetEventKind(inEvent) == kEventHotKeyPressed){
        //获取快捷键信息，以判定是哪个快捷键被触发
        EventHotKeyID keyID;
        GetEventParameter(inEvent,
                          kEventParamDirectObject,
                          typeEventHotKeyID,
                          NULL,
                          sizeof(keyID),
                          NULL,
                          &keyID);
        if (keyID.id == a_HotKeyID.id) {
            NSLog(@"Key Login");
            [LoginManager loginWithUserName:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]
                                andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]];
        }
        if (keyID.id == b_HotKeyID.id) {
            NSLog(@"Key Logout");
            [LoginManager logout];
        }
    }
    return noErr;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    self.mainWindow = [[[NSApplication sharedApplication] windows] objectAtIndex:0];
    
    [[self.mainWindow standardWindowButton:NSWindowZoomButton] setHidden:YES];
    [[self.mainWindow standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
    
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [_statusItem setImage:[NSImage imageNamed:@"Status_Bar"]];
    [_statusItem setHighlightMode:YES];
    [_statusItem setAction:@selector(onStatusItemClicked:)];
    [_statusItem setTarget:self];
    
    //先注册快捷键的事件回调
    EventTypeSpec eventSpecs[] = {{kEventClassKeyboard,kEventHotKeyPressed}};
    InstallApplicationEventHandler(NewEventHandlerUPP(myHotKeyHandler),
                                   GetEventTypeCount(eventSpecs),
                                   eventSpecs,
                                   NULL,
                                   &g_EventHandlerRef);
    
    //注册快捷键:option+P
    RegisterEventHotKey(kVK_ANSI_P,
                        optionKey,
                        a_HotKeyID,
                        GetApplicationEventTarget(),
                        0,
                        &a_HotKeyRef);
    
    //注册快捷键:shift+option+P
    RegisterEventHotKey(kVK_ANSI_P,
                        shiftKey|optionKey,
                        b_HotKeyID,
                        GetApplicationEventTarget(),
                        0,
                        &b_HotKeyRef);
    
    // 注册 TouchBar
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    NSImage* statusImage = [NSImage imageNamed:STATUS_ICON_BLACK];
    statusImage.size = NSMakeSize(18, 18);
    
    // allows cocoa to change the background of the icon
    [statusImage setTemplate:YES];
    
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    self.statusBar.image = statusImage;
    self.statusBar.highlightMode = YES;
    self.statusBar.enabled = YES;
    
    DFRSystemModalShowsCloseBoxWhenFrontMost(YES);
    NSCustomTouchBarItem *njuTouchBarItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:njuTouchBarIdentifier];
    
    NSImage *njuImage = [NSImage imageNamed:@"P"];
    button = [TouchButton buttonWithImage:njuImage target:nil action:nil];
    [button setBezelColor:NJU_COLOR];
    [button setDelegate:self];
    njuTouchBarItem.view = button;
    
    touchBarButton = button;
    
    [NSTouchBarItem addSystemTrayItem:njuTouchBarItem];
    DFRElementSetControlStripPresenceForIdentifier(njuTouchBarIdentifier, YES);
}

- (void)onStatusItemClicked:(id)sender{
    [self.mainWindow makeKeyAndOrderFront:self];
}

- (void)applicationWillTerminate:(NSNotification *)notification{
    //注销快捷键
    if (a_HotKeyRef){
        UnregisterEventHotKey(a_HotKeyRef);
        a_HotKeyRef = NULL;
    }
    if (b_HotKeyRef){
        UnregisterEventHotKey(b_HotKeyRef);
        b_HotKeyRef = NULL;
    }
    //注销快捷键的事件回调
    if (g_EventHandlerRef){
        RemoveEventHandler(g_EventHandlerRef);
        g_EventHandlerRef = NULL;
    }
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] removeAllDeliveredNotifications];
}

- (void)onPressed:(TouchButton*)sender{
    NSLog(@"Pressed");
    [LoginManager loginWithUserName:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]
                        andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]];
}

- (void)onLongPressed:(TouchButton*)sender {
    NSLog(@"Long Pressed");
    [LoginManager logout];
}

@end
