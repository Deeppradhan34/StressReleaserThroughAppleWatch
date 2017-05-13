//
//  LightsController.m
//  HueAutomate
//
//  Created by Deep Pradhan on 4/13/16.
//  Copyright © 2016 Philips. All rights reserved.
//

#import "LightsController.h"

@interface LightsController ()

@end

@implementation LightsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"Control Lights";
    
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
- (IBAction)onClickingManual:(id)sender {
    [self performSegueWithIdentifier:@"Manual" sender:self];
    
    
}
- (IBAction)onClickingAutomatic:(id)sender {
    [self performSegueWithIdentifier:@"Automatic" sender:self];
}
- (IBAction)onClickingAlarm:(id)sender {
    [self performSegueWithIdentifier:@"alarm" sender:self];
}

@end
