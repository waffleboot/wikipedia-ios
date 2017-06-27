#import "WMFContentGroup+WMFFeedContentDisplaying.h"
#import "WMFAnnouncement.h"
@import WMF;
#import "WMFFirstRandomViewController.h"
#import "Wikipedia-Swift.h"
#import "WMFFeedNewsStory.h"
#import "WMFContentGroup+Extensions.h"

NS_ASSUME_NONNULL_BEGIN

@implementation WMFContentGroup (WMFContentManaging)

- (nullable NSArray<NSURL *> *)contentURLs {
    NSArray<NSCoding> *content = [self content];
    if ([self contentType] == WMFContentTypeTopReadPreview) {
        content = [content wmf_map:^id(WMFFeedTopReadArticlePreview *obj) {
            return [obj articleURL];
        }];
    } else if ([self contentType] == WMFContentTypeStory) {
        content = [content wmf_map:^id(WMFFeedNewsStory *obj) {
            return [[obj featuredArticlePreview] articleURL] ?: [[[obj articlePreviews] firstObject] articleURL];
        }];
    } else if ([self contentType] != WMFContentTypeURL) {
        content = nil;
    }
    return content;
}

- (nullable UIViewController *)detailViewControllerWithDataStore:(MWKDataStore *)dataStore siteURL:(NSURL *)siteURL {
    WMFFeedMoreType moreType = [self moreType];
    switch (moreType) {
        case WMFFeedMoreTypePageList:
        case WMFFeedMoreTypePageListWithLocation: {
            NSArray<NSURL *> *URLs = (NSArray<NSURL *> *)[self contentURLs];
            if (![[URLs firstObject] isKindOfClass:[NSURL class]]) {
                NSAssert(false, @"Invalid Content");
                return nil;
            }
            if (moreType == WMFFeedMoreTypePageListWithLocation) {
                return [[WMFArticleLocationCollectionViewController alloc] initWithArticleURLs:URLs dataStore:dataStore];
            } else {
                WMFArticleCollectionViewController *vc = [[WMFArticleCollectionViewController alloc] initWithArticleURLs:URLs dataStore:dataStore];
                vc.title = [self moreTitle];
                return vc;
            }
            } break;
        case WMFFeedMoreTypeNews: {
            NSArray<WMFFeedNewsStory *> *stories = (NSArray<WMFFeedNewsStory *> *)[self content];
            if (![[stories firstObject] isKindOfClass:[WMFFeedNewsStory class]]) {
                NSAssert(false, @"Invalid Content");
                return nil;
            }
            return [[WMFNewsViewController alloc] initWithStories:stories dataStore:dataStore];
        } break;
        case WMFFeedMoreTypeOnThisDay: {
            NSArray<WMFFeedOnThisDayEvent *> *events = (NSArray<WMFFeedOnThisDayEvent *> *)[self content];
            if (![[events firstObject] isKindOfClass:[WMFFeedOnThisDayEvent class]]) {
                NSAssert(false, @"Invalid Content");
                return nil;
            }
            return [[WMFOnThisDayViewController alloc] initWithEvents:events dataStore:dataStore date:self.date];
        } break;
        default:
            NSAssert(false, @"Unknown More Type");
            return nil;
    }
}

#pragma mark - In The News

- (nullable UIImage *)headerIcon {
    switch (self.contentGroupKind) {
        case WMFContentGroupKindContinueReading:
            return [UIImage imageNamed:@"home-continue-reading-mini"];
        case WMFContentGroupKindMainPage:
            return [UIImage imageNamed:@"today-mini"];
        case WMFContentGroupKindRelatedPages:
            return [UIImage imageNamed:@"recent-mini"];
        case WMFContentGroupKindLocation:
            return [UIImage imageNamed:@"nearby-mini"];
        case WMFContentGroupKindLocationPlaceholder:
            return [UIImage imageNamed:@"nearby-mini"];
        case WMFContentGroupKindPictureOfTheDay:
            return [UIImage imageNamed:@"potd-mini"];
        case WMFContentGroupKindRandom:
            return [UIImage imageNamed:@"random-mini"];
        case WMFContentGroupKindFeaturedArticle:
            return [UIImage imageNamed:@"featured-mini"];
        case WMFContentGroupKindTopRead:
            return [UIImage imageNamed:@"trending-mini"];
        case WMFContentGroupKindNews:
            return [UIImage imageNamed:@"in-the-news-mini"];
        case WMFContentGroupKindOnThisDay:
            return [UIImage imageNamed:@"on-this-day-mini"];
        case WMFContentGroupKindNotification:
            break;
        case WMFContentGroupKindAnnouncement:
            break;
        case WMFContentGroupKindUnknown:
        default:
            break;
    }
    return nil;
}

