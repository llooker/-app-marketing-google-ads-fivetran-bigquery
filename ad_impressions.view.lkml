include: "/app_marketing_analytics_config/adwords_config.view"

include: "ad.view"
include: "geotargeting.view"
include: "keyword.view"
include: "video.view"

view: hour_base {
  extension: required

  dimension: hour_of_day {
    hidden: yes
    type: number
    sql: ${TABLE}.hour_of_day ;;
  }
}

view: transformations_base {
  extension: required

  dimension: ad_network_type {
    hidden: yes
    type: string
    case: {
      when: {
        sql: ${ad_network_type1} = 'SHASTA_AD_NETWORK_TYPE_1_SEARCH' AND ${ad_network_type2} = 'SHASTA_AD_NETWORK_TYPE_2_SEARCH' ;;
        label: "Search"
      }
      when: {
        sql: ${ad_network_type1} = 'SHASTA_AD_NETWORK_TYPE_1_SEARCH' AND ${ad_network_type2} = 'SHASTA_AD_NETWORK_TYPE_2_SEARCH_PARTNERS' ;;
        label: "Search Partners"
      }
      when: {
        sql: ${ad_network_type1} = 'SHASTA_AD_NETWORK_TYPE_1_CONTENT' ;;
        label: "Content"
      }
      else: "Other"
    }
  }

  dimension: device_type {
    hidden: yes
    type: string
    case: {
      when: {
        sql: ${device} LIKE '%Desktop%' ;;
        label: "Desktop"
      }
      when: {
        sql: ${device} LIKE '%Mobile%' ;;
        label: "Mobile"
      }
      when: {
        sql: ${device} LIKE '%Tablet%' ;;
        label: "Tablet"
      }
      else: "Other"
    }
  }
}

explore: ad_impressions_adapter {
  persist_with: adwords_etl_datagroup
  label: "Ad Impressions"
  view_label: "Ad Impressions"
  from: ad_impressions_adapter
  view_name: fact
  hidden: yes

  join: customer {
    from: customer_adapter
    view_label: "Customer"
    sql_on: ${fact.external_customer_id} = ${customer.external_customer_id} AND
      ${customer.latest} ;;
    relationship: many_to_one
  }
}

view: ad_impressions_adapter {
  extends: [adwords_config, google_adwords_base, transformations_base]
  sql_table_name: {{ fact.adwords_schema._sql }}.account_hourly_stats ;;

  dimension: average_position {
    hidden: yes
    type: number
    sql: ${TABLE}.average_position ;;
  }

  dimension: active_view_impressions {
    hidden: yes
    type: number
    sql: ${TABLE}.active_view_impressions ;;
  }

  dimension: active_view_measurability {
    hidden: yes
    type: number
    sql: ${TABLE}.active_view_measurability ;;
  }

  dimension: active_view_measurable_cost {
    hidden: yes
    type: number
    sql: ${TABLE}.active_view_measurable_cost ;;
  }

  dimension: active_view_measurable_impressions {
    hidden: yes
    type: number
    sql: ${TABLE}.active_view_measurable_impressions ;;
  }

  dimension: active_view_viewability {
    hidden: yes
    type: number
    sql: ${TABLE}.active_view_viewability ;;
  }

  dimension: ad_network_type1 {
    hidden: yes
    type: string
    sql: ${TABLE}.ad_network_type_1 ;;
  }

  dimension: ad_network_type2 {
    hidden: yes
    type: string
    sql: ${TABLE}.ad_network_type_2 ;;
  }

  dimension: clicks {
    hidden: yes
    type: number
    sql: ${TABLE}.clicks ;;
  }

  dimension: conversions {
    hidden: yes
    type: number
    sql: ${TABLE}.conversions ;;
  }

  dimension: conversionvalue {
    hidden: yes
    type: number
    sql: ${TABLE}.conversionvalue ;;
  }

  dimension: cost {
    hidden: yes
    type: number
    sql: ${TABLE}.cost / 1000000;;
  }

  dimension: device {
    hidden: yes
    type: string
    sql: ${TABLE}.device ;;
  }

  dimension: impressions {
    hidden: yes
    type: number
    sql: ${TABLE}.impressions ;;
  }

  dimension: interactions {
    hidden: yes
    type: number
    sql: ${TABLE}.interactions ;;
  }

  dimension: interaction_types {
    hidden: yes
    type: string
    sql: ${TABLE}.interaction_types ;;
  }

  dimension: view_through_conversions {
    hidden: yes
    type: number
    sql: ${TABLE}.view_through_conversions ;;
  }
}

