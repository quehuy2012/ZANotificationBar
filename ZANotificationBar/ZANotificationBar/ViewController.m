//
//  ViewController.m
//  ZANotificationBar
//
//  Created by CPU11713 on 4/26/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

#import "ViewController.h"
#import "ZANotificationBar.h"

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *notificationTitle;
@property (weak, nonatomic) IBOutlet UITextField *notificationMessage;
@property (weak, nonatomic) IBOutlet UITextField *soundName;
@property (weak, nonatomic) IBOutlet UITextField *soundType;

@property (weak, nonatomic) IBOutlet UISwitch *sound;
@property (weak, nonatomic) IBOutlet UISwitch *vibrate;
@property (weak, nonatomic) IBOutlet UISwitch *notificationAction;

@property (weak, nonatomic) IBOutlet UILabel *timeOutLabel;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UISegmentedControl *notificationBarType;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    
    [self.view addGestureRecognizer:tapGesture];
}

- (IBAction)showNotification:(UIButton *)sender {
    ZANotificationStyle style = self.notificationBarType.selectedSegmentIndex == 0 ? ZANotificationStyleDetail : ZANotificationStyleSimple;
    
    ZANotificationBarController *notificationBar = [[ZANotificationBarController alloc] initWithTitle:self.notificationTitle.text message:self.notificationMessage.text preferredStyle:style handler:^(BOOL finished) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Handler" message:@"Catch didSelectNotification action in ZANotificationBarController completion handler" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
    if (self.notificationAction.isOn) {
        // Type: Cancel
        ZANotifyAction *cancelAction = [[ZANotifyAction alloc] initWithTitle:@"Cancel" type:ZANotificationActionTypeCancel handler:^(ZANotifyAction *action) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:action.actionTitle message:@"Apply a style that indicates the action cancels the opration and leaves things unchanged" preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }];
        [notificationBar addAction:cancelAction];
        
        // Type: Destructive
        ZANotifyAction *destructiveAction = [[ZANotifyAction alloc] initWithTitle:@"Destructive" type:ZANotificationActionTypeDestructive handler:^(ZANotifyAction *action) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:action.actionTitle message:@"Apply a style that indicates the action might change or delete data." preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }];
        [notificationBar addAction:destructiveAction];
        
        // Type: Default
        ZANotifyAction *defaultAction = [[ZANotifyAction alloc] initWithTitle:@"Default" type:ZANotificationActionTypeDefault handler:^(ZANotifyAction *action) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:action.actionTitle message:@"Apply a default style to the action's button" preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }];
        [notificationBar addAction:defaultAction];
        
        // Type: TextInput
        ZANotifyAction *textInputAction = [[ZANotifyAction alloc] initWithTitle:@"Text Input" type:ZANotificationActionTypeTextInput handler:^(ZANotifyAction *action) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:action.actionTitle message:[NSString stringWithFormat:@"Response string: %@", action.textResponse] preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }];
        [notificationBar addAction:textInputAction];
    }
    
    notificationBar.displayDuration = self.stepper.value;
    
    if (self.sound.isOn) {
        [notificationBar notificationSoundWithName:self.soundName.text ofType:self.soundType.text vibrate:self.vibrate.isOn];
    }
}

- (void)hideKeyboard:(UIButton *)sender {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