- (nullable UIColor *)headerIconTintColor {
    switch (self.contentGroupKind) {
        case WMFContentGroupKindLocationPlaceholder:
        case WMFContentGroupKindLocation:
            return [UIColor wmf_green];
        case WMFContentGroupKindPictureOfTheDay:
            return [UIColor wmf_purple];
        case WMFContentGroupKindRandom:
            return [UIColor wmf_red];
        case WMFContentGroupKindFeaturedArticle:
            return [UIColor wmf_yellow];
        case WMFContentGroupKindTopRead:
            return [UIColor wmf_blue];
        case WMFContentGroupKindOnThisDay:
            return [UIColor wmf_blue];
        default:
            return [UIColor wmf_exploreSectionHeaderIconTint];
    }
}

- (nullable UIColor *)headerIconBackgroundColor {
    switch (self.contentGroupKind) {
        case WMFContentGroupKindLocationPlaceholder:
        case WMFContentGroupKindLocation:
            return [UIColor wmf_lightGreen];
        case WMFContentGroupKindPictureOfTheDay:
            return [UIColor wmf_lightPurple];
        case WMFContentGroupKindRandom:
            return [UIColor wmf_lightRed];
        case WMFContentGroupKindFeaturedArticle:
            return [UIColor wmf_lightYellow];
        case WMFContentGroupKindOnThisDay:
            return [UIColor wmf_lightBlue];
        case WMFContentGroupKindTopRead:
            return [UIColor wmf_lightBlue];
        default:
            return [UIColor wmf_exploreSectionHeaderIconBackground];
    }
}

- (nullable NSString *)headerTitle {
    switch (self.contentGroupKind) {
        case WMFContentGroupKindContinueReading:
            return WMFLocalizedStringWithDefaultValue(@"explore-continue-reading-heading", nil, nil, @"Continue reading", @"Text for 'Continue Reading' header");
        case WMFContentGroupKindMainPage:
            return WMFLocalizedStringWithDefaultValue(@"explore-main-page-heading", nil, nil, @"Today on Wikipedia", @"Text for 'Today on Wikipedia' header");
        case WMFContentGroupKindRelatedPages:
            return WMFLocalizedStringWithDefaultValue(@"explore-because-you-read", nil, nil, @"Because you read", @"Text for 'Because you read' header");
        case WMFContentGroupKindLocation:
            return WMFLocalizedStringWithDefaultValue(@"explore-nearby-heading", nil, nil, @"Places near", @"Text for 'Nearby places' header. The next line of the header is the name of the nearest article.");
        case WMFContentGroupKindLocationPlaceholder:
            return WMFLocalizedStringWithDefaultValue(@"explore-nearby-placeholder-heading", nil, nil, @"Places", @"Nearby placeholder heading. The user hasn't granted location access so we show a generic section about Places on Wikipedia\n{{Identical|Place}}");
        case WMFContentGroupKindPictureOfTheDay:
            return WMFLocalizedStringWithDefaultValue(@"explore-potd-heading", nil, nil, @"Picture of the day", @"Text for 'Picture of the day' header");
        case WMFContentGroupKindRandom:
            return WMFLocalizedStringWithDefaultValue(@"explore-random-article-heading", nil, nil, @"Random article", @"Text for 'Random article' header\n{{Identical|Random article}}");
        case WMFContentGroupKindFeaturedArticle:
            return WMFLocalizedStringWithDefaultValue(@"explore-featured-article-heading", nil, nil, @"Featured article", @"Text for 'Featured article' header");
        case WMFContentGroupKindTopRead:
            return [self stringWithLocalizedCurrentSiteLanguageReplacingPlaceholderInString:WMFLocalizedStringWithDefaultValue(@"explore-most-read-heading", nil, nil, @"Top read on %1$@ Wikipedia", @"Text for 'Most read articles' explore section header. %1$@ is substituted for the localized language name (e.g. 'English' or 'Espanol').") fallingBackOnGenericString:WMFLocalizedStringWithDefaultValue(@"explore-most-read-generic-heading", nil, nil, @"Top read", @"Text for 'Most read articles' explore section header used when no language is present")];
        case WMFContentGroupKindNews:
            return WMFLocalizedStringWithDefaultValue(@"in-the-news-title", nil, nil, @"In the news", @"Title for the 'In the news' notification & feed section");
        case WMFContentGroupKindOnThisDay:
            return WMFLocalizedStringWithDefaultValue(@"on-this-day-title", nil, nil, @"On this day", @"Title for the 'On this day' feed section");
        case WMFContentGroupKindNotification:
            break;
        case WMFContentGroupKindAnnouncement:
            break;
        case WMFContentGroupKindUnknown:
        default:
            break;
    }
    return [[NSString alloc] init];
}