explore: ad_impressions_hour_adapter {
  persist_with: adwords_etl_datagroup
  extends: [ad_impressions_adapter]
  from: ad_impressions_hour_adapter
  view_name: fact
}

view: ad_impressions_hour_adapter {
  extends: [ad_impressions_adapter, hour_base]
}

explore: ad_impressions_campaign_adapter {
  extends: [ad_impressions_adapter]
  from: ad_impressions_campaign_adapter
  view_name: fact

  join: campaign {
    from: campaign_adapter
    view_label: "Campaign"
    sql_on: ${fact.campaign_id} = ${campaign.campaign_id} AND
      ${fact.external_customer_id} = ${campaign.external_customer_id} AND
      ${campaign.latest};;
    relationship: many_to_one
  }
}

view: ad_impressions_campaign_adapter {
  extends: [ad_impressions_adapter]
  sql_table_name: {{ fact.adwords_schema._sql }}.campaign_hourly_stats ;;


  dimension: base_campaign_id {
    hidden: yes
    sql: ${TABLE}.BaseCampaignId ;;
  }

  dimension: campaign_id {
    hidden: yes
    sql: ${TABLE}.CampaignId ;;
  }

  dimension: campaign_id_string {
    hidden: yes
    sql: CAST(${campaign_id} as STRING) ;;
  }
}

explore: ad_impressions_campaign_hour_adapter {
  persist_with: adwords_etl_datagroup
  extends: [ad_impressions_campaign_adapter]
  from: ad_impressions_campaign_hour_adapter
  view_name: fact
}

view: ad_impressions_campaign_hour_adapter {
  extends: [ad_impressions_campaign_adapter, hour_base]
}

explore: ad_impressions_ad_group_adapter {
  persist_with: adwords_etl_datagroup
  extends: [ad_impressions_campaign_adapter]
  from: ad_impressions_ad_group_adapter
  view_name: fact

  join: ad_group {
    from: ad_group_adapter
    view_label: "Ad Groups"
    sql_on: ${fact.ad_group_id} = ${ad_group.ad_group_id} AND
      ${fact.campaign_id} = ${ad_group.campaign_id} AND
      ${fact.external_customer_id} = ${ad_group.external_customer_id} AND
      ${ad_group.latest} ;;
    relationship: many_to_one
  }
}

view: ad_impressions_ad_group_adapter {
  extends: [ad_impressions_campaign_adapter]
  sql_table_name: {{ fact.adwords_schema._sql }}.ad_group_stats ;;

  dimension: ad_group_id {
    hidden: yes
    sql: ${TABLE}.ad_group_id ;;
  }

  dimension: ad_group_id_string {
    hidden: yes
    sql: CAST(${ad_group_id} as STRING) ;;
  }

  dimension: base_ad_group_id {
    hidden: yes
    sql: ${TABLE}.base_ad_group_id ;;
  }
}

explore: ad_impressions_ad_group_hour_adapter {
  persist_with: adwords_etl_datagroup
  extends: [ad_impressions_ad_group_adapter]
  from: ad_impressions_ad_group_hour_adapter
  view_name: fact
}

view: ad_impressions_ad_group_hour_adapter {
  extends: [ad_impressions_ad_group_adapter, hour_base]
}

explore: ad_impressions_keyword_adapter {
  persist_with: adwords_etl_datagroup
  extends: [ad_impressions_ad_group_adapter]
  from: ad_impressions_keyword_adapter
  view_name: fact

  join: keyword {
    from: keyword_adapter
    view_label: "Keyword"
    sql_on: ${fact.criterion_id} = ${keyword.criterion_id} AND
      ${fact.ad_group_id} = ${keyword.ad_group_id} AND
      ${fact.campaign_id} = ${keyword.campaign_id} AND
      ${fact.external_customer_id} = ${keyword.external_customer_id} AND
      ${keyword.latest} ;;
    relationship: many_to_one
  }
}

view: ad_impressions_keyword_adapter {
  extends: [ad_impressions_ad_group_adapter]
  sql_table_name: {{ fact.adwords_schema._sql }}.keyword_stats ;;

  dimension: criterion_id {
    hidden: yes
    sql: ${TABLE}.id ;;
  }

  dimension: criterion_id_string {
    hidden: yes
    sql: CAST(${criterion_id} as STRING) ;;
  }

  dimension: slot {
    hidden: yes
    type: string
    sql: ${TABLE}.slot ;;
  }
}

