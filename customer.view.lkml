include: "google_adwords_base.view"

explore: customer_join {
  extension: required

  join: customer {
    from: customer_adapter
    view_label: "Customer"
    sql_on: ${fact.external_customer_id} = ${customer.external_customer_id} AND
      ${fact._date} = ${customer._date} ;;
    relationship: many_to_one
  }
}

explore: customer_adapter {
  persist_with: adwords_etl_datagroup
  from: customer_adapter
  view_name: customer
  hidden: yes
}

view: customer_adapter {
  extends: [adwords_config, google_adwords_base]
    sql_table_name:
  (
    SELECT account.*
    FROM {{ customer.adwords_schema._sql }}.account as account
    INNER JOIN (
    SELECT
      date,
      customer_id,
      MAX(_fivetran_id) as max_fivetran_id
    FROM {{ customer.adwords_schema._sql }}.account GROUP BY 1,2) AS max_account
    ON account._fivetran_id = max_account.max_fivetran_id
    AND account.date = max_account.date
    AND account.customer_id = max_account.customer_id
  ) ;;

  dimension: account_currency_code {
    hidden: yes
    type: string
    sql: ${TABLE}.account_currency_code ;;
  }

  dimension: account_descriptive_name {
    hidden: yes
    type: string
    sql: ${TABLE}.account_descriptive_name ;;
    required_fields: [external_customer_id]
  }

  dimension: account_time_zone {
    hidden: yes
    type: string
    sql: ${TABLE}.account_time_zone ;;
  }

  dimension: customer_descriptive_name {
    hidden: yes
    type: string
    sql: ${TABLE}.customer_descriptive_name ;;
  }
}
