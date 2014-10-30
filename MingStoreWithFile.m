//
//  MingStoreWithFile.m
//
//  Created by mguo80 on 10/12/14.
//

#import "MingStoreWithFile.h"
#import <TMCache/TMCache.h>

@interface MingStoreWithFile()
@property (nonatomic, strong)   TMDiskCache* cache;
@end

@implementation MingStoreWithFile

@synthesize cloud;

-(instancetype)initWithCloud:(id<MingCloud>)cld
{
    if (self = [super init])
    {
        self.cache = [TMDiskCache sharedCache];
        self.cloud = cld;
    }
    return self;
}

-(instancetype)initWithName:(NSString *)name andCloud:(id<MingCloud>)cld
{
    if (self = [super init])
    {
        self.name = name;
        self.cache = [[TMDiskCache alloc] initWithName:name];
        self.cloud = cld;
    }
    return self;
}

-(id)getObjectByKey:(NSString *)key
{
    id obj = [self.cache objectForKey:key];
    if (!obj)
    {
        obj = [self.cloud getObjectByKey:key];
        if (obj)
        {
            [self.cloud setObject:obj ByKey:key];
        }
    }
    return obj;
}

-(BOOL)setObject:(id)obj ByKey:(NSString *)key
{
    [self.cache setObject:obj forKey:key];
    return [self.cloud setObject:obj ByKey:key];
}

-(id)getCustomObjectByKey:(NSString *)key
{
    return [self getObjectByKey:key];
}

-(BOOL)setCustomObject:(id<NSCoding>)obj ByKey:(NSString *)key
{
    return [self setObject:obj ByKey:key];
}

@end
