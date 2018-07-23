include: "customer.view"

explore: campaign_join {
  extension: required

  join: campaign {
    from: campaign_adapter
    view_label: "Campaign"
    sql_on: ${fact.campaign_id} = ${campaign.campaign_id} AND
      ${fact.external_customer_id} = ${campaign.external_customer_id} AND
      ${fact._date} = ${campaign._date} ;;
    relationship: many_to_one
  }
}

explore: campaign_adapter {
  persist_with: adwords_etl_datagroup
  from: campaign_adapter
  view_name: campaign
  hidden: yes

  join: customer {
    from: customer_adapter
    view_label: "Customer"
    sql_on: ${campaign.external_customer_id} = ${customer.external_customer_id} AND
      ${campaign._date} = ${customer._date} ;;
    relationship: many_to_one
  }
}

view: campaign_adapter {
  extends: [adwords_config, google_adwords_base]
  sql_table_name: {{ campaign.adwords_schema._sql }}.campaign ;;

  dimension: advertising_channel_sub_type {
    hidden: yes
    type: string
    sql: ${TABLE}.advertising_channel_sub_type ;;
  }

  dimension: advertising_channel_type {
    hidden: yes
    type: string
    sql: ${TABLE}.advertising_channel_type ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
  }

  dimension: bid_type {
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

  dimension: bidding_strategy_type {
    hidden: yes
    type: string
    sql: ${TABLE}.bidding_strategy_type ;;
  }

  dimension: budget_id {
    hidden: yes
    sql: ${TABLE}.budget_id ;;
  }

  dimension: campaign_desktop_bid_modifier {
    hidden: yes
    type: number
    sql: ${TABLE}.campaign_desktop_bid_modifier ;;
  }

  dimension: campaign_id {
    hidden: yes
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: campaign_mobile_bid_modifier {
    hidden: yes
    type: number
    sql: ${TABLE}.campaign_mobile_bid_modifier ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.campaign_name ;;
    link: {
      label: "Campaign Dashboard"
      url: "/dashboards/marketing_analytics::campaign_metrics_cost_per_conversion?Campaign={{ value | encode_uri }}"
      icon_url: "http://www.looker.com/favicon.ico"
    }
    link: {
      label: "View on AdWords"
      icon_url: "https://www.google.com/s2/favicons?domain=www.adwords.google.com"
      url: "https://adwords.google.com/aw/adgroups?campaignId={{ campaign_id._value | encode_uri }}"
    }
    link: {
      label: "Pause Campaign"
      icon_url: "https://www.google.com/s2/favicons?domain=www.adwords.google.com"
      url: "https://adwords.google.com/aw/ads?campaignId={{ campaign_id._value | encode_uri }}"
    }
    link: {
      url: "https://adwords.google.com/aw/ads?campaignId={{ campaign_id._value | encode_uri }}"
      icon_url: "https://www.gstatic.com/awn/awsm/brt/awn_awsm_20171108_RC00/aw_blend/favicon.ico"
      label: "Change Budget"
    }
    required_fields: [external_customer_id, campaign_id]
  }

  dimension: campaign_status {
    hidden: yes
    type: string
    sql: ${TABLE}.campaign_status ;;
  }

  dimension: status_active {
    hidden: yes
    type: yesno
    sql: ${campaign_status} = "enabled" ;;
  }

  dimension: campaign_tablet_bid_modifier {
    hidden: yes
    type: number
    sql: ${TABLE}.campaign_tablet_bid_modifier ;;
  }

  dimension: campaign_trial_type {
    hidden: yes
    type: string
    sql: ${TABLE}.campaign_trial_type ;;
  }

  dimension_group: end {
    hidden: yes
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    sql: (TIMESTAMP(${TABLE}.end_date)) ;;
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

  dimension: is_budget_explicitly_shared {
    hidden: yes
    type: yesno
    sql: ${TABLE}.is_budget_explicitly_shared ;;
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

  dimension: period {
    hidden: yes
    type: string
    sql: ${TABLE}.period ;;
  }

  dimension: serving_status {
    hidden: yes
    type: string
    sql: ${TABLE}.serving_status ;;
  }

  dimension_group: start {
    hidden: yes
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    sql: (TIMESTAMP(${TABLE}.start_date)) ;;
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
