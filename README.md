# Google AdWords: BigQuery Data Transfer Service

### Dependencies

This adapter relies on a project `app_marketing_analytics_config` as specified in the manifest.lkml file. This project needs to include an `adwords_config.view.lkml` file.

For example:

```LookML
view: adwords_config {
  extension: required

  dimension: adwords_schema {
    hidden: yes
    sql:adwords;;
  }

  dimension: adwords_customer_id {
    hidden: yes
    sql:1234567890;;
  }
}
```

### Interface
#### Account Structure

ad.view:
 - ad_adapter
   - external_customer_id
   - campaign_id
   - ad_group_id
   - creative_id
   - creative
   - status_active

ad_group.view:
 - ad_group_adapter
   - external_customer_id
   - campaign_id
   - ad_group_id
   - ad_group_name
   - status_active

campaign.view:
 - campaign_adapter
   - external_customer_id
   - campaign_id
   - campaign_name
   - status_active
   - budget_id
   - amount

customer.view:
 - customer_adapter
   - external_customer_id

#### Targeting Criteria

age_range.view
 - age_range

audience.view
 - audience_adapter

gender.view
 - gender_adapter

geo.view
 - geotargeting
   - state
   - country_code
   - name
   - postal_code

keyword.view
 - keyword_adapter
   - external_customer_id
   - campaign_id
   - ad_group_id
   - criterion_id
   - criteria
   - status_active
   - bidding_strategy_type

parental_status.view
 - parental_status

video.view
 - video

#### Reports

ad_impressions.view
 - _date
 - ad_network_type
 - device_type
 - cost
 - impressions
 - interactions
 - clicks
 - conversions
 - conversionvalue
 - averageposition

Account Stats
 - ad_impressions_adapter
 - ad_impressions_hour_adapter
   - hour_of_day

Campaign Stats
 - ad_impressions_campaign_adapter
 - ad_impressions_campaign_hour_adapter
   - hour_of_day

Ad Group Stats
 - ad_impressions_ad_group_adapter
 - ad_impressions_ad_group_hour_adapter
   - hour_of_day

Keyword Stats
 - ad_impressions_keyword_adapter

Ad Stats
 - ad_impressions_ad_adapter

Targeting Reports
 - ad_impressions * [age_range, audience, gender, geo, parental_status, video]


### Block Info

This Block is modeled on the schema from Google's [BigQuery Transfer Service](https://cloud.google.com/bigquery/transfer/).

The schema documentation for AdWords can be found in [Google's docs](https://developers.google.com/adwords/api/docs/appendix/reports).

### Google AdWords Raw Data Structure

* **Entity Tables and Stats Tables** - There are several primary entities included in the AdWords data set, such as ad, ad group, campaign, customer, keyword, etc.. Each of these tables has a corresponding "Stats" table, which includes all the various metrics for that entity. For example, the "campaign" entity table contains attributes for each campaign, such as the campaign name and campaign status. The corresponding stats table - "Campaign Basic Stats" contains metrics such as impressions, clicks, and conversions. These stats tables are mapped to an ad_impression explore as an interface to the Looker Marketing Analytics application.

* **Snapshots** - AdWords tables keep records over time by snapshotting all data at the end of each day. The following day, a new snapshot is taken, and appended to the table. There are two columns on each table: `_DATA_DATE` and `_LATEST_DATE`. `_DATA_DATE` tells you the day the data was recorded, while `_LATEST_DATE` is an immutable field that tells you the most recent date a snapshot was taken. Querying the table using `_DATA_DATE` = `_LATEST_DATE` in the `WHERE` clause would give you only the data for the latest day.


### Reporting Schema Layout

![image](https://cloud.githubusercontent.com/assets/9888083/26472690/18f621d0-415c-11e7-85fc-e77334847757.png)
