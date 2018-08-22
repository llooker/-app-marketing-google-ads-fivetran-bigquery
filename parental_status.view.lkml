include: "criteria_base.view"

explore: parental_status_adapter {
  persist_with: adwords_etl_datagroup
  extends: [criteria_joins_base]
  from: parental_status_adapter
  view_label: "Parental Status"
  view_name: criteria
  hidden: yes
}

view: parental_status_adapter {
  extends: [adwords_config, criteria_base]
  sql_table_name: {{ criteria.adwords_schema._sql }}.parental_status ;;

  dimension: criteria {
    label: "Parental Status"
  }
}
