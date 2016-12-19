//
//  EntityBase.m
//  Bireki
//
//  Created by Takaaki Kakinuma on 2014/06/19.
//  Copyright (c) 2014年 piped bits. All rights reserved.
//

#import "EntityBase.h"

#import "objc/runtime.h"

@implementation EntityBase

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
    }
    return  self;
}

-(BOOL)compareToObjects:(id)object{
    if ([self respondsToSelector:@selector(initWithCoder:)]&&[self respondsToSelector:@selector(encodeWithCoder:)]) {
        NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:self];
        NSData *data2 = [NSKeyedArchiver archivedDataWithRootObject:object];
        if ([data1 isEqualToData:data2]) {
            return true;
        }
    }
    return false;
}

-(id)copy{
    if ([self respondsToSelector:@selector(initWithCoder:)]&&[self respondsToSelector:@selector(encodeWithCoder:)]) {
        id object = [NSKeyedUnarchiver unarchiveObjectWithData:
                     [NSKeyedArchiver archivedDataWithRootObject:self]];
        return object;
    }
    return nil;
}

- (void)attributes2obj:(NSDictionary *)attributes {
    
}

- (id)null2nil:(NSObject *)attribute {
    if (attribute.class == [NSNull class]||[attribute.description isEqual:@""])
        attribute = nil;
    return attribute;
}

- (NSArray *)propertyNames {
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    NSMutableArray *arr = @[].mutableCopy;
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            NSString *propertyName = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
            [arr addObject:propertyName];
        }
    }
    free(properties);
    
    return arr;
}

- (NSDictionary *)properties {
    unsigned int outCount, i;
    objc_property_t *props = class_copyPropertyList([self class], &outCount);
    NSMutableDictionary *dic = @{}.mutableCopy;
    for(i = 0; i < outCount; i++) {
        objc_property_t property = props[i];
        const char *propName = property_getName(property);
        if(propName) {
            const char *propType = getPropertyType(property);
            NSString *propertyName = [NSString stringWithCString:propName encoding:NSUTF8StringEncoding];
            NSString *propertyType = [NSString stringWithCString:propType encoding:NSUTF8StringEncoding];
            [dic setObject:propertyType forKey:propertyName];
        }
    }
    free(props);
    
    return dic;
}

static const char * getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
        } else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            return "id";
        } else if (attribute[0] == 'T' && attribute[1] == '@') {
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "";
}
-(BOOL)original:(NSString *)originalString didContaintString:(NSString *)stringContained{
    if (!stringContained) {
        return NO;
    }
    NSRange range = [originalString rangeOfString:stringContained];
    if (range.location==NSNotFound) {
        return NO;
    }else{
        return YES;
    }
    
}

-(NSString *)stringDateFromNSDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    return [dateFormatter stringFromDate:date];
}


@end