- (NSString *)stringWithLocalizedCurrentSiteLanguageReplacingPlaceholderInString:(NSString *)string fallingBackOnGenericString:(NSString *)genericString {
    // fall back to language code if it can't be localized
    NSString *language = [[NSLocale currentLocale] wmf_localizedLanguageNameForCode:self.siteURL.wmf_language];

    NSString *result = nil;

    //crash protection if language is nil
    if (language) {
        result = [NSString localizedStringWithFormat:string, language];
    } else {
        result = genericString;
    }
    return result;
}

- (nullable NSString *)headerSubTitle {
    switch (self.contentGroupKind) {
        case WMFContentGroupKindRelatedPages:
        case WMFContentGroupKindContinueReading: {
            NSString *subtitle = [self.contentMidnightUTCDate wmf_localizedRelativeDateFromMidnightUTCDate];
            if (subtitle == nil) {
                subtitle = [[self.date wmf_midnightUTCDateFromLocalDate] wmf_localizedRelativeDateFromMidnightUTCDate];
            }
            return subtitle ? subtitle : @"";
        } break;
        case WMFContentGroupKindMainPage:
            return [[NSDateFormatter wmf_dayNameMonthNameDayOfMonthNumberDateFormatter] stringFromDate:[NSDate date]];
            break;
        case WMFContentGroupKindLocation: {
            if (self.isForToday) {
                return WMFLocalizedStringWithDefaultValue(@"explore-nearby-sub-heading-your-location", nil, nil, @"Your location", @"Subtext beneath the 'Places near' header when showing articles near the user's current location.");
            } else if (self.placemark) {
                return [NSString stringWithFormat:@"%@, %@", self.placemark.name, self.placemark.locality];
            } else {
                return [NSString stringWithFormat:@"%f, %f", self.location.coordinate.latitude, self.location.coordinate.longitude];
            }
        } break;
        case WMFContentGroupKindLocationPlaceholder:
            return [self stringWithLocalizedCurrentSiteLanguageReplacingPlaceholderInString:WMFLocalizedStringWithDefaultValue(@"explore-nearby-placeholder-sub-heading-on-language-wikipedia", nil, nil, @"On %1$@ Wikipedia", @"Subtext beneath the 'Places' header when describing which specific Wikipedia. %1$@ will be replaced with the language - for example, 'On English Wikipedia'") fallingBackOnGenericString:WMFLocalizedStringWithDefaultValue(@"explore-nearby-placeholder-sub-heading-on-wikipedia", nil, nil, @"On Wikipedia", @"Subtext beneath the 'Places' header when the specific language wikipedia is unknown.")];
        case WMFContentGroupKindPictureOfTheDay:
            return [[NSDateFormatter wmf_dayNameMonthNameDayOfMonthNumberDateFormatter] stringFromDate:self.date];
        case WMFContentGroupKindRandom:
            return WMFLocalizedStringWithDefaultValue(@"onboarding-wikipedia", self.siteURL, nil, @"Wikipedia", @"Wikipedia logo text\n{{Identical|Wikipedia}}");
        case WMFContentGroupKindFeaturedArticle:
            return [[NSDateFormatter wmf_dayNameMonthNameDayOfMonthNumberDateFormatter] stringFromDate:self.date];
        case WMFContentGroupKindTopRead: {
            NSString *dateString = [self localContentDateDisplayString];
            if (!dateString) {
                dateString = @"";
            }

            return dateString;
        }
        case WMFContentGroupKindNews:
        case WMFContentGroupKindOnThisDay:
            return [self localDateDisplayString];
        case WMFContentGroupKindNotification:
            break;
        case WMFContentGroupKindAnnouncement:
            break;
        case WMFContentGroupKindUnknown:
        default:
            break;
    }
    return [[NSString alloc] init];
}

