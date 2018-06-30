include: "/app_marketing_analytics_config/adwords_config.view"

include: "google_ad_metrics_base.view"
include: "ad.view"
include: "geotargeting.view"
include: "keyword.view"

view: hour_base {
  extension: required

  dimension: hour_of_day {
    hidden: yes
    type: number
    sql: ${TABLE}.hour_of_day ;;
  }

  dimension: hour_of_day_string {
    hidden: yes
    sql: CAST(${TABLE}.hour_of_day AS STRING) ;;
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
  extends: [customer_join]
  from: ad_impressions_adapter
  view_name: fact
  hidden: yes
  group_label: "Google AdWords"
  label: "AdWord Impressions"
  view_label: "Impressions"
}

view: ad_impressions_derived_table {
  extension: required
  derived_table: {
    datagroup_trigger: adwords_etl_datagroup
    explore_source: ad_impressions_hour_adapter {
      column: date { field: fact._date }
      column: external_customer_id { field: fact.external_customer_id }
      column: ad_network_type_1 { field: fact.ad_network_type1 }
      column: ad_network_type_2 { field: fact.ad_network_type2 }
      column: device { field: fact.device }
      column: average_position {field: fact.weighted_average_position}
      column: clicks {field: fact.total_clicks }
      column: conversions {field: fact.total_conversions}
      column: conversion_value {field: fact.total_conversionvalue}
      column: cost {field: fact.total_cost}
      column: impressions { field: fact.total_impressions}
      column: interactions {field: fact.total_interactions}
    }
  }
}

view: ad_impressions_adapter {
  extends: [ad_impressions_derived_table, ad_impressions_adapter_base]
}

view: ad_impressions_adapter_base {
  extension: required
  extends: [adwords_config, google_adwords_base, transformations_base, google_ad_metrics_base]

  dimension: account_primary_key {
    hidden: yes
    sql: concat(
      ${date_string}, "|",
      ${external_customer_id_string}, "|",
      ${ad_network_type1},  "|",
      ${ad_network_type2}, "|",
      ${device}) ;;
  }

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: ${account_primary_key} ;;
  }

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
    sql: ${TABLE}.conversion_value ;;
  }

  dimension: cost {
    hidden: yes
    type: number
    sql: ${TABLE}.cost ;;
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
  extends: [ad_impressions_adapter]
  from: ad_impressions_hour_adapter
  view_name: fact
  group_label: "Google AdWords"
  label: "AdWord Impressions by Hour"
  view_label: "Impressions by Hour"
}

view: ad_impressions_hour_adapter {
  extends: [ad_impressions_adapter_base, hour_base]
  sql_table_name: {{ fact.adwords_schema._sql }}.account_hourly_stats ;;

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: concat(${account_primary_key}, "|", ${hour_of_day_string}) ;;
  }
}

explore: ad_impressions_campaign_adapter {
  extends: [ad_impressions_adapter, campaign_join]
  from: ad_impressions_campaign_adapter
  view_name: fact
  group_label: "Google AdWords"
  label: "AdWord Impressions by Campaign"
  view_label: "Impressions by Campaign"
}

view: ad_impressions_campaign_derived_table {
  extension: required
  derived_table: {
    datagroup_trigger: adwords_etl_datagroup
    explore_source: ad_impressions_campaign_hour_adapter {
      column: date { field: fact._date }
      column: external_customer_id { field: fact.external_customer_id }
      column: campaign_id { field: fact.campaign_id }
      column: ad_network_type_1 { field: fact.ad_network_type1 }
      column: ad_network_type_2 { field: fact.ad_network_type2 }
      column: device { field: fact.device }
      column: average_position {field: fact.weighted_average_position}
      column: clicks {field: fact.total_clicks }
      column: conversions {field: fact.total_conversions}
      column: conversion_value {field: fact.total_conversionvalue}
      column: cost {field: fact.total_cost}
      column: impressions { field: fact.total_impressions}
      column: interactions {field: fact.total_interactions}
    }
  }
}

