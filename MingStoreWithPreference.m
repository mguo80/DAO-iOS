//
//  MingStoreWithPreference.m
//
//  Created by mguo80 on 10/12/14.
//

#import "MingStoreWithPreference.h"

@implementation MingStoreWithPreference

@synthesize cloud;

-(instancetype)initWithCloud:(id<MingCloud>)cld
{
    if (self = [super init])
    {
        self.cloud = cld;
    }
    return self;
}

-(id)getObjectByKey:(NSString*)key
{
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!obj)
    {
        obj = [self.cloud getObjectByKey:key];
        if (obj)
        {
            [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
        }
    }
    return obj;
}

-(BOOL)setObject:(id)obj ByKey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    return [self.cloud setObject:obj ByKey:key];
}

-(id)getCustomObjectByKey:(NSString *)key
{
    NSData *data = [self getObjectByKey:key];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

-(BOOL)setCustomObject:(id<NSCoding>)obj ByKey:(NSString *)key
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
    return [self setObject:data ByKey:key];
}

@end
