//
//  {{ fileName }}
//  {{ projectName }}
//
//  Created by {{ createdByName }} on {{ currentDate }}.
//  Copyright (c) {{ currentYear }} {{ companyName }}. All rights reserved.
//

#import "EA_CoreLoopNoteModel.h"

@implementation EA_CoreLoopNoteModel

+ (NSDictionary*)JSONKeyPathsByPropertyKey
{
    return @{
{% for fieldList in fields %}
{% for field in fieldList %}
            @"{{ field.name }}": @"{{ field.jsonFieldName }}",
{% endfor %}
{% endfor %}
          };
}

{% for stringField in fields["string"] %}
MAP_STRING({{stringField.name}})
{% endfor %}
{% for isoDateField in fields["isoDate"] %}
MAP_DATE({{isoDateField.name}})
{% endfor %}
{% for intField in fields["int"] %}
MAP_NUMBER({{intField.name}}, NSNumberFormatterNoStyle)
{% endfor %}
{% for floatField in fields["float"] %}
MAP_DECIMAL({{floatField.name}})
{% endfor %}
{% for boolField in fields["bool"] %}
MAP_NUMBER({{boolField.name}}, NSNumberFormatterNoStyle)
{% endfor %}
{% for modelField in fields["model"] %}
MAP_SUBOBJECT({{modelField.name}})
{% endfor %}
{% for modelField in fields["modelList"] %}
MAP_SUBOBJECT_ARRAY({{modelField.name}})
{% endfor %}

{% for enumField in fields["enum"] %}
+ (NSValueTransformer*) {{ enumField.name }}JSONTransformer
{
    return [NSValueTransformer
            mtl_valueMappingTransformerWithDictionary:
            @{
                : @({{ enumField.enumName }}_Unknown),
{% for enumValue in enumField %}
                : @({{ enumField.enumName }}_{{ enumValue }}),
{% endfor %}
              }
            defaultValue:@({{ enumField.enumName }}_Unknown) reverseDefaultValue:nil];
}

{% endfor %}
@end
