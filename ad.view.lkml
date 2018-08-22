include: "ad_group.view"

explore: ad_join {
  extension: required

  join: ad {
    from: ad_adapter
    view_label: "Ads"
    sql_on: ${fact.creative_id} = ${ad.creative_id} AND
      ${fact.ad_group_id} = ${ad.ad_group_id} AND
      ${fact.campaign_id} = ${ad.campaign_id} AND
      ${fact.external_customer_id} = ${ad.external_customer_id} AND
      ${fact._date} = ${ad._date} ;;
    relationship:  many_to_one
  }
}

explore: ad_adapter {
  persist_with: adwords_etl_datagroup
  from: ad_adapter
  view_name: ad
  hidden: yes

  join: ad_group {
    from: ad_group_adapter
    view_label: "Ad Group"
    sql_on: ${ad.ad_group_id} = ${ad_group.ad_group_id} AND
      ${ad.campaign_id} = ${ad_group.campaign_id} AND
      ${ad.external_customer_id} = ${ad_group.external_customer_id} AND
      ${ad._date} = ${ad_group._date};;
    relationship: many_to_one
  }
  join: campaign {
    from: campaign_adapter
    view_label: "Campaign"
    sql_on: ${ad.campaign_id} = ${campaign.campaign_id} AND
      ${ad.external_customer_id} = ${campaign.external_customer_id} AND
      ${ad._date} = ${campaign._date};;
    relationship: many_to_one
  }
  join: customer {
    from: customer_adapter
    view_label: "Customer"
    sql_on: ${ad.external_customer_id} = ${customer.external_customer_id} AND
      ${ad._date} = ${customer._date} ;;
    relationship: many_to_one
  }
}