view: ad_impressions_campaign_adapter {
  extends: [ad_impressions_campaign_derived_table, ad_impressions_campaign_adapter_base]
}

view: ad_impressions_campaign_adapter_base {
  extension: required
  extends: [ad_impressions_adapter_base]

  dimension: campaign_primary_key {
    hidden: yes
    sql: concat(${account_primary_key}, "|", ${campaign_id_string}) ;;
  }

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: ${campaign_primary_key} ;;
  }

  dimension: base_campaign_id {
    hidden: yes
    sql: ${TABLE}.base_campaign_id ;;
  }

  dimension: campaign_id {
    hidden: yes
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: campaign_id_string {
    hidden: yes
    sql: CAST(${campaign_id} as STRING) ;;
  }
}

explore: ad_impressions_campaign_hour_adapter {
  extends: [ad_impressions_campaign_adapter]
  from: ad_impressions_campaign_hour_adapter
  view_name: fact
  group_label: "Google AdWords"
  label: "AdWord Impressions by Campaign & Hour"
  view_label: "Impressions by Campaign & Hour"
}

view: ad_impressions_campaign_hour_adapter {
  extends: [ad_impressions_campaign_adapter_base, hour_base]
  sql_table_name: {{ fact.adwords_schema._sql }}.campaign_hourly_stats ;;

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: concat(${campaign_primary_key}, "|", ${hour_of_day_string}) ;;
  }
}

explore: ad_impressions_ad_group_adapter {
  extends: [ad_impressions_campaign_adapter, ad_group_join]
  from: ad_impressions_ad_group_adapter
  view_name: fact
  group_label: "Google AdWords"
  label: "AdWord Impressions by Ad Group"
  view_label: "Impressions by Ad Group"
}

view: ad_impressions_ad_group_derived_table {
  extension: required
  derived_table: {
    datagroup_trigger: adwords_etl_datagroup
    explore_source: ad_impressions_ad_group_hour_adapter {
      column: date { field: fact._date }
      column: external_customer_id { field: fact.external_customer_id }
      column: campaign_id { field: fact.campaign_id }
      column: ad_group_id { field: fact.ad_group_id }
      column: ad_network_type_1 { field: fact.ad_network_type1 }
      column: ad_network_type_2 { field: fact.ad_network_type2 }
      column: device { field: fact.device }
      column: average_position {field: fact.weighted_average_position}
      column: clicks {field: fact.total_clicks }
      column: conversions {field: fact.total_conversions}
      column: conversion_value {field: fact.total_conversionvalue}
      column: cost {field: fact.total_cost}
      column: impressions { field: fact.total_impressions}
      column: interactions {field: fact.total_interactions}
    }
  }
}

view: ad_impressions_ad_group_adapter {
  extends: [ad_impressions_ad_group_derived_table, ad_impressions_ad_group_adapter_base]
}

view: ad_impressions_ad_group_adapter_base {
  extension: required
  extends: [ad_impressions_campaign_adapter_base]

  dimension: ad_group_primary_key {
    hidden: yes
    sql: concat(${campaign_primary_key}, "|", ${ad_group_id_string}) ;;
  }

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: ${ad_group_primary_key} ;;
  }

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
  extends: [ad_impressions_ad_group_adapter]
  from: ad_impressions_ad_group_hour_adapter
  view_name: fact
  group_label: "Google AdWords"
  label: "AdWord Impressions by Ad Group & Hour"
  view_label: "Impressions by Ad Group & Hour"
}

view: ad_impressions_ad_group_hour_adapter {
  extends: [ad_impressions_ad_group_adapter_base, hour_base]
  sql_table_name: {{ fact.adwords_schema._sql }}.ad_group_hourly_stats ;;

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: concat(${ad_group_primary_key}, "|", ${hour_of_day_string}) ;;
  }
}

explore: ad_impressions_keyword_adapter {
  extends: [ad_impressions_ad_group_adapter, keyword_join]
  from: ad_impressions_keyword_adapter
  view_name: fact
  group_label: "Google AdWords"
  label: "AdWord Impressions by Keyword"
  view_label: "Impressions by Keyword"
}

