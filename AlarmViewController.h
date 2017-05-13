//
//  AlarmViewController.h
//  HueAutomate
//
//  Created by Deep Pradhan on 4/21/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HueSDK_iOS/HueSDK.h>

@interface AlarmViewController : UIViewController
{
    NSString *chosenTime;
    NSString *chosenDate;
    NSTimer *timer;
}

@property (weak, nonatomic) IBOutlet UIDatePicker *date;
@property(nonatomic,retain)NSDate *chosendate;
@property(nonatomic,retain)NSDate *chosenTime;
-(void)getCurrentTimerusingTimer;
-(void)glowLight;

@end
