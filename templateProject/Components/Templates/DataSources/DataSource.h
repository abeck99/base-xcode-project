//
//  {{ fileName }}
//  {{ projectName }}
//
//  Created by {{ createdByName }} on {{ currentDate }}.
//  Copyright (c) {{ currentYear }} {{ companyName }}. All rights reserved.
//

#import "AB_DataSourceBase.h"

@interface {{ className }} : AB_DataSourceBase
{
{% for cellType in cellTypes %}
    AB_SectionInfo* {{ cellType.lowercaseName }}Section;
{% endfor %}
}

@end