view: ad_impressions_keyword_adapter {
  extends: [ad_impressions_ad_group_adapter_base]
  sql_table_name: {{ fact.adwords_schema._sql }}.keyword_stats ;;

  dimension: keyword_primary_key {
    hidden: yes
    sql: concat(${ad_group_primary_key}, "|", ${criterion_id_string}, "|", ${slot}) ;;
  }

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: ${keyword_primary_key} ;;
  }

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
  extends: [ad_impressions_keyword_adapter, ad_join]
  from: ad_impressions_ad_adapter
  view_name: fact
  group_label: "Google AdWords"
  label: "AdWord Impressions by Ad"
  view_label: "Impressions by Ad"

  join: conversion {
    from: ad_impressions_ad_conversion_adapter
    view_label: "Conversions by Ad"
    sql_on: ${fact.external_customer_id} = ${conversion.external_customer_id}
      AND ${fact.campaign_id} = ${conversion.campaign_id}
      AND ${fact.ad_group_id} = ${conversion.ad_group_id}
      AND ${fact.criterion_id} = ${conversion.criterion_id}
      AND ${fact.creative_id} = ${conversion.creative_id}
      AND ${fact._date} = ${conversion._date}
      AND ${fact.slot} = ${conversion.slot}
      AND ${fact.is_negative} = ${conversion.is_negative}
      AND ${fact.device} = ${conversion.device}
      AND ${fact.ad_network_type1} = ${conversion.ad_network_type1}
      AND ${fact.ad_network_type2} = ${conversion.ad_network_type2} ;;
    relationship: one_to_many
  }
}

view: ad_impressions_ad_adapter {
  extends: [ad_impressions_keyword_adapter]
  sql_table_name: {{ fact.adwords_schema._sql }}.ad_stats ;;

  dimension: ad_primary_key {
    hidden: yes
    sql: concat(${keyword_primary_key}, "|", ${creative_id_string}, "|", ${is_negative_string}) ;;
  }

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: ${ad_primary_key} ;;
  }

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

  dimension: is_negative {
    hidden: yes
    type: yesno
    sql: ${TABLE}.is_negative ;;
  }

  dimension: is_negative_string {
    hidden: yes
    sql: CAST(${TABLE}.is_negative AS STRING) ;;
  }
}

