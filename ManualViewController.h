//
//  ManualViewController.h
//  HueAutomate
//
//  Created by Deep Pradhan on 4/13/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HueSDK_iOS/HueSDK.h>

@interface ManualViewController : UIViewController
{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
}
@property (weak, nonatomic) IBOutlet UISlider *sliderLabel;
@property (weak, nonatomic) IBOutlet UILabel *sliderData;
@property (weak, nonatomic) IBOutlet UISlider *sliderGreen;

@property (weak, nonatomic) IBOutlet UISlider *sliderBlue;

@end
