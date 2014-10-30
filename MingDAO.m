//
//  MingDAO.m
//
//  Created by mguo80 on 10/12/14.
//

#import "MingDAO.h"
#import "TMCache/TMCache.h"

@interface MingDAO ()
@property (nonatomic, strong)   TMMemoryCache *cache;
@end

@implementation MingDAO

-(instancetype)initWithStore:(id<MingStore>)store
{
    if (self = [super init])
    {
        self.cache = [[TMMemoryCache alloc] init];
        self.store = store;
        
        //by default we use DAO class name as store name in cloud side
        self.store.cloud.cloudName = NSStringFromClass([self class]);
    }
    return self;
}

-(id)getObjectByKey:(NSString *)key
{
    id obj = nil;
    if (key)
    {
        obj = [self.cache objectForKey:key];
        if (!obj)
        {
            //fall back to disk store if it doesn't exist in memory cache yet
            obj = [self.store getObjectByKey:key];
            if (obj)
            {
                [self.cache setObject:obj forKey:key];
            }
        }
    }
    return obj;
}

-(BOOL)setObject:(id)obj ByKey:(NSString *)key
{
    if (key)
    {
        if ([self.store setObject:obj ByKey:key])
        {
            [self.cache setObject:obj forKey:key];
            return YES;
        }
    }
    return NO;
}

-(id)getCustomObjectByKey:(NSString *)key
{
    id obj = nil;
    if (key)
    {
        obj = [self.cache objectForKey:key];
        if (!obj)
        {
            //fall back to disk store if it doesn't exist in memory cache yet
            obj = [self.store getCustomObjectByKey:key];
            if (obj)
            {
                [self.cache setObject:obj forKey:key];
            }
        }
    }
    return obj;
}

-(BOOL)setCustomObject:(id)obj ByKey:(NSString *)key
{
    if (key)
    {
        if ([self.store setCustomObject:obj ByKey:key])
        {
            [self.cache setObject:obj forKey:key];
            return YES;
        }
    }
    return NO;
}

@end
