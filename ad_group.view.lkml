include: "campaign.view"

explore: ad_group_join {
  extension: required

  join: ad_group {
    from: ad_group_adapter
    view_label: "Ad Groups"
    sql_on: ${fact.ad_group_id} = ${ad_group.ad_group_id} AND
      ${fact.campaign_id} = ${ad_group.campaign_id} AND
      ${fact.external_customer_id} = ${ad_group.external_customer_id} AND
      ${fact._date} = ${ad_group._date} ;;
    relationship: many_to_one
  }
}

explore: ad_group_adapter {
  persist_with: adwords_etl_datagroup
  from: ad_group_adapter
  view_name: ad_group
  hidden: yes

  join: campaign {
    from: campaign_adapter
    view_label: "Campaign"
    sql_on: ${ad_group.campaign_id} = ${campaign.campaign_id} AND
      ${ad_group.external_customer_id} = ${campaign.external_customer_id} AND
      ${ad_group._date} = ${campaign._date};;
    relationship: many_to_one
  }
  join: customer {
    from: customer_adapter
    view_label: "Customer"
    sql_on: ${ad_group.external_customer_id} = ${customer.external_customer_id} AND
      ${ad_group._date} = ${customer._date} ;;
    relationship: many_to_one
  }
}

view: ad_group_adapter {
  extends: [adwords_config, google_adwords_base]
  sql_table_name: {{ ad_group.adwords_schema._sql }}.ad_group ;;

  dimension: ad_group_desktop_bid_modifier {
    hidden: yes
    type: number
    sql: ${TABLE}.ad_group_desktop_bid_modifier ;;
  }

  dimension: ad_group_id {
    hidden: yes
    sql: ${TABLE}.ad_group_id ;;
  }

  dimension: ad_group_mobile_bid_modifier {
    hidden: yes
    type: number
    sql: ${TABLE}.ad_group_mobile_bid_modifier ;;
  }

  dimension: ad_group_name {
    type: string
    sql: ${TABLE}.ad_group_name ;;
    link: {
      label: "View on AdWords"
      icon_url: "https://www.google.com/s2/favicons?domain=www.adwords.google.com"
      url: "https://adwords.google.com/aw/ads?campaignId={{ campaign_id._value }}&adGroupId={{ ad_group_id._value }}"
    }
    link: {
      label: "Pause Ad Group"
      icon_url: "https://www.google.com/s2/favicons?domain=www.adwords.google.com"
      url: "https://adwords.google.com/aw/ads?campaignId={{ campaign_id._value }}&adGroupId={{ ad_group_id._value }}"
    }
    link: {
      url: "https://adwords.google.com/aw/ads?campaignId={{ campaign_id._value }}&adGroupId={{ ad_group_id._value }}"
      icon_url: "https://www.gstatic.com/awn/awsm/brt/awn_awsm_20171108_RC00/aw_blend/favicon.ico"
      label: "Change Bid"
    }
    required_fields: [external_customer_id, campaign_id, ad_group_id]
  }

  dimension: ad_group_status {
    hidden: yes
    type: string
    sql: ${TABLE}.ad_group_status ;;
  }

  dimension: status_active {
    hidden: yes
    type: yesno
    sql: ${ad_group_status} = "enabled" ;;
  }

  dimension: ad_group_tablet_bid_modifier {
    hidden: yes
    type: number
    sql: ${TABLE}.ad_group_tablet_bid_modifier ;;
  }

  dimension: bid_type {
    hidden: yes
    type: string
    sql: ${TABLE}.bid_type ;;
  }

  dimension: bidding_strategy_id {
    hidden: yes
    sql: ${TABLE}.bidding_strategy_id ;;
  }

  dimension: bidding_strategy_name {
    hidden: yes
    type: string
    sql: ${TABLE}.bidding_strategy_name ;;
  }

  dimension: bidding_strategy_source {
    hidden: yes
    type: string
    sql: ${TABLE}.bidding_strategy_source ;;
  }

  dimension: bidding_strategy_type {
    hidden: yes
    type: string
    sql: ${TABLE}.bidding_strategy_type ;;
  }

  dimension: campaign_id {
    hidden: yes
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: content_bid_criterion_type_group {
    hidden: yes
    type: string
    sql: ${TABLE}.content_bid_criterion_type_group ;;
  }

  dimension: cpc_bid {
    type: string
    sql: ${TABLE}.cpc_bid ;;
  }

  dimension: cpm_bid {
    type: number
    sql: ${TABLE}.cpm_bid ;;
  }

  dimension: cpv_bid {
    type: string
    sql: ${TABLE}.cpv_bid ;;
  }

  dimension: enhanced_cpc_enabled {
    hidden: yes
    type: yesno
    sql: ${TABLE}.enhanced_cpc_enabled ;;
  }

  dimension: enhanced_cpv_enabled {
    hidden: yes
    type: yesno
    sql: ${TABLE}.enhanced_cpv_enabled ;;
  }

  dimension: label_ids {
    hidden: yes
    type: string
    sql: ${TABLE}.label_ids ;;
  }

  dimension: labels {
    hidden: yes
    type: string
    sql: ${TABLE}.labels ;;
  }

  dimension: target_cpa {
    type: number
    sql: ${TABLE}.target_cpa ;;
  }

  dimension: target_cpa_bid_source {
    hidden: yes
    type: string
    sql: ${TABLE}.target_cpa_bid_source ;;
  }

  dimension: tracking_url_template {
    hidden: yes
    type: string
    sql: ${TABLE}.tracking_url_template ;;
  }

  dimension: url_custom_parameters {
    hidden: yes
    type: string
    sql: ${TABLE}.url_custom_parameters ;;
  }
}
