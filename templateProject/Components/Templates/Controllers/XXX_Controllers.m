//
//  {{ fileName }}
//  {{ projectName }}
//
//  Created by {{ createdByName }} on {{ currentDate }}.
//  Copyright (c) {{ currentYear }} {{ companyName }}. All rights reserved.
//

#import "{{ className }}.h"
{% for controller in controllers %}
#import "{{ controller["className"] }}.h"
{% endfor %}

AB_Controllers* getController()
{
    RETURN_THREAD_SAFE_SINGLETON({{ className }});
}

@implementation {{ className }}

- (NSDictionary*) getControllers
{
    return @{
{% for controller in controllers %}
             @"{{ controller["lowercaseName"] }}": @{
                    @"class": [{{ controller["className"] }} class],
                     @"nib": @"{{ controller["uppercaseName"] }}",
{% if controller["defaultController"] is not none %}
                     @"defaultController": @"{{ controller["defaultController"] }}"
{% endif %}
                     },
{% endfor %}
    };
}

@end
