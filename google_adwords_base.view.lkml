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
    hidden: yes
    sql: ${TABLE}.external_customer_id ;;
  }

  dimension: external_customer_id_string {
    hidden: yes
    sql: CAST(${TABLE}.external_customer_id as STRING) ;;
  }

}
