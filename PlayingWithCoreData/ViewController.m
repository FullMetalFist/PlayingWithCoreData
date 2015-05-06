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
@property (nonatomic) UIBarButtonItem *addPersonBarButton;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Persons";
    
    [self createView];
    [self checkFetchRequest];
}

// check
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
    
    self.addPersonBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPerson)];
    [self.navigationItem setLeftBarButtonItem:self.editButtonItem animated:NO];
    [self.navigationItem setRightBarButtonItem:self.addPersonBarButton animated:NO];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addPersonButton];
}

- (void) checkFetchRequest
{
    // create fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    
    NSSortDescriptor *ageSort = [[NSSortDescriptor alloc] initWithKey:@"age" ascending:YES];
    NSSortDescriptor *firstNameSort = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    
    fetchRequest.sortDescriptors = @[ageSort, firstNameSort];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    
    self.fetchedResultsController.delegate = self;
    
    NSError *fetchingError = nil;
    if ([self.fetchedResultsController performFetch:&fetchingError]) {
        NSLog(@"Successfully fetched.");
    } else {
        NSLog(@"Failed to fetch");
    }
}

// check
- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

// check
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

// check
- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

// check (modified from original text)
- (void) addPerson
{
    AddPersonViewController *addPersonVC = [[AddPersonViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:addPersonVC animated:YES completion:nil];
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if (editing) {
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    } else {
//        [self.navigationItem setRightBarButtonItem:<#(UIBarButtonItem *)#> animated:YES];
    }
}

#pragma mark -- UITableView methods

// check
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Person *person = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [person.firstName stringByAppendingFormat:@" %@", person.lastName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Age: %lu", (unsigned long)[person.age unsignedIntegerValue]];
    
    return cell;
}

// check
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return sectionInfo.numberOfObjects;
}

// check
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

// check
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
