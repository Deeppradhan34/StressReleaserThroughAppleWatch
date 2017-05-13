//
//  ViewController.h
//  HueAutomate
//
//  Created by Deep Pradhan on 4/13/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PHBridgeSelectionViewController.h"
#import "PHBridgePushLinkViewController.h"
#import <HueSDK_iOS/HueSDK.h>

@class PHHueSDK;

@interface ViewController :UIViewController <UIApplicationDelegate, UIAlertViewDelegate, PHBridgeSelectionViewControllerDelegate, PHBridgePushLinkViewControllerDelegate>

@property (strong, nonatomic) PHHueSDK *phHueSDK;

/**
 Starts the local heartbeat
 */
- (void)enableLocalHeartbeat;

/**
 Stops the local heartbeat
 */
- (void)disableLocalHeartbeat;

/**
 Starts a search for a bridge
 */
- (void)searchForBridgeLocal;

- (void)localConnection;


@property (weak, nonatomic) IBOutlet UILabel *bridgeIDLabel;

@property (weak, nonatomic) IBOutlet UILabel *bridgeIPLabel;

@end

