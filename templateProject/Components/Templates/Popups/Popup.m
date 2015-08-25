//
//  {{ fileName }}
//  {{ projectName }}
//
//  Created by {{ createdByName }} on {{ currentDate }}.
//  Copyright (c) {{ currentYear }} {{ companyName }}. All rights reserved.
//

#import "{{ className }}.h"

@implementation {{ className }}

+ (UINib*) baseNib
{
    RETURN_NIB_NAMED(@"{{ xibName }}")
}

+ (void) load
{
    [[self class] baseNib];
}

- (BOOL) isOverlayPopup
{
    return NO;
}

- (void) setup
{
    [super setup];
}

@end