- (nullable UIColor *)headerTitleColor {
    switch (self.contentGroupKind) {
        case WMFContentGroupKindContinueReading:
            return [UIColor wmf_exploreSectionHeaderTitle];
        case WMFContentGroupKindMainPage:
            return [UIColor wmf_exploreSectionHeaderTitle];
        case WMFContentGroupKindRelatedPages:
            return [UIColor wmf_exploreSectionHeaderTitle];
        case WMFContentGroupKindLocation:
            return [UIColor wmf_exploreSectionHeaderTitle];
        case WMFContentGroupKindLocationPlaceholder:
            return [UIColor wmf_exploreSectionHeaderTitle];
        case WMFContentGroupKindPictureOfTheDay:
            return [UIColor wmf_exploreSectionHeaderTitle];
        case WMFContentGroupKindRandom:
            return [UIColor wmf_exploreSectionHeaderTitle];
        case WMFContentGroupKindFeaturedArticle:
            return [UIColor wmf_exploreSectionHeaderTitle];
        case WMFContentGroupKindTopRead:
            return [UIColor wmf_exploreSectionHeaderTitle];
        case WMFContentGroupKindNews:
            return [UIColor wmf_exploreSectionHeaderTitle];
        case WMFContentGroupKindOnThisDay:
            return [UIColor wmf_exploreSectionHeaderTitle];
        case WMFContentGroupKindNotification:
            break;
        case WMFContentGroupKindAnnouncement:
            break;
        case WMFContentGroupKindUnknown:
        default:
            break;
    }
    return [UIColor blackColor];
}

- (nullable UIColor *)headerSubTitleColor {
    switch (self.contentGroupKind) {
        case WMFContentGroupKindContinueReading:
            return [UIColor wmf_exploreSectionHeaderSubTitle];
        case WMFContentGroupKindMainPage:
            return [UIColor wmf_exploreSectionHeaderSubTitle];
        case WMFContentGroupKindRelatedPages:
            return [UIColor wmf_exploreSectionHeaderSubTitle];
        case WMFContentGroupKindLocation:
            return [UIColor wmf_exploreSectionHeaderSubTitle];
        case WMFContentGroupKindLocationPlaceholder:
            return [UIColor wmf_exploreSectionHeaderSubTitle];
        case WMFContentGroupKindPictureOfTheDay:
            return [UIColor wmf_exploreSectionHeaderSubTitle];
        case WMFContentGroupKindRandom:
            return [UIColor wmf_exploreSectionHeaderSubTitle];
        case WMFContentGroupKindFeaturedArticle:
            return [UIColor wmf_exploreSectionHeaderSubTitle];
        case WMFContentGroupKindTopRead:
            return [UIColor wmf_exploreSectionHeaderTitle];
        case WMFContentGroupKindNews:
            return [UIColor wmf_exploreSectionHeaderTitle];
        case WMFContentGroupKindOnThisDay:
            return [UIColor wmf_exploreSectionHeaderTitle];
        case WMFContentGroupKindNotification:
            break;
        case WMFContentGroupKindAnnouncement:
            break;
        case WMFContentGroupKindUnknown:
        default:
            break;
    }
    return [UIColor grayColor];
}

- (nullable NSURL *)headerContentURL {
    switch (self.contentGroupKind) {
        case WMFContentGroupKindContinueReading:
            break;
        case WMFContentGroupKindMainPage:
            break;
        case WMFContentGroupKindRelatedPages:
            return self.articleURL;
        case WMFContentGroupKindLocation:
            break;
        case WMFContentGroupKindLocationPlaceholder:
            break;
        case WMFContentGroupKindPictureOfTheDay:
            break;
        case WMFContentGroupKindRandom:
            break;
        case WMFContentGroupKindFeaturedArticle:
            break;
        case WMFContentGroupKindTopRead:
            break;
        case WMFContentGroupKindNews:
            break;
        case WMFContentGroupKindOnThisDay:
            break;
        case WMFContentGroupKindNotification:
            break;
        case WMFContentGroupKindAnnouncement:
            break;
        case WMFContentGroupKindUnknown:
        default:
            break;
    }
    return nil;
}

