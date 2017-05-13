//
//  ManualViewController.m
//  HueAutomate
//
//  Created by Deep Pradhan on 4/13/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "ManualViewController.h"

@interface ManualViewController ()

@end

@implementation ManualViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"Manual Lights";
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
- (IBAction)greenColor:(id)sender {
    PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
    PHBridgeSendAPI *bridgeSendAPI = [[PHBridgeSendAPI alloc] init];
    
    for (PHLight *light in cache.lights.allValues) {
        
        PHLightState *lightState = [[PHLightState alloc] init];
        
        
        [lightState setHue:[NSNumber numberWithInt: 25500]];
        [lightState setBrightness:[NSNumber numberWithInt:254]];
        [lightState setSaturation:[NSNumber numberWithInt:254]];
        
        // Sen`d lightstate to light
        [bridgeSendAPI updateLightStateForId:light.identifier withLightState:lightState completionHandler:^(NSArray *errors) {
            if (errors != nil) {
                NSString *message = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Errors", @""), errors != nil ? errors : NSLocalizedString(@"none", @"")];
                
               // NSLog(@"Response: %@",message);
            }
            
            // [self.randomLightsButton setEnabled:YES];
        }];
    }
}
- (IBAction)sliderValue:(UISlider *)sender {
  //  UISlider *mySlider = [[UISlider alloc] init];
    red = [sender value];
    
}
- (IBAction)greenSlider:(UISlider *)sender {
    green = [sender value];
    
}
- (IBAction)BlueSlider:(UISlider *)sender {
    blue = [sender value];
    
}
- (IBAction)rgbValues:(id)sender {
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    CGPoint xy = [PHUtilities calculateXY:color forModel:nil];
    
    PHBridgeResourcesCache *cache = [PHBridgeResourcesReader readBridgeResourcesCache];
    PHBridgeSendAPI *bridgeSendAPI = [[PHBridgeSendAPI alloc] init];
    
    for (PHLight *light in cache.lights.allValues) {
        
        PHLightState *lightState = [[PHLightState alloc] init];
        
        [lightState setX:[NSNumber numberWithFloat:xy.x]];
        [lightState setY:[NSNumber numberWithFloat:xy.y]];
//        [lightState setHue:[NSNumber numberWithInt: 25500]];
//        [lightState setBrightness:[NSNumber numberWithInt:254]];
//        [lightState setSaturation:[NSNumber numberWithInt:254]];
        
        // Sen`d lightstate to light
        [bridgeSendAPI updateLightStateForId:light.identifier withLightState:lightState completionHandler:^(NSArray *errors) {
            if (errors != nil) {
                NSString *message = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Errors", @""), errors != nil ? errors : NSLocalizedString(@"none", @"")];
                
                // NSLog(@"Response: %@",message);
            }
            
            // [self.randomLightsButton setEnabled:YES];
        }];
    }
//    NSLog(@"%d",red);
//    NSLog(@"%d",green);
//    NSLog(@"%d",blue);
    
}




@end
