//
//  MingStoreWithSQLite.m
//
//  Created by Guo, Ming on 10/10/14.
//

#import "MingStoreWithSQLite.h"

@interface SQLiteDBManager()
@property (nonatomic, strong)   NSMutableDictionary *dbMap;     //dbName - FMDatabaseQueue
@end

@implementation SQLiteDBManager

+(SQLiteDBManager*)instance
{
    static dispatch_once_t once;
    static SQLiteDBManager* instance;
    
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(instancetype)init
{
    if (self = [super init])
    {
        self.dbMap = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(FMDatabaseQueue*)getDBQueue:(NSString*)dbName
{
    id dbQueue = [self.dbMap objectForKey:dbName];
    if (!dbQueue)
    {
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *dbPath = [[filePath stringByAppendingPathComponent:@"db"] stringByAppendingPathComponent:dbName];
        dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        if (dbQueue)
        {
            [self.dbMap setObject:dbQueue forKey:dbName];
        }
    }
    return dbQueue;
}

@end


static NSString* const COLUMN_ID = @"id";
static NSString* const COLUMN_DATA = @"data";

@interface MingStoreWithSQLite()
@property (nonatomic, strong)   FMDatabaseQueue *dbQueue;
@property (nonatomic, strong)   NSString *name;
@end

@implementation MingStoreWithSQLite

@synthesize cloud;

-(instancetype)initWithDB:(FMDatabaseQueue *)db andStoreName:(NSString *)storeName andCloud:(id<MingCloud>)cld
{
    if (self = [super init])
    {
        self.dbQueue = db;
        self.name = storeName;
        [self createTable];
        self.cloud = cld;
    }
    return self;
}

-(instancetype)initWithDBName:(NSString *)dbName andStoreName:(NSString *)storeName andCloud:(id<MingCloud>)cld
{
    FMDatabaseQueue *db = [[SQLiteDBManager instance] getDBQueue:dbName];
    return [self initWithDB:db andStoreName:storeName andCloud:cld];
}

-(void)dealloc
{
    [self.dbQueue close];
}

-(void)createTable
{
    NSString *query = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT PRIMARY KEY NOT NULL, %@ BLOB)", self.name, COLUMN_ID, COLUMN_DATA];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:query];
    }];
}

-(id)getObjectByKey:(NSString *)key
{
    return [self getCustomObjectByKey:key];
}

-(BOOL)setObject:(id)obj ByKey:(NSString *)key
{
    return [self setCustomObject:obj ByKey:key];
}

-(id)getCustomObjectByKey:(NSString *)key
{
    id __block obj = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSString *query = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = '%@'", COLUMN_DATA, self.name, COLUMN_ID, key];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:query];
        if ([rs next])
        {
            NSData* data = [rs objectForColumnName:COLUMN_DATA];
            obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    if (!obj)
    {
        obj = [self.cloud getObjectByKey:key];
        if (obj)
        {
            [self saveObject:obj ByKey:key];
        }
    }
    return obj;
}

-(BOOL)setCustomObject:(id<NSCoding>)obj ByKey:(NSString *)key
{
    [self saveObject:obj ByKey:key];
    return [self.cloud setObject:obj ByKey:key];
}

-(void)saveObject:(id<NSCoding>)obj ByKey:(NSString*)key
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
    NSString *query = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@, %@) VALUES (%@, %@)", self.name, COLUMN_ID, COLUMN_DATA, key, data];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:query];
    }];
}

@end
