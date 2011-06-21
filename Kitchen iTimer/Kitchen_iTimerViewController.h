//
//  Kitchen_iTimerViewController.h
//  Kitchen iTimer
//
//  Created by Jordan Zucker on 6/20/11.
//  Copyright 2011 University of Illinois. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Kitchen_iTimerViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    UIButton *button;
}

- (IBAction)camerachosen:(UIButton *)sender;
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;


@end
