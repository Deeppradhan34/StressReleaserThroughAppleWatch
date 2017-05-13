//
//  AlarmViewController.m
//  HueAutomate
//
//  Created by Deep Pradhan on 4/21/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "AlarmViewController.h"

@interface AlarmViewController ()

@end

@implementation AlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"Alarm";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)getCurrentTimerusingTimer:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentTime = [dateFormatter stringFromDate: [NSDate date]];
    NSLog(@"%@CURRENT TIME",currentTime);
    
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDate=[dateFormatter1 stringFromDate:[NSDate date]];
    NSLog(@"%@CHOSEN TIME",chosenTime);
    
    if(([currentDate isEqualToString:chosenDate])&&([currentTime isEqualToString:chosenTime]))
    {
    
        
        NSLog(@"The date and time is equal");
        [self glowLight];
        
        //call Philips Hue Bulb
        [timer invalidate];
        timer = nil;
        
    }
    
    
}
-(void)glowLight
{
    PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
    PHBridgeSendAPI *bridgeSendAPI = [[PHBridgeSendAPI alloc] init];
    
    for (PHLight *light in cache.lights.allValues) {
        
        PHLightState *lightState = [[PHLightState alloc] init];
        
        
        [lightState setHue:[NSNumber numberWithInt: 25500]];
        [lightState setBrightness:[NSNumber numberWithInt:254]];
        [lightState setSaturation:[NSNumber numberWithInt:254]];
        
        // Send lightstate to light
        [bridgeSendAPI updateLightStateForId:light.identifier withLightState:lightState completionHandler:^(NSArray *errors) {
            if (errors != nil) {
                NSString *message = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Errors", @""), errors != nil ? errors : NSLocalizedString(@"none", @"")];
                
             
            }
            
    
        }];

}
}


- (IBAction)onClickingConfirm:(id)sender {
    timer= [NSTimer scheduledTimerWithTimeInterval:1.0
                                            target:self
                                          selector:@selector(getCurrentTimerusingTimer:)
                                          userInfo:nil
                                           repeats:YES];

}
- (IBAction)onChoosingDate:(id)sender {
    self.chosendate=[self.date date];
    
    NSDateFormatter *dateformat=[[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"HH:mm"];
    chosenTime = [dateformat stringFromDate:self.chosendate];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    chosenDate=[dateFormatter1 stringFromDate:self.chosendate];
}

@end
