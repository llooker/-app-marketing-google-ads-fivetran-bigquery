include: "criteria_base.view"

explore: age_range_adapter {
  persist_with: adwords_etl_datagroup
  extends: [criteria_joins_base]
  from: age_range_adapter
  view_label: "Age Range"
  view_name: criteria
  hidden: yes
}

view: age_range_adapter {
  extends: [adwords_config, criteria_base]
  sql_table_name: {{ criteria.adwords_schema._sql }}.age_range ;;

  dimension: criteria {
    label: "Age Range"
  }
}
