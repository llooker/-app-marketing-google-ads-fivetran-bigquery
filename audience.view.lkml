include: "criteria_base.view"

explore: audience_adapter {
  persist_with: adwords_etl_datagroup
  extends: [criteria_joins_base]
  from: audience_adapter
  view_label: "Audience"
  view_name: criteria
  hidden: yes
}

view: audience_adapter {
  extends: [adwords_config, criteria_base]
  sql_table_name: {{ criteria.adwords_schema._sql }}.audience ;;

  dimension: criteria {
    label: "Audience"
  }

  dimension: user_list_name {}
}
