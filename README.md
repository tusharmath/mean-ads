##Concepts for version 0.0.0

1. Campaigns
    - Template Type: Style of the campaign
    - Ad Collection: Collection of ad details
    - Credit Measured: Click, Impressions, Date
    - Selection Algo:
        * Round robin
        * least shown/clicked
        * weighted selections
        * budget based
        * <:custom>

2. Keywords
    - A string OR a collection of strings

3. AD-Slot
    - Keywords
    - Total Credit

4. Ad
    - Is for a campaign
    - Has a client-id for reference with user who bought the ad
    - Rendering data: title, description, images etc.
    - Expiry date
    - Credits: Ads Stops after credit becomes 0.

5. Styles
    - Has a name identifier.
    - DotJS/Handlebar/underscore templating engine.
    - Pure HTML + CSS.

6. REST API: Fetch Ads
    - Requests made via JSONP form client side.
    - Request /:campaign-name?keywords=a,b,c&count=1
    - Response: ads

7.  REST API: Others
    - Save Clicks
    - Save Impressions
