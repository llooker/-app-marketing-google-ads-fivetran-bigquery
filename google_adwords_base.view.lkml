view: google_adwords_base {
  extension: required

  dimension: _date {
    hidden: yes
    type: date_raw
    sql: CAST(${TABLE}.date AS DATE) ;;
  }

  dimension: date_string {
    hidden: yes
    sql: CAST(${TABLE}.date AS STRING) ;;
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
