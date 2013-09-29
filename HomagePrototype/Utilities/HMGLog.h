//
//  HMGLog.h
//  HomagePrototype
//
//  Created by Tomer Harry on 9/23/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <asl.h>

// define a macro which will let us compile-out log statements at a certain level when in release mode
#ifndef HMG_COMPILE_TIME_LOG_LEVEL
    #ifdef NDEBUG
        #define HMG_COMPILE_TIME_LOG_LEVEL ASL_LEVEL_NOTICE
    #else
        #define HMG_COMPILE_TIME_LOG_LEVEL ASL_LEVEL_DEBUG
    #endif
#endif

// Next we define macros for each log level that we want to support

// Error Log Level
#if HMG_COMPILE_TIME_LOG_LEVEL >= ASL_LEVEL_ERR
    void HMGLogError(NSString *format, ...);
#else
    #define HMGLogError(...)
#endif

// Warning Log Level
#if HMG_COMPILE_TIME_LOG_LEVEL >= ASL_LEVEL_WARNING
    void HMGLogWarning(NSString *format, ...);
#else
    #define HMGLogWarning(...)
#endif

// Notice Log Level
#if HMG_COMPILE_TIME_LOG_LEVEL >= ASL_LEVEL_NOTICE
    void HMGLogNotice(NSString *format, ...);
#else
    #define HMGLogNotice(...)
#endif

// Info Log Level
#if HMG_COMPILE_TIME_LOG_LEVEL >= ASL_LEVEL_INFO
    void HMGLogInfo(NSString *format, ...);
#else
    #define HMGLogInfo(...)
#endif

// Debug Log Level
#if HMG_COMPILE_TIME_LOG_LEVEL >= ASL_LEVEL_DEBUG
    void HMGLogDebug(NSString *format, ...);
#else
    #define HMGLogDebug(...)
#endif
