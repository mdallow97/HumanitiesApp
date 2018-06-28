//
//  SettingsTableViewController.m
//  DeleteThis
//
//  Created by Michael Dallow on 6/25/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController
{
    UITableViewCell *cell;
    UITableView *tv;
}

- (UITabBarItem *)tabBarItem
{
    UITabBarItem *item;
    
    UIImage *homeImage = [UIImage imageNamed:@"Settings.png"];
    UIImage *scaled = [UIImage imageWithCGImage:[homeImage CGImage] scale:(homeImage.scale * 13) orientation:UIImageOrientationUp];
    
    item = [[UITabBarItem alloc] initWithTitle:@"Settings" image:scaled tag:0];
    
    
    return item;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.dataSource = self;
    
    
    
    self.settings = [[NSMutableArray alloc] init];
    self.settings = [NSMutableArray new];
    self.settings[0] = @"General";
    self.settings[1] = @"Permissions";
    self.settings[2] = @"Other";
    
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

// The number of sections for settings page
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = self.settings[indexPath.row];
    
    return cell;
    
}

- (void) viewWillAppear:(BOOL)animated {
    [self.tableView reloadInputViews];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








@end


