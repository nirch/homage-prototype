//
//  HMGLog.h
//  HomagePrototype
//
//  Created by Tomer Harry on 9/23/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <Foundation/Foundation.h>

// The macro HMGLogDebug will be NSLog if we are in debug mode, otherwise it will it will be nothing
#ifdef NDEBUG
    #define HMGLogDebug(...)
#else
    #define HMGLogDebug NSLog
#endif

@interface HMGLog : NSObject

/*
 + (void)logApplication:(NSString *)className methodName:(NSString *)methodName message:(NSString *) message, ...
 {
 va_list arglist;
 va_start(arglist, message);
 
 
 
 NSLogv(message, arglist);
 va_end(arglist);
 }
*/

@end
