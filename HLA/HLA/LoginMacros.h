//
//  LoginMacros.h
//  BLESS
//
//  Created by Erwin on 05/02/2016.
//  Copyright © 2016 Hong Leong Assurance. All rights reserved.
//

#ifndef LoginMacros_h
#define LoginMacros_h

// DB Related Cons
static const int DATABASE_ERROR = 500;

// Table Related Const
static const int TABLE_INSERTION_SUCCESS = 200;
static const int TABLE_INSERTION_FAILED = 201;

// Agent Related Const
static const int AGENT_IS_FOUND = 100;
static const int AGENT_IS_NOT_FOUND = 101;

static const int AGENT_IS_ACTIVE = 130;
static const int AGENT_IS_INACTIVE = 131;

static const int LICENSE_IS_NOT_EXPIRED = 120;
static const int LICENSE_IS_EXPIRED = 121;
static const int INACTIVE_AND_EXPIRED = 152;

//UI Elements
static const int USERNAME_PASSWORD_VALIDATION = 300;


static NSString *AGENT_KEY_CODE = @"agentCode";


#endif /* LoginMacros_h */
