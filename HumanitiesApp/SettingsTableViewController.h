//
//  SettingsTableViewController.h
//  DeleteThis
//
//  Created by Michael Dallow on 6/25/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#ifndef SettingsTableViewController_h
#define SettingsTableViewController_h

#import <UIKit/UIKit.h>
@interface SettingsTableViewController : UITableViewController

@property (nonatomic, retain) NSMutableArray *settings;

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void) viewWillAppear:(BOOL)animated;


@end



#endif /* SettingsTableViewController_h */
