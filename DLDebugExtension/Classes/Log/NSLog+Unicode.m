//
//  NSLog+Unicode.m
//  DLDebugExtension
//
//  Created by Daniel Lin on 2018/5/24.
//  Copyright (c) 2018 Daniel Lin. All rights reserved.

#ifdef DEBUG

#import <Foundation/Foundation.h>

static inline NSString *DLDescription(id obj, NSLocale *locale, NSUInteger indent) {
    if ([obj respondsToSelector:@selector(descriptionWithLocale:indent:)]) {
        return [obj descriptionWithLocale:locale indent:indent];
    } else if ([obj isKindOfClass:NSString.class]) {
        return [NSString stringWithFormat:@"\"%@\"", obj];
    } else {
        return [NSString stringWithFormat:@"%@", obj];
    }
}

@implementation NSDictionary (DLLog)

- (NSString *)descriptionWithLocale:(NSLocale *)locale indent:(NSUInteger)level {
    NSMutableArray *lines = [NSMutableArray array];
    [lines addObject:@"{"];
    [self enumerateKeysAndObjectsUsingBlock:^(id  key, id obj, BOOL *stop) {
        NSString *strKey = DLDescription(key, locale, level + 1);
        NSString *strObj = DLDescription(obj, locale, level + 1);
        NSString *line = [NSString stringWithFormat:@"    %@ = %@;", strKey, strObj];
        [lines addObject:line];
    }];
    [lines addObject:@"}"];
    
    NSMutableString *indentation = [NSMutableString string];
    if (self.count > 0) {
        [indentation appendString:@"\n"];
        for (int i = 0; i < level; i++) {
            [indentation appendString:@"    "];
        }
    }
    
    return [lines componentsJoinedByString:indentation];
}

@end

@implementation NSArray (DLLog)

- (NSString *)descriptionWithLocale:(NSLocale *)locale indent:(NSUInteger)level {
    NSMutableArray *lines = [NSMutableArray array];
    [lines addObject:@"["];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *strObj = DLDescription(obj, locale, level + 1);
        NSString *line = [NSString stringWithFormat:@"    %@,", strObj];
        [lines addObject:line];
    }];
    [lines addObject:@"]"];
    
    NSMutableString *indentation = [NSMutableString string];
    if (self.count > 0) {
        [indentation appendString:@"\n"];
        for (int i = 0; i < level; i++) {
            [indentation appendString:@"    "];
        }
    }
    
    return [lines componentsJoinedByString:indentation];
}

@end

@implementation NSSet (DLLog)

- (NSString *)descriptionWithLocale:(NSLocale *)locale indent:(NSUInteger)level {
    NSMutableArray *lines = [NSMutableArray array];
    [lines addObject:@"("];
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        NSString *strObj = DLDescription(obj, locale, level + 1);
        NSString *line = [NSString stringWithFormat:@"    %@,", strObj];
        [lines addObject:line];
    }];
    [lines addObject:@")"];
    
    NSMutableString *indentation = [NSMutableString string];
    if (self.count > 0) {
        [indentation appendString:@"\n"];
        for (int i = 0; i < level; i++) {
            [indentation appendString:@"    "];
        }
    }
    
    return [lines componentsJoinedByString:indentation];
}

@end

#endif