explore: ad_impressions_ad_adapter {
  persist_with: adwords_etl_datagroup
  extends: [ad_impressions_keyword_adapter]
  from: ad_impressions_ad_adapter
  view_name: fact

  join: ad {
    from: ad_adapter
    view_label: "Ads"
    sql_on: ${fact.creative_id} = ${ad.creative_id} AND
      ${fact.ad_group_id} = ${ad.ad_group_id} AND
      ${fact.campaign_id} = ${ad.campaign_id} AND
      ${fact.external_customer_id} = ${ad.external_customer_id} AND
      ${ad.latest} ;;
    relationship:  many_to_one
  }
}

view: ad_impressions_ad_adapter {
  extends: [ad_impressions_keyword_adapter]
  sql_table_name: {{ fact.adwords_schema._sql }}.ad_stats ;;

  dimension: criterion_id {
    hidden: yes
    sql: ${TABLE}.criterion_id ;;
  }

  dimension: criterion_type {
    hidden: yes
    sql: ${TABLE}.criterion_type ;;
  }

  dimension: creative_id {
    hidden: yes
    sql: ${TABLE}.id ;;
  }

  dimension: creative_id_string {
    hidden: yes
    sql: CAST(${creative_id} as STRING) ;;
  }
}

explore: ad_impressions_geo_adapter {
  persist_with: adwords_etl_datagroup
  extends: [ad_impressions_ad_group_adapter]
  from: ad_impressions_geo_adapter
  view_name: fact

  join: geo_country {
    from: geotargeting
    view_label: "Country"
    fields: [country_code]
    sql_on: ${fact.country_criteria_id} = ${geo_country.criteria_id} ;;
    relationship: many_to_one
  }

  join: geo_us_state {
    from: geotargeting
    view_label: "US State"
    fields: [state]
    sql_on: ${fact.region_criteria_id} = ${geo_us_state.criteria_id} AND
      ${geo_us_state.is_us_state} ;;
    relationship: many_to_one
    type: inner
  }

  join: geo_us_postal_code {
    from: geotargeting
    view_label: "US Postal Code"
    fields: [postal_code]
    sql_on: ${fact.most_specific_criteria_id} = ${geo_us_postal_code.criteria_id} AND
      ${geo_us_postal_code.is_us_postal_code} ;;
    relationship: many_to_one
    type: inner
  }

  join: geo_us_postal_code_state {
    from: geotargeting
    view_label: "US Postal Code"
    fields: [state]
    sql_on: ${geo_us_postal_code.parent_id} = ${geo_us_postal_code_state.criteria_id} AND
      ${geo_us_postal_code_state.is_us_state} ;;
    relationship: many_to_one
    type: inner
    required_joins: [geo_us_postal_code]
  }

  join: geo_region {
    from: geotargeting
    view_label: "Region"
    fields: [name, country_code]
    sql_on: ${fact.region_criteria_id} = ${geo_region.criteria_id} ;;
    relationship: many_to_one
  }

  join: geo_metro {
    from: geotargeting
    view_label: "Metro"
    fields: [name, country_code]
    sql_on: ${fact.metro_criteria_id} = ${geo_metro.criteria_id} ;;
    relationship: many_to_one
  }

  join: geo_city {
    from: geotargeting
    view_label: "City"
    fields: [name, country_code]
    sql_on: ${fact.city_criteria_id} = ${geo_city.criteria_id} ;;
    relationship: many_to_one
  }
}

view: ad_impressions_geo_adapter {
  extends: [ad_impressions_ad_group_adapter]
  sql_table_name: {{ fact.adwords_schema._sql }}.GeoStats ;;

  dimension: city_criteria_id {
    hidden: yes
    type: number
    sql: ${TABLE}.city_criteria_id ;;
  }

  dimension: country_criteria_id {
    hidden: yes
    type: number
    sql: ${TABLE}.country_criteria_id  ;;
  }

  dimension: metro_criteria_id {
    hidden: yes
    type: number
    sql: ${TABLE}.metro_criteria_id  ;;
  }

  dimension: most_specific_criteria_id {
    hidden: yes
    type: number
    sql: ${TABLE}.most_specific_criteria_id  ;;
  }

  dimension: region_criteria_id {
    hidden: yes
    type: number
    sql: ${TABLE}.region_criteria_id  ;;
  }
}