view: ad_adapter {
  extends: [adwords_config, google_adwords_base]
  sql_table_name: {{ ad.adwords_schema._sql }}.ad ;;

  dimension: ad_group_ad_disapproval_reasons {
    type: string
    sql: ${TABLE}.ad_group_ad_disapproval_reasons ;;
  }

  dimension: ad_group_ad_trademark_disapproved {
    type: yesno
    sql: ${TABLE}.ad_group_ad_trademark_disapproved ;;
  }

  dimension: ad_group_id {
    sql: ${TABLE}.ad_group_id ;;
    hidden: yes
  }

  dimension: ad_type {
    type: string
    sql: ${TABLE}.ad_type ;;
  }

  dimension: business_name {
    type: string
    sql: ${TABLE}.business_name ;;
  }

  dimension: call_only_phone_number {
    type: string
    sql: ${TABLE}.call_only_phone_number ;;
    hidden: yes
  }

  dimension: campaign_id {
    sql: ${TABLE}.campaign_id ;;
    hidden: yes
  }

  dimension: creative_approval_status {
    hidden: yes
    type: string
    sql: ${TABLE}.creative_approval_status ;;
  }

  dimension: creative_destination_url {
    type: string
    sql: ${TABLE}.creative_destination_url ;;
    group_label: "URLS"
  }

  dimension: creative_final_app_urls {
    type: string
    sql: ${TABLE}.creative_final_app_urls ;;
    group_label: "URLS"
  }

  dimension: creative_final_mobile_urls {
    type: string
    sql: ${TABLE}.creative_final_mobile_urls ;;
    group_label: "URLS"
  }

  dimension: creative_final_urls {
    hidden: yes
    type: string
    sql: ${TABLE}.creative_final_urls ;;
    group_label: "URLS"
  }

  dimension: creative_final_urls_clean {
    hidden: yes
    type: string
    sql: REGEXP_EXTRACT(${creative_final_urls}, r'\"([^\"]*)\"') ;;
  }

  dimension: creative_final_urls_domain_path {
    label: "Creative Final Urls"
    type: string
    sql: SUBSTR(REGEXP_EXTRACT(${creative_final_urls_clean}, r'^https?://(.*)\?'), 0, 50) ;;
    link: {
      url: "{{ creative_final_urls_clean }}"
      label: "Landing Page"
    }
    group_label: "URLS"
  }

  dimension: creative_id {
    sql: ${TABLE}.id ;;
    hidden: yes
  }

  dimension: creative_tracking_url_template {
    type: string
    sql: ${TABLE}.creative_tracking_url_template ;;
    hidden: yes
  }

  dimension: creative_url_custom_parameters {
    type: string
    sql: ${TABLE}.creative_url_custom_parameters ;;
    hidden: yes
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension: description1 {
    type: string
    sql: ${TABLE}.description_1 ;;
  }

  dimension: description2 {
    type: string
    sql: ${TABLE}.description_2 ;;
  }

  dimension: device_preference {
    type: number
    sql: ${TABLE}.device_preference ;;
  }

  dimension: display_url {
    type: string
    sql: ${TABLE}.display_url ;;
    group_label: "URLS"
  }

  dimension: enhanced_display_creative_logo_image_media_id {
    sql: ${TABLE}.enhanced_display_creative_logo_image_media_id ;;
    hidden: yes
  }

  dimension: enhanced_display_creative_marketing_image_media_id {
    sql: ${TABLE}.enhanced_display_creative_marketing_image_media_id ;;
    hidden: yes
  }

  dimension: headline {
    type: string
    sql: ${TABLE}.headline;;
    group_label: "Headline"
  }

  dimension: headline_part1 {
    type: string
    sql: ${TABLE}.headline_part_1 ;;
    group_label: "Headline"
  }

  dimension: headline_part2 {
    type: string
    sql: ${TABLE}.headline_part_2 ;;
    group_label: "Headline"
  }

  dimension: image_ad_url {
    type: string
    sql: ${TABLE}.image_ad_url ;;
    group_label: "URLS"
  }

  dimension: image_creative_image_height {
    type: number
    sql: ${TABLE}.image_creative_image_height ;;
    hidden: yes
  }

  dimension: image_creative_image_width {
    type: number
    sql: ${TABLE}.image_creative_image_width ;;
    hidden: yes
  }

  dimension: image_creative_name {
    type: string
    sql: ${TABLE}.image_creative_name ;;
  }

  dimension: label_ids {
    type: string
    sql: ${TABLE}.label_ids ;;
    hidden: yes
  }

  dimension: labels {
    type: string
    sql: ${TABLE}.labels ;;
  }

  dimension: long_headline {
    type: string
    sql: ${TABLE}.long_headline ;;
    hidden: yes
  }

  dimension: path1 {
    type: string
    sql: ${TABLE}.path_1 ;;
    hidden: yes
  }

  dimension: path2 {
    type: string
    sql: ${TABLE}.path_2 ;;
    hidden: yes
  }

  dimension: short_headline {
    type: string
    sql: ${TABLE}.short_headline ;;
    hidden: yes
  }

  dimension: status {
    hidden: yes
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: status_active {
    type: yesno
    sql: ${status} = "enabled" ;;
  }

  dimension: creative {
    type: string
    sql: SUBSTR(CONCAT(
      COALESCE(CONCAT(${headline}, "\n"),"")
      , COALESCE(CONCAT(${headline_part1}, "\n"),"")
      , COALESCE(CONCAT(${headline_part2}, "\n"),"")
      ), 0, 50) ;;
    link: {
      url: "https://adwords.google.com/aw/ads?campaignId={{ campaign_id._value }}&adGroupId={{ ad_group_id._value }}"
      icon_url: "https://www.gstatic.com/awn/awsm/brt/awn_awsm_20171108_RC00/aw_blend/favicon.ico"
      label: "Pause Ad"
    }
    link: {
      url: "https://adwords.google.com/aw/ads?campaignId={{ campaign_id._value }}&adGroupId={{ ad_group_id._value }}"
      icon_url: "https://www.gstatic.com/awn/awsm/brt/awn_awsm_20171108_RC00/aw_blend/favicon.ico"
      label: "Change Bid"
    }
    required_fields: [external_customer_id, campaign_id, ad_group_id, creative_id]
    # expression: substring(concat(${headline}, ${headline_part1}, ${headline_part2}), 0, 50)
  }

  dimension: display_headline {
    type: string
    sql: CONCAT(
      COALESCE(CONCAT(${headline}, "\n"),"")
      , COALESCE(CONCAT(${headline_part1}, "\n"),"")) ;;
  }
}
