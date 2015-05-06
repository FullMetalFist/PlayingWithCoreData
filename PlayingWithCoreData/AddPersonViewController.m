//
//  AddPersonViewController.m
//  PlayingWithCoreData
//
//  Created by Michael Vilabrera on 5/6/15.
//  Copyright (c) 2015 Giving Tree. All rights reserved.
//

#import "AddPersonViewController.h"
#import "AppDelegate.h"
#import "Person.h"

@interface AddPersonViewController ()

@property (nonatomic) UITextField *firstNameTextField;
@property (nonatomic) UITextField *lastNameTextField;
@property (nonatomic) UITextField *ageTextField;
@property (nonatomic) UIButton *saveButton;
@property (nonatomic) UIButton *cancelButton;

@end

@implementation AddPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createViews];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.firstNameTextField becomeFirstResponder];
}

- (void) createNewPerson:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    
    Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:managedObjectContext];
    
    if (person) {
        person.firstName = self.firstNameTextField.text;
        person.lastName = self.lastNameTextField.text;
        person.age = @([self.ageTextField.text integerValue]);
        
        NSError *savingError = nil;
        
        if ([managedObjectContext save:&savingError]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            NSLog(@"Failed to save the managed object context");
        }
    } else {
        NSLog(@"Failed to create new person object");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createViews{
    CGRect firstNameFrame = CGRectMake(20, 20, 320, 40);
    self.firstNameTextField = [[UITextField alloc] initWithFrame:firstNameFrame];
    self.firstNameTextField.placeholder = @"First Name";
    self.firstNameTextField.borderStyle = UITextBorderStyleLine;
    
    CGRect lastNameFrame = CGRectMake(20, 80, 320, 40);
    self.lastNameTextField = [[UITextField alloc] initWithFrame:lastNameFrame];
    self.lastNameTextField.placeholder = @"Last Name";
    self.lastNameTextField.borderStyle = UITextBorderStyleLine;
    
    CGRect ageFrame = CGRectMake(20, 140, 320, 40);
    self.ageTextField = [[UITextField alloc] initWithFrame:ageFrame];
    self.ageTextField.placeholder = @"Age";
    self.ageTextField.borderStyle = UITextBorderStyleLine;
    
    CGRect saveButtonFrame = CGRectMake(20, 200, 160, 40);
    self.saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.saveButton.frame = saveButtonFrame;
    [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(createNewPerson:) forControlEvents:UIControlEventTouchDown];
    
    CGRect cancelButtonFrame = CGRectMake(180, 200, 160, 40);
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cancelButton.frame = cancelButtonFrame;
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelPerson) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:self.firstNameTextField];
    [self.view addSubview:self.lastNameTextField];
    [self.view addSubview:self.ageTextField];
    [self.view addSubview:self.saveButton];
    [self.view addSubview:self.cancelButton];
}

- (void) cancelPerson {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