- (WMFFeedHeaderActionType)headerActionType {
    switch (self.contentGroupKind) {
        case WMFContentGroupKindContinueReading:
            break;
        case WMFContentGroupKindMainPage:
            break;
        case WMFContentGroupKindRelatedPages:
            return WMFFeedHeaderActionTypeOpenHeaderContent;
        case WMFContentGroupKindLocation:
            return WMFFeedHeaderActionTypeOpenMore;
        case WMFContentGroupKindLocationPlaceholder:
            break;
        case WMFContentGroupKindPictureOfTheDay:
            break;
        case WMFContentGroupKindRandom:
            break;
        case WMFContentGroupKindFeaturedArticle:
            break;
        case WMFContentGroupKindTopRead:
            return WMFFeedHeaderActionTypeOpenMore;
        case WMFContentGroupKindNews:
            return WMFFeedHeaderActionTypeOpenFirstItem;
        case WMFContentGroupKindOnThisDay:
            return WMFFeedHeaderActionTypeOpenFirstItem;
        case WMFContentGroupKindNotification:
            break;
        case WMFContentGroupKindAnnouncement:
            return WMFFeedHeaderActionTypeOpenHeaderNone;
        case WMFContentGroupKindUnknown:
        default:
            break;
    }
    return WMFFeedHeaderActionTypeOpenFirstItem;
}

- (WMFFeedBlacklistOption)blackListOptions {
    switch (self.contentGroupKind) {
        case WMFContentGroupKindContinueReading:
            break;
        case WMFContentGroupKindMainPage:
            break;
        case WMFContentGroupKindRelatedPages:
            return WMFFeedBlacklistOptionContent;
        case WMFContentGroupKindLocation:
            break;
        case WMFContentGroupKindLocationPlaceholder:
            return WMFFeedBlacklistOptionSection;
        case WMFContentGroupKindPictureOfTheDay:
            break;
        case WMFContentGroupKindRandom:
            break;
        case WMFContentGroupKindFeaturedArticle:
            break;
        case WMFContentGroupKindTopRead:
            break;
        case WMFContentGroupKindNews:
            break;
        case WMFContentGroupKindOnThisDay:
            break;
        case WMFContentGroupKindNotification:
            break;
        case WMFContentGroupKindAnnouncement:
            break;
        case WMFContentGroupKindUnknown:
        default:
            break;
    }
    return WMFFeedBlacklistOptionNone;
}

- (WMFFeedDisplayType)displayTypeForItemAtIndex:(NSInteger)index {
    switch (self.contentGroupKind) {
        case WMFContentGroupKindContinueReading:
            return WMFFeedDisplayTypeContinueReading;
        case WMFContentGroupKindMainPage:
            return WMFFeedDisplayTypeMainPage;
        case WMFContentGroupKindRelatedPages:
            return index == 0 ? WMFFeedDisplayTypeRelatedPagesSourceArticle : WMFFeedDisplayTypeRelatedPages;
        case WMFContentGroupKindLocation:
            return WMFFeedDisplayTypePageWithLocation;
        case WMFContentGroupKindLocationPlaceholder:
            return WMFFeedDisplayTypePageWithLocation;
        case WMFContentGroupKindPictureOfTheDay:
            return WMFFeedDisplayTypePhoto;
        case WMFContentGroupKindRandom:
            return WMFFeedDisplayTypeRandom;
        case WMFContentGroupKindFeaturedArticle:
            return WMFFeedDisplayTypePageWithPreview;
        case WMFContentGroupKindTopRead:
            return WMFFeedDisplayTypeRanked;
        case WMFContentGroupKindNews:
            return WMFFeedDisplayTypeStory;
        case WMFContentGroupKindOnThisDay:
            return WMFFeedDisplayTypeEvent;
        case WMFContentGroupKindNotification:
            return WMFFeedDisplayTypeNotification;
        case WMFContentGroupKindAnnouncement:
            return WMFFeedDisplayTypeAnnouncement;
        case WMFContentGroupKindUnknown:
        default:
            break;
    }
    return WMFFeedDisplayTypePage;
}

- (NSUInteger)maxNumberOfCells {
    switch (self.contentGroupKind) {
        case WMFContentGroupKindContinueReading:
            break;
        case WMFContentGroupKindMainPage:
            break;
        case WMFContentGroupKindRelatedPages:
            return 3;
        case WMFContentGroupKindLocation:
            return 3;
        case WMFContentGroupKindLocationPlaceholder:
            return 1;
        case WMFContentGroupKindPictureOfTheDay:
            break;
        case WMFContentGroupKindRandom:
            break;
        case WMFContentGroupKindFeaturedArticle:
            break;
        case WMFContentGroupKindTopRead:
            return 5;
        case WMFContentGroupKindNews:
            return 5;
        case WMFContentGroupKindOnThisDay:
            break;
        case WMFContentGroupKindNotification:
            break;
        case WMFContentGroupKindAnnouncement:
            return NSUIntegerMax;
        case WMFContentGroupKindUnknown:
        default:
            break;
    }
    return 1;
}

