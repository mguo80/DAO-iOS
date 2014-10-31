//
//  MingCloudWithParse.m
//
//  Created by mguo80 on 10/22/14.
//

#import "MingCloudWithParse.h"
#import "Parse/Parse.h"

#define LOCAL_ID    @"local_id"     // "key" of the local NSObject
#define LOCAL_DATA  @"local_data"   // actual data of the local NSObject

@implementation MingCloudWithParse

@synthesize cloudName;

-(id)getObjectByKey:(NSString *)key
{
    if (self.cloudName)
    {
        PFQuery *query = [PFQuery queryWithClassName:self.cloudName];
        [query whereKey:LOCAL_ID equalTo:key];
        PFObject *pfObj = [query getFirstObject];
        NSData *localData = [pfObj objectForKey:LOCAL_DATA];
        return [NSKeyedUnarchiver unarchiveObjectWithData:localData];
    }
    return nil;
}

-(BOOL)setObject:(id)obj ByKey:(NSString *)key
{
    if (self.cloudName)
    {
        PFObject *pfObj = [PFObject objectWithClassName:self.cloudName];
        [pfObj setObject:key forKey:LOCAL_ID];
        [pfObj setObject:[NSKeyedArchiver archivedDataWithRootObject:obj] forKey:LOCAL_DATA];
        if (![pfObj save])
        {
            [pfObj saveEventually];
        }
        return YES;
    }
    return NO;
}

-(BOOL)removeObjectByKey:(NSString *)key
{
    if (self.cloudName)
    {
        PFQuery *query = [PFQuery queryWithClassName:self.cloudName];
        [query whereKey:LOCAL_ID equalTo:key];
        NSArray *array = [query findObjects];
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            PFObject *pfObj = (PFObject*)obj;
            if (![pfObj delete])
            {
                [pfObj deleteEventually];
            }
        }];
        return YES;
    }
    return NO;
}

@end