view: ad_impressions_ad_conversion_adapter {
  extends: [adwords_config, google_adwords_base, transformations_base, ad_metrics_conversion_base]
  sql_table_name: {{ fact.adwords_schema._sql }}.ad_conversion_stats ;;

  dimension: ad_conversion_primary_key {
    hidden: yes
    sql: concat(
      ${date_string}, "|",
      ${external_customer_id_string}, "|",
      ${ad_network_type1}, "|",
      ${ad_network_type2}, "|",
      ${device}, "|",
      ${campaign_id_string}, "|",
      ${ad_group_id_string}, "|",
      ${criterion_id_string}, "|",
      ${slot}, "|",
      ${creative_id_string}, "|",
      ${is_negative_string}, "|",
      ${conversion_category_name}, "|",
      ${conversion_tracker_id}, "|",
      ${conversion_type_name},) ;;
  }

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: ${ad_conversion_primary_key} ;;
  }

  dimension: base_campaign_id {
    hidden: yes
    sql: ${TABLE}.base_campaign_id ;;
  }

  dimension: campaign_id {
    hidden: yes
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: campaign_id_string {
    hidden: yes
    sql: CAST(${campaign_id} as STRING) ;;
  }

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

  dimension: criterion_id {
    hidden: yes
    sql: ${TABLE}.criterion_id ;;
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

  dimension: is_negative {
    hidden: yes
    type: yesno
    sql: ${TABLE}.is_negative ;;
  }

  dimension: is_negative_string {
    hidden: yes
    sql: CAST(${TABLE}.is_negative AS STRING) ;;
  }

  dimension: creative_id {
    hidden: yes
    sql: ${TABLE}.id ;;
  }

  dimension: creative_id_string {
    hidden: yes
    sql: CAST(${creative_id} as STRING) ;;
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

  dimension: conversion_category_name {
    hidden: yes
    type: string
    sql: ${TABLE}.conversion_category_name ;;
  }

  dimension: conversion_tracker_id {
    hidden: yes
    type: number
    sql: ${TABLE}.conversion_tracker_id ;;
  }

  dimension: conversion_type_name {
    type: string
    sql: ${TABLE}.conversion_type_name ;;
  }

  dimension: conversions {
    hidden: yes
    type: number
    sql: ${TABLE}.conversions ;;
  }

  dimension: conversionvalue {
    hidden: yes
    type: number
    sql: ${TABLE}.conversion_value ;;
  }

  dimension: device {
    hidden: yes
    type: string
    sql: ${TABLE}.device ;;
  }

  dimension: view_through_conversions {
    hidden: yes
    type: number
    sql: ${TABLE}.view_through_conversions ;;
  }

}

explore: ad_impressions_geo_adapter {
  extends: [ad_impressions_ad_group_adapter]
  from: ad_impressions_geo_adapter
  view_name: fact
  group_label: "Google AdWords"
  label: "AdWord Impressions by Geo"
  view_label: "Impressions by Geo"

  join: geo_country {
    from: geotargeting
    view_label: "Country"
    fields: [country_code]
    sql_on: ${fact.country_criteria_id} = ${geo_country.criteria_id_string} ;;
    relationship: many_to_one
  }

  join: geo_us_state {
    from: geotargeting
    view_label: "US State"
    fields: [state]
    sql_on: ${fact.region_criteria_id} = ${geo_us_state.criteria_id_string} AND
      ${geo_us_state.is_us_state} ;;
    relationship: many_to_one
    type: inner
  }

  join: geo_us_postal_code {
    from: geotargeting
    view_label: "US Postal Code"
    fields: [postal_code]
    sql_on: ${fact.most_specific_criteria_id} = ${geo_us_postal_code.criteria_id_string} AND
      ${geo_us_postal_code.is_us_postal_code} ;;
    relationship: many_to_one
    type: inner
  }

  join: geo_us_postal_code_state {
    from: geotargeting
    view_label: "US Postal Code"
    fields: [state]
    sql_on: ${geo_us_postal_code.parent_id} = ${geo_us_postal_code_state.criteria_id_string} AND
      ${geo_us_postal_code_state.is_us_state} ;;
    relationship: many_to_one
    type: inner
    required_joins: [geo_us_postal_code]
  }

  join: geo_region {
    from: geotargeting
    view_label: "Region"
    fields: [name, country_code]
    sql_on: ${fact.region_criteria_id} = ${geo_region.criteria_id_string} ;;
    relationship: many_to_one
  }

  join: geo_metro {
    from: geotargeting
    view_label: "Metro"
    fields: [name, country_code]
    sql_on: ${fact.metro_criteria_id} = ${geo_metro.criteria_id_string} ;;
    relationship: many_to_one
  }

  join: geo_city {
    from: geotargeting
    view_label: "City"
    fields: [name, country_code]
    sql_on: ${fact.city_criteria_id} = ${geo_city.criteria_id_string} ;;
    relationship: many_to_one
  }
}

view: ad_impressions_geo_adapter {
  extends: [ad_impressions_ad_group_adapter]
  sql_table_name: {{ fact.adwords_schema._sql }}.geo_stats ;;

  dimension: city_criteria_id {
    hidden: yes
    type: number
    sql: ${TABLE}.city_criteria_id;;
  }

  dimension: country_criteria_id {
    hidden: yes
    type: number
    sql: ${TABLE}.country_criteria_id ;;
  }

  dimension: metro_criteria_id {
    hidden: yes
    type: number
    sql: ${TABLE}.metro_criteria_id ;;
  }

  dimension: most_specific_criteria_id {
    hidden: yes
    type: number
    sql: ${TABLE}.most_specific_criteria_id ;;
  }

  dimension: region_criteria_id {
    hidden: yes
    type: number
    sql: ${TABLE}.region_criteria_id ;;
  }
}
