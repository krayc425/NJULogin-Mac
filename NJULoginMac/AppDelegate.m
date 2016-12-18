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

@interface AppDelegate ()

@end

@implementation AppDelegate

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
            [LoginManager loginWithUserName:@"141210026" andPassword:@"songkuixi+xw7"];
        }
        if (keyID.id == b_HotKeyID.id) {
            NSLog(@"Key Logout");
            [LoginManager logout];
        }
    }
    return noErr;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    
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
    
    
    NSStatusItem *statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setImage:[NSImage imageNamed:@""]];
    [statusItem setHighlightMode:YES];
    [statusItem setAction:@selector(onStatusItemClicked:)];
    [statusItem setTarget:self];
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

@end
