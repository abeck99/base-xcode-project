//
//  {{ fileName }}
//  {{ projectName }}
//
//  Created by {{ createdByName }} on {{ currentDate }}.
//  Copyright (c) {{ currentYear }} {{ companyName }}. All rights reserved.
//

#import "AB_BaseModel.h"

{% for enumField in fields["enum"] %}
typedef enum : NSUInteger
{
    {{ enumField.enumName }}_Unknown,
{% for enumValue in enumField %}
    {{ enumField.enumName }}_{{ enumValue }},
{% endfor %}
} {{ enumField.enumName }};
{% endfor %}

@interface {{ className }} : AB_BaseModel

{% for stringField in fields["string"] %}
@property(readonly, strong) NSString* {{ stringField.name }}; // {{ stringField.jsonFieldName }}
{% endfor %}
{% for enumField in fields["enum"] %}
@property(readonly) {{ enumField.enumName }} {{ enumField.name }}; // {{ enumField.jsonFieldName }}
{% endfor %}
{% for isoDateField in fields["isoDate"] %}
@property(readonly, strong) NSDate* {{ isoDateField.name }}; // {{ isoDateField.jsonFieldName }}
{% endfor %}
{% for intField in fields["int"] %}
@property(readonly) int {{ intField.name }}; // {{ intField.jsonFieldName }}
{% endfor %}
{% for floatField in fields["float"] %}
@property(readonly) float {{ floatField.name }}; // {{ floatField.jsonFieldName }}
{% endfor %}
{% for boolField in fields["bool"] %}
@property(readonly) bool {{ boolField.name }}; // {{ boolField.jsonFieldName }}
{% endfor %}
{% for modelField in fields["model"] %}
@property(readonly, strong) {{ modelField.referenceModelClass }}* {{ modelField.name }}; // {{ modelField.jsonFieldName }}
{% endfor %}
{% for modelField in fields["modelList"] %}
@property(readonly, strong) NSArray* {{ modelField.name }}; // {{ modelField.jsonFieldName }}
{% endfor %}

@end
