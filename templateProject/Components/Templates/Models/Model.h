//
//  {{ fileName }}
//  {{ projectName }}
//
//  Created by {{ createdByName }} on {{ currentDate }}.
//  Copyright (c) {{ currentYear }} {{ companyName }}. All rights reserved.
//

#import <AB_BaseModel.h>

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
@property({% if stringField.readonly %}readonly, {% endif %}strong) NSString* {{ stringField.name }}; // {{ stringField.jsonFieldName }}
{% endfor %}
{% for enumField in fields["enum"] %}
@property({% if enumField.readonly %}readonly, {% endif %}assign) {{ enumField.enumName }} {{ enumField.name }}; // {{ enumField.jsonFieldName }}
{% endfor %}
{% for isoDateField in fields["isoDate"] %}
@property({% if isoDateField.readonly %}readonly, {% endif %}strong) NSDate* {{ isoDateField.name }}; // {{ isoDateField.jsonFieldName }}
{% endfor %}
{% for intField in fields["int"] %}
@property({% if intField.readonly %}readonly, {% endif %}assign) int {{ intField.name }}; // {{ intField.jsonFieldName }}
{% endfor %}
{% for floatField in fields["float"] %}
@property({% if floatField.readonly %}readonly, {% endif %}assign) float {{ floatField.name }}; // {{ floatField.jsonFieldName }}
{% endfor %}
{% for boolField in fields["bool"] %}
@property({% if boolField.readonly %}readonly, {% endif %}assign) bool {{ boolField.name }}; // {{ boolField.jsonFieldName }}
{% endfor %}
{% for locationField in fields["location"] %}
@property({% if locationField.readonly %}readonly, {% endif %}strong) CLLocation* {{ locationField.name }}; // {{ locationField.jsonFieldName }}
{% endfor %}
{% for modelField in fields["model"] %}
@property({% if modelField.readonly %}readonly, {% endif %}strong) {{ modelField.referenceModelClass }}* {{ modelField.name }}; // {{ modelField.jsonFieldName }}
{% endfor %}
{% for modelField in fields["modelList"] %}
@property({% if modelField.readonly %}readonly, {% endif %}strong) NSArray* {{ modelField.name }}; // {{ modelField.jsonFieldName }}
{% endfor %}

@end
