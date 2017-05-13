//
//  AutomaticViewController.m
//  HueAutomate
//
//  Created by Deep Pradhan on 4/13/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "AutomaticViewController.h"

@interface AutomaticViewController ()

@end

@implementation AutomaticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"Automatic";
     self.heartRateLabel.text=@" ";
    // Do any additional setup after loading the view.
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
- (IBAction)doneButton:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)checkHeartRates:(id)sender {
   
    heartrate_Array=[[NSMutableArray alloc]init];
    for(int i=0;i<30;i++)
    {
         static int count=30;
        [heartrate_Array addObject:[NSNumber numberWithInt:count]];
        count=count+5;
        
    }
    [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(get_HeartBeatsColor) userInfo:nil repeats:YES];
    
}
-(void)get_HeartBeatsColor
{
    
    //code to get age from Health kit for putting heart rate values
    //set color according to heart rate and age
    static int count1=0;
    id data=[heartrate_Array objectAtIndex:count1];
    
    int heartRates=[data intValue];
    NSString *data1=[NSString stringWithFormat:@"%d",heartRates];
    self.heartRateLabel.text=data1;
    
    if(heartRates>30&&heartRates<=40)//heart beats during sleep, yellow color gives us deep sleep
    {
        
        PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
        PHBridgeSendAPI *bridgeSendAPI = [[PHBridgeSendAPI alloc] init];
        
        for (PHLight *light in cache.lights.allValues) {
            
            PHLightState *lightState = [[PHLightState alloc] init];
            double X = 0.4432 - ((0.4432 - 0.139)/(40-30))*(heartRates - 30);
            double Y = 0.5154 - ((0.5154 - 0.081)/(40-30))*(heartRates - 30);
            NSNumber *x=[NSNumber numberWithDouble:X];
            [lightState setX:x];
            NSNumber *y=[NSNumber numberWithDouble:Y];
            [lightState setY:y];
            
            
            // [lightState setHue:[NSNumber numberWithInt:12750]];
            [lightState setBrightness:[NSNumber numberWithInt:80]];
            [lightState setSaturation:[NSNumber numberWithInt:254]];
            
            // Send lightstate to light
            [bridgeSendAPI updateLightStateForId:light.identifier withLightState:lightState completionHandler:^(NSArray *errors) {
                if (errors != nil) {
                    NSString *message = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Errors", @""), errors != nil ? errors : NSLocalizedString(@"none", @"")];
                    
                    NSLog(@"Response: %@",message);
                }
                
                
            }];
        }
        
        
    }
    
    else if(heartRates>=50&&heartRates<=70)//heart beats for relaxation, blue color helps us to become cooler and calm
    {
        
        PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
        PHBridgeSendAPI *bridgeSendAPI = [[PHBridgeSendAPI alloc] init];
        
        for (PHLight *light in cache.lights.allValues) {
            
            
            PHLightState *lightState = [[PHLightState alloc] init];
            double X = 0.139 - ((0.139 - 0.3787)/(70-50))*(heartRates - 50);
            double Y = 0.081 - ((0.081 - 0.1724)/(70-50))*(heartRates - 50);
            NSNumber *x=[NSNumber numberWithDouble:X];
            [lightState setX:x];
            NSNumber *y=[NSNumber numberWithDouble:Y];
            [lightState setY:y];
            [lightState setBrightness:[NSNumber numberWithInt:254]];
            [lightState setSaturation:[NSNumber numberWithInt:254]];
            
            // Send lightstate to light
            [bridgeSendAPI updateLightStateForId:light.identifier withLightState:lightState completionHandler:^(NSArray *errors) {
                if (errors != nil) {
                    NSString *message = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Errors", @""), errors != nil ? errors : NSLocalizedString(@"none", @"")];
                    
                    NSLog(@"Response: %@",message);
                }
                
                        }];
        }
    }
    else if(heartRates>70&&heartRates<=155)//heart beats during anger, Pink color helps to come up with ANGER
    {
        
        PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
        PHBridgeSendAPI *bridgeSendAPI = [[PHBridgeSendAPI alloc] init];
        
        for (PHLight *light in cache.lights.allValues) {
            
            PHLightState *lightState = [[PHLightState alloc] init];
          
            double X = 0.3787 - ((0.3787 - 0.2703)/(155-70))*(heartRates - 70);
            double Y = 0.1274 - ((0.1724 - 0.1398)/(155-70))*(heartRates - 70);
            NSNumber *x=[NSNumber numberWithDouble:X];
            [lightState setX:x];
            NSNumber *y=[NSNumber numberWithDouble:Y];
            [lightState setY:y];
            
            [lightState setBrightness:[NSNumber numberWithInt:254]];
            [lightState setSaturation:[NSNumber numberWithInt:254]];
            
            // Send lightstate to light
            [bridgeSendAPI updateLightStateForId:light.identifier withLightState:lightState completionHandler:^(NSArray *errors) {
                if (errors != nil) {
                    NSString *message = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Errors", @""), errors != nil ? errors : NSLocalizedString(@"none", @"")];
                    
                    NSLog(@"Response: %@",message);
                }
                
                            }];
        }
        
        
    }
    
    
    else if(heartRates>=156)//when doing exercise, web purple gives relaxation
    {
         PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
        PHBridgeSendAPI *bridgeSendAPI = [[PHBridgeSendAPI alloc] init];
        
        for (PHLight *light in cache.lights.allValues) {
            if(count1==27)
                break;
            
            PHLightState *lightState = [[PHLightState alloc] init];
            NSNumber *x=[NSNumber numberWithDouble:0.2703];
            [lightState setX:x];
            NSNumber *y=[NSNumber numberWithDouble:0.1398];
            [lightState setY:y];
           
            [lightState setBrightness:[NSNumber numberWithInt:100]];
            [lightState setSaturation:[NSNumber numberWithInt:254]];
            
            // Send lightstate to light
            [bridgeSendAPI updateLightStateForId:light.identifier withLightState:lightState completionHandler:^(NSArray *errors) {
                if (errors != nil) {
                    NSString *message = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Errors", @""), errors != nil ? errors : NSLocalizedString(@"none", @"")];
                    
                    NSLog(@"Response: %@",message);
                }
                
               
            }];
        }
        
        
    }
    count1++;
    
}



@end
