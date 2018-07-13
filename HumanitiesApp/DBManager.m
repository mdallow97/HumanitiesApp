//
//  DBManager.m
//  HumanitiesApp
//
//  Created by Ben Smith on 7/11/18.
//  Copyright © 2018 Michael Dallow. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>

@interface DBManager()

@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;
@property (nonatomic, strong) NSMutableArray *arrResults;

-(void)copyDatabaseIntoDocumentsDirectory;
-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;

@end

@implementation DBManager

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename
{
    self = [super init];
    if (self)
    {
        //set documents directory path
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        
        //keept filename
        self.databaseFilename = dbFilename;
        
        //Copy file into directory
        [self copyDatabaseIntoDocumentsDirectory];
        
    }
    return self;
}

-(NSArray *)loadDataFromDB:(NSString *)query
{
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    return (NSArray *)self.arrResults;
}

-(void)executeQuery:(NSString *)query
{
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}

-(void)copyDatabaseIntoDocumentsDirectory
{
    //Check if file exists in directory
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath])
    {
        //databasefile does not exist in directory
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
        
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        
        //check if error
        if (error != nil)
        {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}

-(void)runQuery:(const char*)query isQueryExecutable:(BOOL)queryExecutable
{
    //initialize database variables
    sqlite3 *sqlite3DB;
    NSString *databasepath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    //clear punlic variables
    if(self.arrResults != nil)
    {
        [self.arrResults removeAllObjects];
        self.arrResults = nil;
    }
    self.arrResults = [[NSMutableArray alloc] init];
    
    if(self.arrColumnNames != nil)
    {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = [[NSMutableArray alloc] init];
    }
    
    //connect to database
    BOOL openDatabaseResult = sqlite3_open([databasepath UTF8String], &sqlite3DB);
    if(!openDatabaseResult == SQLITE_OK)
    {
        sqlite3_stmt *compiledStatement;
    
        //load data to memory
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3DB, query, -1, &compiledStatement, NULL);
        if(prepareStatementResult == SQLITE_OK)
        {
            //check if query is executable (inputing/changing or recieving data)
            if(!queryExecutable)
            {
                NSMutableArray *arrDataRow;
                
                while(sqlite3_step(compiledStatement) == SQLITE_ROW)
                {
                    arrDataRow = [[NSMutableArray alloc] init];
                    
                    int totalColumns = sqlite3_column_count(compiledStatement);
                    
                    for(int i=0; i<totalColumns; i++)
                    {
                        char *dataAsChar = (char *)sqlite3_column_text(compiledStatement, i);
                        
                        if(dataAsChar != NULL)
                        {
                            [arrDataRow addObject:[NSString stringWithUTF8String:dataAsChar]];
                        }
                        if (self.arrColumnNames.count != totalColumns)
                        {
                            dataAsChar = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:dataAsChar]];
                        }
                    }
                    
                    if (arrDataRow.count > 0)
                    {
                        [self.arrResults addObject:arrDataRow];
                    }
                }
            }
            else
            {
                BOOL executeQueryResults = sqlite3_step(compiledStatement);
                if (executeQueryResults == SQLITE_DONE)
                {
                    self.affectedRows = sqlite3_changes(sqlite3DB);
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3DB);
                }
                else
                {
                    NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3DB));
                }
            }
        }
        else
        {
            NSLog(@"%s", sqlite3_errmsg(sqlite3DB));
        }
        
        sqlite3_finalize(compiledStatement);
    }
    
    sqlite3_close(sqlite3DB);
}

@end