- (BOOL)prefersWiderColumn {
    switch (self.contentGroupKind) {
        case WMFContentGroupKindContinueReading:
            break;
        case WMFContentGroupKindMainPage:
            break;
        case WMFContentGroupKindRelatedPages:
            return YES /*FBTweakValue(@"Explore", @"General", @"Put 'Because You Read' in Wider Column", YES)*/;
        case WMFContentGroupKindLocation:
            break;
        case WMFContentGroupKindLocationPlaceholder:
            break;
        case WMFContentGroupKindPictureOfTheDay:
            return YES;
        case WMFContentGroupKindRandom:
            break;
        case WMFContentGroupKindFeaturedArticle:
            return YES;
        case WMFContentGroupKindTopRead:
            break;
        case WMFContentGroupKindNews:
            return YES;
        case WMFContentGroupKindOnThisDay:
            return YES;
        case WMFContentGroupKindNotification:
            return YES;
        case WMFContentGroupKindAnnouncement:
            return YES;
        case WMFContentGroupKindUnknown:
        default:
            break;
    }
    return NO;
}

- (WMFFeedDetailType)detailType {
    switch (self.contentGroupKind) {
        case WMFContentGroupKindContinueReading:
            break;
        case WMFContentGroupKindMainPage:
            break;
        case WMFContentGroupKindRelatedPages:
            break;
        case WMFContentGroupKindLocation:
            break;
        case WMFContentGroupKindLocationPlaceholder:
            break;
        case WMFContentGroupKindPictureOfTheDay:
            return WMFFeedDetailTypeGallery;
        case WMFContentGroupKindRandom:
            return WMFFeedDetailTypePageWithRandomButton;
        case WMFContentGroupKindFeaturedArticle:
            break;
        case WMFContentGroupKindTopRead:
            break;
        case WMFContentGroupKindNews:
            return WMFFeedDetailTypeStory;
        case WMFContentGroupKindOnThisDay:
            return WMFFeedDetailTypeEvent;
        case WMFContentGroupKindNotification:
            return WMFFeedDetailTypeNone;
        case WMFContentGroupKindAnnouncement:
            return WMFFeedDetailTypeNone;
        case WMFContentGroupKindUnknown:
        default:
            break;
    }
    return WMFFeedDetailTypePage;
}

- (nullable NSString *)footerText {
    switch (self.contentGroupKind) {
        case WMFContentGroupKindContinueReading:
            break;
        case WMFContentGroupKindMainPage:
            break;
        case WMFContentGroupKindRelatedPages:
            return self.moreLikeTitle;
        case WMFContentGroupKindLocation: {
            if (self.isForToday) {
                return WMFLocalizedStringWithDefaultValue(@"home-nearby-footer", nil, nil, @"More from nearby your location", @"Footer for presenting user option to see longer list of nearby articles.");
            } else {
                return [NSString localizedStringWithFormat:WMFLocalizedStringWithDefaultValue(@"home-nearby-location-footer", nil, nil, @"More nearby %1$@", @"Footer for presenting user option to see longer list of articles nearby a specific location. %1$@ will be replaced with the name of the location"), self.placemark.name];
            }
        }
        case WMFContentGroupKindLocationPlaceholder: {
            if (self.isForToday) {
                return WMFLocalizedStringWithDefaultValue(@"home-nearby-footer", nil, nil, @"More from nearby your location", @"Footer for presenting user option to see longer list of nearby articles.");
            } else {
                return [NSString localizedStringWithFormat:WMFLocalizedStringWithDefaultValue(@"home-nearby-location-footer", nil, nil, @"More nearby %1$@", @"Footer for presenting user option to see longer list of articles nearby a specific location. %1$@ will be replaced with the name of the location"), self.placemark.name];
            }
        }
        case WMFContentGroupKindPictureOfTheDay:
            break;
        case WMFContentGroupKindRandom:
            return WMFLocalizedStringWithDefaultValue(@"explore-another-random", nil, nil, @"Another random article", @"Displayed on buttons that indicate they would load 'Another random article'");
        case WMFContentGroupKindFeaturedArticle:
            break;
        case WMFContentGroupKindTopRead: {
            NSString *dateString = [self localContentDateShortDisplayString];
            if (!dateString) {
                dateString = @"";
            }

            return
                [NSString localizedStringWithFormat:WMFLocalizedStringWithDefaultValue(@"explore-most-read-footer-for-date", nil, nil, @"All top read articles on %1$@", @"Text which shown on the footer beneath 'Most read articles', which presents a longer list of 'most read' articles for a given date when tapped. %1$@ will be substituted with the date"), dateString];
        }
        case WMFContentGroupKindNews:
            return WMFLocalizedStringWithDefaultValue(@"home-news-footer", nil, nil, @"More in the news", @"Footer for presenting user option to see longer list of news stories.");
        case WMFContentGroupKindOnThisDay:
            return WMFLocalizedStringWithDefaultValue(@"on-this-day-footer", nil, nil, @"More historical events on this day", @"Footer for presenting user option to see longer list of 'On this day' articles.");
        case WMFContentGroupKindNotification:
            break;
        case WMFContentGroupKindAnnouncement:
            break;
        case WMFContentGroupKindUnknown:
        default:
            break;
    }
    return nil;
}

