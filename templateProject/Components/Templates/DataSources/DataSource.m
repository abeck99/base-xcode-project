//
//  {{ fileName }}
//  {{ projectName }}
//
//  Created by {{ createdByName }} on {{ currentDate }}.
//  Copyright (c) {{ currentYear }} {{ companyName }}. All rights reserved.
//

#import "{{ className }}.h"
{% for cellType in cellTypes %}
#import "{{ cellType.className }}.h"
{% endfor %}

@implementation {{ className }}

- (void) setup
{
    [super setup];

{% for cellType in cellTypes %}
    [self setNib:@"{{ cellType.xibName }}" forSectionType:@"{{ cellType.uppercaseName }}"];
{% endfor %}
{% for cellType in cellTypes %}

    {{ cellType.lowercaseName }}Section = [[AB_SectionInfo alloc] init];
    {{ cellType.lowercaseName }}Section.sectionName = @"{{ cellType.uppercaseName }}";
    {{ cellType.lowercaseName }}Section.headerHidden = YES;
    {{ cellType.lowercaseName }}Section.items = [[AB_FilteredArray alloc] initWithArray:@[]];
    {{ cellType.lowercaseName }}Section.sectionType = @"{{ cellType.uppercaseName }}";
    {{ cellType.lowercaseName }}Section.numCellsPerRow = 1;
    [self addSection:{{ cellType.lowercaseName }}Section];
{% endfor %}
}

- (void) setupCell:(UIView*)cell withData:(id)data dataIndexPath:(NSIndexPath*)indexPath
{
{% for cellType in cellTypes %}
    if ([cell isKindOfClass:[{{ cellType.className }} class]])
    {
        // {{ cellType.className }}* {{ cellType.lowercaseName }} = ({{ cellType.className }}*) cell;
    }
    else
{% endfor %}
    {
        
    }
}


@end
