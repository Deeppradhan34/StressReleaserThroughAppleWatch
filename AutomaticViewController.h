//
//  AutomaticViewController.h
//  HueAutomate
//
//  Created by Deep Pradhan on 4/13/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HueSDK_iOS/HueSDK.h>

@interface AutomaticViewController : UIViewController<UITextFieldDelegate>
{
     NSMutableArray *heartrate_Array;
}
@property (weak, nonatomic) IBOutlet UILabel *heartRateLabel;
-(void)get_HeartBeatsColor;
@end