- (WMFFeedMoreType)moreType {
    switch (self.contentGroupKind) {
        case WMFContentGroupKindContinueReading:
            break;
        case WMFContentGroupKindMainPage:
            break;
        case WMFContentGroupKindRelatedPages:
            return WMFFeedMoreTypePageList;
        case WMFContentGroupKindLocation:
            return WMFFeedMoreTypePageListWithLocation;
        case WMFContentGroupKindLocationPlaceholder:
            return WMFFeedMoreTypeLocationAuthorization;
        case WMFContentGroupKindPictureOfTheDay:
            break;
        case WMFContentGroupKindRandom:
            return WMFFeedMoreTypePageWithRandomButton;
        case WMFContentGroupKindFeaturedArticle:
            break;
        case WMFContentGroupKindTopRead:
            return WMFFeedMoreTypePageList;
        case WMFContentGroupKindNews:
            return WMFFeedMoreTypeNews;
        case WMFContentGroupKindOnThisDay:
            return WMFFeedMoreTypeOnThisDay;
        case WMFContentGroupKindNotification:
            break;
        case WMFContentGroupKindAnnouncement:
            break;
        case WMFContentGroupKindUnknown:
        default:
            break;
    }
    return WMFFeedMoreTypeNone;
}

- (nullable NSString *)moreLikeTitle {
    return [NSString localizedStringWithFormat:WMFLocalizedStringWithDefaultValue(@"home-more-like-footer", nil, nil, @"More like %1$@", @"Footer for presenting user option to see longer list of articles related to a previously read article. %1$@ will be replaced with the name of the previously read article."), self.articleURL.wmf_title];
}

- (nullable NSString *)moreTitle {
    switch (self.contentGroupKind) {
        case WMFContentGroupKindContinueReading:
            break;
        case WMFContentGroupKindMainPage:
            break;
        case WMFContentGroupKindRelatedPages:
            return self.moreLikeTitle;
        case WMFContentGroupKindLocation:
            return WMFLocalizedStringWithDefaultValue(@"main-menu-nearby", nil, nil, @"Nearby", @"Button for showing nearby articles.\n{{Identical|Nearby}}");
        case WMFContentGroupKindLocationPlaceholder:
            break;
        case WMFContentGroupKindPictureOfTheDay:
            break;
        case WMFContentGroupKindRandom:
            break;
        case WMFContentGroupKindFeaturedArticle:
            break;
        case WMFContentGroupKindTopRead:
            return [self topReadMoreTitleForDate:self.contentMidnightUTCDate];
        case WMFContentGroupKindNews:
            break;
        case WMFContentGroupKindOnThisDay:
            break;
        case WMFContentGroupKindNotification:
            break;
        case WMFContentGroupKindAnnouncement:
            break;
        case WMFContentGroupKindUnknown:
        default:
            break;
    }
    return nil;
}

- (nullable NSNumber *)analyticsValue {
    switch (self.contentGroupKind) {
        case WMFContentGroupKindContinueReading:
            break;
        case WMFContentGroupKindMainPage:
            break;
        case WMFContentGroupKindRelatedPages:
            break;
        case WMFContentGroupKindLocation:
            break;
        case WMFContentGroupKindLocationPlaceholder:
            break;
        case WMFContentGroupKindPictureOfTheDay:
            break;
        case WMFContentGroupKindRandom:
            break;
        case WMFContentGroupKindFeaturedArticle:
            break;
        case WMFContentGroupKindTopRead:
            break;
        case WMFContentGroupKindNews:
            break;
        case WMFContentGroupKindOnThisDay:
            break;
        case WMFContentGroupKindNotification:
            break;
        case WMFContentGroupKindAnnouncement: {
            static dispatch_once_t onceToken;
            static NSCharacterSet *nonNumericCharacterSet;
            dispatch_once(&onceToken, ^{
                nonNumericCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
            });

            WMFAnnouncement *_Nullable announcement = (WMFAnnouncement * _Nullable) self.content.firstObject;
            if (![announcement isKindOfClass:[WMFAnnouncement class]]) {
                return nil;
            }

            NSString *numberString = [announcement.identifier stringByTrimmingCharactersInSet:nonNumericCharacterSet];
            NSInteger integer = [numberString integerValue];
            return @(integer);
        }
        case WMFContentGroupKindUnknown:
        default:
            break;
    }

    return nil;
}

