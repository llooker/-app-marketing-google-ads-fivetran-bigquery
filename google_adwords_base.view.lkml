view: google_adwords_base {
  extension: required

  dimension: _date {
    hidden: yes
    type: date_time
    sql: ${TABLE}.date ;;
  }

  dimension: latest {
    hidden: yes
    type: yesno
    sql: 1=1 ;;
  }

  dimension: external_customer_id {
    sql: ${TABLE}.external_customer_id ;;
    hidden: yes
  }

  dimension: external_customer_id_string {
    sql: CAST(${external_customer_id} as STRING) ;;
    hidden: yes
  }

}
