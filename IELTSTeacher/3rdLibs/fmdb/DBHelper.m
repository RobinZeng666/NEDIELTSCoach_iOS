//
//  DBHelper.m
//  PilotManual
//
//  Created by melp on 13-1-11.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DBHelper.h"
#import "FMDatabaseAdditions.h"

static DBHelper* _sharedDBHelper = nil;

@implementation DBHelper
{
    FMDatabase *db;
}

+(DBHelper *) sharedDBHelper
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        _sharedDBHelper = [[super allocWithZone:NULL] initWithDBName];
    });
    return _sharedDBHelper;
}

- (id) initWithDBName//:(NSString*) dbName
{
    self = [super init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbFullPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"ch2.db"];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSError *error;
    
    if(![fileMgr fileExistsAtPath:dbFullPath])
    {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbFullPath];
        
        BOOL ret = [fileMgr removeItemAtPath:dbFullPath error:&error];
        
        ret = [fileMgr copyItemAtPath:defaultDBPath toPath:dbFullPath error:&error];
        
        if(!ret)
        {
            NSLog(@"Faile to create database !!");
        }
    }
    
    
    db = [FMDatabase databaseWithPath:dbFullPath];
    db.logsErrors = YES;
    
    if (![db tableExists:@"CacheTable"]) {
        [self ExecuteSql:@"CREATE TABLE CacheTable(APIPath text,Response text)"];
    };
    return self;
}

- (FMResultSet*) Query:(NSString*)sql
{
    if(![db open])
    {
        NSLog(@"DB Open Failed.");
        return nil;
    }

    FMResultSet *rs = [db executeQuery:sql];
    return rs;
}

- (void) ExecuteSql:(NSString*)sql
{
    if(![db open])
    {
        NSLog(@"DB Open Failed.");
        return;
    }

    [db executeUpdate:sql];
    
    [db close];
}

- (void) ExecuteSqlList:(NSArray*)sqlArr
{
    if(![db open])
    {
        NSLog(@"DB Open Failed.");
        return;
    }
    
    [db beginTransaction];
    
    for(NSString* sql in sqlArr)
    {
        [db executeUpdate:sql];
    }
    
    [db commit];
    [db close];   
}

- (void) CloseDB
{
    [db close];
}

@end
