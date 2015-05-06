//
//  ViewController.m
//  PlayingWithCoreData
//
//  Created by Michael Vilabrera on 5/4/15.
//  Copyright (c) 2015 Giving Tree. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Person.h"
#import "AddPersonViewController.h"

static NSString *CellIdentifier = @"CellIdentifier";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIButton *addPersonButton;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createView];
}

- (NSManagedObjectContext *) managedObjectContext {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return appDelegate.managedObjectContext;
}

- (void)createView {
    CGRect tableViewFrame = CGRectMake(20, 20, 320, 550);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame];
    
    CGRect addPersonFrame = CGRectMake(20, 570, 320, 44);
    self.addPersonButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.addPersonButton.frame = addPersonFrame;
    [self.addPersonButton setTitle:@"Add Person" forState:UIControlStateNormal];
    [self.addPersonButton setTitle:@"Adding" forState:UIControlStateHighlighted];
    [self.addPersonButton addTarget:self action:@selector(addPerson) forControlEvents:UIControlEventTouchDown];
    
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addPersonButton];
}

- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void) controller:(NSFetchedResultsController *)controller
    didChangeObject:(id)anObject
        atIndexPath:(NSIndexPath *)indexPath
      forChangeType:(NSFetchedResultsChangeType)type
       newIndexPath:(NSIndexPath *)newIndexPath
{
    if (type == NSFetchedResultsChangeDelete) {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (type == NSFetchedResultsChangeInsert) {
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void) addPerson
{
    AddPersonViewController *addPersonVC = [[AddPersonViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:addPersonVC animated:YES completion:nil];
}

#pragma mark -- UITableView methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Person *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [person.firstName stringByAppendingFormat:@"%@", person.lastName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Age: %lu", (unsigned long)[person.age unsignedIntegerValue]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return sectionInfo.numberOfObjects;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Person *toDelete = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [[self managedObjectContext] deleteObject:toDelete];
    
    if ([toDelete isDeleted]) {
        NSError *savingError = nil;
        if ([[self managedObjectContext] save:&savingError]) {
            NSLog(@"Successfully deleted the object");
        } else {
            NSLog(@"Failed to save the context. Error: %@", savingError);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
