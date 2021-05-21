with customers as (
select 
    c_custkey as customer_id,
    c_name as customer_name,
    c_address as customer_address,
    c_acctbal as customer_acctbal_amt
from raw.tpch_sf001.customer
),
orders as (
select 
    o_orderkey as order_id,
    o_custkey as customer_id,
    o_orderstatus as order_status,
    o_totalprice as order_total_price,
    o_orderdate as order_date
from raw.tpch_sf001.orders
),
customer_orders as (
select 
    customer_id,
    sum(order_total_price) as order_total,
    min(order_date) as first_order_date,
    max(order_date) as most_recent_order_date,
    count(order_id) as number_of_orders
from orders
group by 1
),
final as (
select 
    customers.customer_id,
    customers.customer_name,
    customers.customer_address,
    customers.customer_acctbal_amt,
    customer_orders.first_order_date,
    customer_orders.most_recent_order_date,
    coalesce (customer_orders.number_of_orders,0) as number_of_orders
from customers
  left join customer_orders using (customer_id)
    
)
select * from final

