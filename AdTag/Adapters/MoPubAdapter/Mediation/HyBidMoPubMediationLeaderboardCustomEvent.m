//
//  Copyright © 2018 PubNative. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "HyBidMoPubMediationLeaderboardCustomEvent.h"
#import "HyBidMoPubUtils.h"
#import "MPLogging.h"
#import "MPConstants.h"
#import "MPError.h"

@interface HyBidMoPubMediationLeaderboardCustomEvent()  <HyBidAdViewDelegate>

@property (nonatomic, strong) HyBidLeaderboardAdView *leaderboardAdView;

@end

@implementation HyBidMoPubMediationLeaderboardCustomEvent

- (void)dealloc
{
    [self.leaderboardAdView stopTracking];
    self.leaderboardAdView = nil;
}

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info
{
    if ([HyBidMoPubUtils areExtrasValid:info]) {
        if (CGSizeEqualToSize(MOPUB_LEADERBOARD_SIZE, size)) {
            if ([HyBidMoPubUtils appToken:info] != nil || [[HyBidMoPubUtils appToken:info] isEqualToString:[HyBidSettings sharedInstance].appToken]) {
                self.leaderboardAdView = [[HyBidLeaderboardAdView alloc] init];
                [self.leaderboardAdView loadWithZoneID:[HyBidMoPubUtils zoneID:info] andWithDelegate:self];
            } else {
                [self invokeFailWithMessage:@"HyBid - The provided app token doesn't match the one used to initialise HyBid."];
                return;
            }
        } else {
            [self invokeFailWithMessage:@"HyBid - Error: Wrong ad size."];
            return;
        }
    } else {
        [self invokeFailWithMessage:@"HyBid - Error: Failed leaderboard ad fetch. Missing required server extras."];
        return;
    }
}

- (void)invokeFailWithMessage:(NSString *)message
{
    MPLogError(message);
    [self.delegate bannerCustomEvent:self
            didFailToLoadAdWithError:[NSError errorWithDomain:message
                                                         code:0
                                                     userInfo:nil]];
}

- (BOOL)enableAutomaticImpressionAndClickTracking
{
    return NO;
}

- (void)didDisplayAd
{
    [self.leaderboardAdView startTracking];
}

#pragma mark - HyBidAdViewDelegate

- (void)adViewDidLoad:(HyBidAdView *)adView
{
    [self.delegate bannerCustomEvent:self didLoadAd:self.leaderboardAdView];
}

- (void)adView:(HyBidAdView *)adView didFailWithError:(NSError *)error
{
    [self invokeFailWithMessage:[NSString stringWithFormat:@"HyBid - Internal Error: %@", error.localizedDescription]];
}

- (void)adViewDidTrackImpression:(HyBidAdView *)adView
{
    [self.delegate trackImpression];
}

- (void)adViewDidTrackClick:(HyBidAdView *)adView
{
    [self.delegate trackClick];
    [self.delegate bannerCustomEventWillLeaveApplication:self];
}

@end