- (NSString *)analyticsContentType {
    switch (self.contentGroupKind) {
        case WMFContentGroupKindContinueReading:
            return @"Continue Reading";
        case WMFContentGroupKindMainPage:
            return @"Main Page";
        case WMFContentGroupKindRelatedPages:
            return @"Recommended";
        case WMFContentGroupKindLocation:
            return @"Nearby";
        case WMFContentGroupKindLocationPlaceholder:
            return @"Nearby Placeholder";
        case WMFContentGroupKindPictureOfTheDay:
            return @"Picture of the Day";
        case WMFContentGroupKindRandom:
            return @"Random";
        case WMFContentGroupKindFeaturedArticle:
            return @"Featured";
        case WMFContentGroupKindTopRead:
            return @"Most Read";
        case WMFContentGroupKindNews:
            return @"In The News";
        case WMFContentGroupKindOnThisDay:
            return @"On This Day";
        case WMFContentGroupKindNotification:
            return @"Notifications";
        case WMFContentGroupKindAnnouncement:
            return @"Announcement";
        case WMFContentGroupKindUnknown:
        default:
            break;
    }
    return @"Unknown Content Type";
}

- (WMFFeedHeaderType)headerType {
    switch (self.contentGroupKind) {
        case WMFContentGroupKindContinueReading:
            break;
        case WMFContentGroupKindMainPage:
            break;
        case WMFContentGroupKindRelatedPages:
            break;
        case WMFContentGroupKindLocation:
            break;
        case WMFContentGroupKindLocationPlaceholder:
            break;
        case WMFContentGroupKindPictureOfTheDay:
            break;
        case WMFContentGroupKindRandom:
            break;
        case WMFContentGroupKindFeaturedArticle:
            break;
        case WMFContentGroupKindTopRead:
            break;
        case WMFContentGroupKindNews:
            break;
        case WMFContentGroupKindOnThisDay:
            break;
        case WMFContentGroupKindNotification:
            return WMFFeedHeaderTypeNone;
        case WMFContentGroupKindAnnouncement:
            return WMFFeedHeaderTypeNone;
        case WMFContentGroupKindUnknown:
        default:
            break;
    }
    return WMFFeedHeaderTypeStandard;
}

/**
 *  String to display to the user for the receiver's date.
 *
 *  "Most read" articles are computed for UTC dates. UTC time zone is used because converting to the user's time zone
 *  might accidentally change the "day" the app displays based on the the offset between UTC & the device's default time
 *  zone.  For example: 02/12/2016 01:26 UTC converted to EST is 02/11/2016 20:26, one day off!
 *
 *  @return A string formatted with the current locale, in the UTC time zone.
 */
- (NSString *)localContentDateDisplayString {
    return [[NSDateFormatter wmf_utcDayNameMonthNameDayOfMonthNumberDateFormatter] stringFromDate:self.contentMidnightUTCDate];
}

- (NSString *)localContentDateShortDisplayString {
    return [[NSDateFormatter wmf_utcShortDayNameShortMonthNameDayOfMonthNumberDateFormatter] stringFromDate:self.contentMidnightUTCDate];
}

- (NSString *)topReadMoreTitleForDate:(NSDate *)date {
    return
        [NSString localizedStringWithFormat:WMFLocalizedStringWithDefaultValue(@"explore-most-read-more-list-title-for-date", nil, nil, @"Top on %1$@", @"Title with date for the view displaying longer list of top read articles. %1$@ will be substituted with the date"), [[NSDateFormatter wmf_utcShortDayNameShortMonthNameDayOfMonthNumberDateFormatter] stringFromDate:date]];
}

- (NSString *)localDateDisplayString {
    return [[NSDateFormatter wmf_utcDayNameMonthNameDayOfMonthNumberDateFormatter] stringFromDate:self.midnightUTCDate];
}

@end

NS_ASSUME_NONNULL_END
