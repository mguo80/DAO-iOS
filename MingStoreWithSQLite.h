//
//  MingStoreWithSQLite.h
//
//  Created by mguo80 on 10/12/14.
//

#import <Foundation/Foundation.h>
#import "MingStore.h"
#import "FMDB/FMDB.h"

@interface SQLiteDBManager : NSObject

+(SQLiteDBManager*)instance;
-(FMDatabaseQueue*)getDBQueue:(NSString*)dbName;

@end

@interface MingStoreWithSQLite : NSObject<MingStore>

-(instancetype)initWithDB:(FMDatabaseQueue*)db
             andStoreName:(NSString *)storeName
                 andCloud:(id<MingCloud>)cloud;

-(instancetype)initWithDBName:(NSString*)dbName
                 andStoreName:(NSString*)storeName
                     andCloud:(id<MingCloud>)cloud;

-(void)dealloc;

-(id)getObjectByKey:(NSString*)key;

-(BOOL)setObject:(id)obj ByKey:(NSString*)key;

-(id)getCustomObjectByKey:(NSString *)key;

-(BOOL)setCustomObject:(id<NSCoding>)obj ByKey:(NSString *)key;

@end
