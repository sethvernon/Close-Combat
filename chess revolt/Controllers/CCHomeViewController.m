//
//  CCHomeViewController.m
//  chess revolt-current
//
//  Created by Seth A. Vernon on 4/3/14.
//  Copyright (c) 2014 Chess Revolt by Zoya Apps. All rights reserved.
//

#import "CCHomeViewController.h"

@interface CCHomeViewController ()

@property (nonatomic, strong) NSTimer *foo;
@property (nonatomic, strong) IBOutlet UIImageView *whatEverIWant;

@property (nonatomic) int imageNumber;

@end

@implementation CCHomeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.foo = [NSTimer scheduledTimerWithTimeInterval:6
                                                target:self
                                              selector:@selector(changePic)
                                              userInfo:nil
                                               repeats:YES];
    
}


- (void)changePic
    {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            
        {
            NSArray *foo2 = @[@"DarkKnights_iPadSS.png", @"WildSquares_iPadSS.png", @"WarOfQueens_iPadSS.png"];
            self.imageNumber ++;
            if (self.imageNumber > [foo2 count]-1) self.imageNumber = 0;
            self.whatEverIWant.image = [UIImage imageNamed:[foo2 objectAtIndex:self.imageNumber]];
            
            CATransition* transition = [CATransition animation];
            transition.startProgress = 0;
            transition.endProgress = 1.0;
            transition.type = kCATransitionPush;
            
            transition.subtype = kCATransitionFromRight;
            transition.duration = 1.0;
            
            
            [UIImageView animateWithDuration:3
                                  animations:^{
                                      [self.whatEverIWant.layer addAnimation:transition forKey:@"transition"];
                                  }
                                  completion:^(BOOL finished) {
                                      [UIImageView animateWithDuration:3
                                                            animations:^{
                                                                //                                                         self.whatEverIWant.alpha = .05;
                                                                
                                                                [UIImageView animateWithDuration:3
                                                                                      animations:^{
                                                                                          //                                                                                   self.whatEverIWant.alpha = 1;
                                                                                          
                                                                                      }];
                                                            }];
                                      
                                  }];
            
            
        } else {  NSArray *foo = @[ @"DarkKnights_iPhoneSS.png", @"WildSquares_iPhoneSS.png", @"WarOfQueens_iPhoneSS.png"];
            self.imageNumber ++;
            if (self.imageNumber > [foo count]-1) self.imageNumber = 0;
            self.whatEverIWant.image = [UIImage imageNamed:[foo objectAtIndex:self.imageNumber]];
            
            CATransition* transition = [CATransition animation];
            transition.startProgress = 0;
            transition.endProgress = 1.0;
            transition.type = kCATransitionPush;
            
            transition.subtype = kCATransitionFromRight;
            transition.duration = 1.0;
            
            
            [UIImageView animateWithDuration:3
                                  animations:^{
                                      [self.whatEverIWant.layer addAnimation:transition forKey:@"transition"];
                                  }
                                  completion:^(BOOL finished) {
                                      [UIImageView animateWithDuration:2
                                                            animations:^{
                                                                //                                                         self.whatEverIWant.alpha = .05;
                                                                
                                                                [UIImageView animateWithDuration:3
                                                                                      animations:^{
                                                                                          //                                                                                   self.whatEverIWant.alpha = 1;
                                                                                          
                                                                                          
                                                                                      }];
                                                            }];
                                      
                                  }];
            
        }
        
}


    



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
