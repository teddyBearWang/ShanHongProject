//
//  SettingViewController.m
//  ShanHongProject
//
//  Created by teddy on 15/7/2.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *setBtn;

- (IBAction)changeAccountAction:(id)sender;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BG_COLOR;
    
    self.setBtn.layer.cornerRadius = 5.0;
    self.setBtn.layer.borderWidth = 0.5;
    self.setBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)changeAccountAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
