select count(*) from orders

select * from orders

select count(month(created_at)), YEAR(created_at), concat(month(created_at),'-',YEAR(created_at))as summary from orders
group by year(created_at), MONTH(created_at)
order by summary desc

select * from orders

select count(paid_at), count(delivery_at) from orders
where paid_at = 'NA'

select count(paid_at), count(delivery_at) from orders
where paid_at != 'NA' and delivery_at = 'NA'

select count(paid_at), count(delivery_at) from orders
where delivery_at = 'NA' and paid_at in (select paid_at from orders
										 where paid_at = 'NA' or paid_at != 'NA')

select count(paid_at), count(delivery_at) from orders
where delivery_at = paid_at

select count(*) from users
select * from orders

select count(user_id) from users where user_id in (
	select buyer_id from orders o
	left join users u on o.buyer_id = u.user_id)

select count(user_id) as [seller] from users
where user_id in (
	select seller_id from orders o
	left join users u on o.buyer_id = u.user_id)

select count(user_id) from users
where user_id in (select buyer_id from orders) and user_id in (select seller_id from orders)

select count(user_id) from users
where user_id not in (select buyer_id from orders) and user_id not in (select seller_id from orders)

select distinct(seller_id) as penjual from orders
where seller_id in (select buyer_id from orders)

select count(distinct user_id) from users
where user_id not in (
						select buyer_id from orders union select seller_id from orders)


select buyer_id, nama_user, sum(total) total from orders
left join users on users.user_id = orders.buyer_id
group by nama_user,buyer_id
order by total desc


select buyer_id, count(nama_user) transc, nama_user from orders
inner join users on users.user_id = orders.buyer_id
where discount = 0
group by nama_user, buyer_id
order by transc desc
 

select buyer_id, email, rata_rata, month_count from (
	select trx.buyer_id, rata_rata,jumlah_order, month_count from (
	select buyer_id, avg(total) as [rata_rata] from orders
	where year(created_at) = '2020'
	group by buyer_id
	having
	avg(total) > 1000000
	) as trx
	join (
			select distinct buyer_id, count(distinct month(created_at)) [month_count], count(order_id) [jumlah_order] from orders
			where year(created_at) = '2020'
			group by month(created_at), buyer_id
			having
			count(distinct month(created_at)) >= 5
			and
			count(order_id) >= count(distinct month(created_at))
		 ) as months on trx.buyer_id = months.buyer_id
	) as bfq join users on buyer_id = user_id


select 
	distinct substring(email, CHARINDEX('@', email)+1, len(email)-charindex('@', email)) as [email]
from
	users
where user_id in (select seller_id from orders)
order by email


select sum(quantity) as total, desc_product from order_details d
join products p on d.product_id = p.product_id
join orders o on o.order_id = d.order_id
where created_at between '2019-12-01' and '2019-12-31'
group by desc_product
order by sum(quantity) desc

ALTER TABLE dbo.order_details
alter COLUMN quantity int










