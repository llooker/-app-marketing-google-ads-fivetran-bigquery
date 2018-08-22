include: "google_adwords_base.view"

view: video_adapter {
  extends: [adwords_config, google_adwords_base]
  sql_table_name: {{ video.adwords_schema._sql }}.video ;;

  dimension: ad_group_id {
    hidden: yes
    type: number
  }

  dimension: campaign_id {
    hidden: yes
    type: number
  }

  dimension: video_duration {
    type: number
  }

  dimension: video_id {
    hidden: yes
    type: string
  }

  dimension: video_title {
    type: string
  }
}
