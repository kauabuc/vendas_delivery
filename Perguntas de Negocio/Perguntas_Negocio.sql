/* 
Qual é o tempo médio de entrega dos pedidos em cada hub?
 
PREMISSAS
- Iremos considerar apenas entregas finalizadas, status finished
 */





select 
	h.hub_name,
	avg(o.order_moment_finished - o.order_moment_created) as tempo_medio_entrega
from deliveries d 
left join orders o 
on o.delivery_order_id = d.delivery_order_id 
left join stores s 
on s.store_id = o.store_id 
left join hubs h
on h.hub_id = s.hub_id 
where o.order_status = 'FINISHED'
group by h.hub_name
order by tempo_medio_entrega


/* 
Quais são os canais de venda com maior volume de pedidos e receita?

PREMISSAS
- Iremos considerar apenas entregas finalizadas e pagas, status finished e paid
*/



select 
	c.channel_name,
	count(o.order_id) as Total_Pedidos,
	sum(o.order_amount + o.order_delivery_fee) as Total_Receita
from 
	orders o
left join channels c 
on c.channel_id = o.channel_id 
left join payments p 
on p.payment_order_id = o.payment_order_id 
where o.order_status = 'FINISHED' and p.payment_status = 'PAID'
group by c.channel_name 
order by total_receita desc


/* 
Qual é o tempo médio entre o pagamento e o processamento dos pedidos?

PREMISSAS
- Iremos considerar o pagamento como a hora que o pedido foi aprovado e processamento quando o pedido está pronto
- Apenas pedidos finalizados
*/



select 
	avg(o.order_moment_ready - o.order_moment_accepted)
from
	orders o
left join payments p 
on p.payment_order_id = o.payment_order_id 
where o.order_status = 'FINISHED' and p.payment_status = 'PAID'




/* 
Quais são as lojas com maior e menor taxa de pedidos entregues?

PREMISSAS
- Iremos considerar apenas pedidos que tiveram oportunidade de entrega
- Apenas pedidos finalizados
*/


select 
	s.store_name,
	count(o.order_id) as Total_Pedidos,
	(count(o.order_id)::numeric / (select count(order_id) from orders where order_status = 'FINISHED')) * 100 as Taxa_Pedidos
from 
	orders o
left join stores s
on s.store_id = o.store_id 
where o.order_status = 'FINISHED'
group by s.store_name 
order by Taxa_Pedidos desc 


/* 
Quantos pedidos, em média, cada entregador realiza por dia?

PREMISSAS
- Apenas pedidos finalizados, iremos considerar apenas corridas com menos de 11KM, iremos considerar corridas com o valor acima disso, possíveis erros/fraudes
*/



select 
	dr.driver_id ,
	count(o.order_id) / count(distinct o.order_moment_created::date) as Entregas_por_dia
from deliveries d 
left join drivers dr
on dr.driver_id = d.driver_id 
left join orders o 
on o.delivery_order_id = d.delivery_order_id 
where d.delivery_status = 'DELIVERED' and d.delivery_distance_meters < 11000 and d.driver_id is not null
group by dr.driver_id 
order by entregas_por_dia desc




/* 
Quais são os dias e horários de pico de pedidos?

PREMISSAS
- Considerando dias como dias da semana
*/


select 
	extract(dow from o.order_moment_created) as dia_semana,
	o.order_created_hour as hora_pedido,
	count(*) as pedidos
from orders o
group by extract(dow from o.order_moment_created), o.order_created_hour
order by pedidos desc





/* 
Quais são os métodos de pagamento mais utilizados e a taxa de rejeição por método?

PREMISSAS
- Pagamentos rejeitados -> chargeback
*/




select  
	p.payment_method,
	count(p.payment_id) as pedidos,
	((nullif(COUNT(p.payment_id) filter(where p.payment_status = 'CHARGEBACK'), 0)) / count(p.payment_id)::numeric) * 100 as taxa_rejeicao
from 
	payments p 
group by p.payment_method 
order by pedidos desc 


/* 
Qual é o ticket médio por canal de venda?


PREMISSAS
- Apenas pedidos finalizados e pagos
*/




select 
	c.channel_name,
	round( avg(o.order_amount + o.order_delivery_fee), 2) as Ticket_Medio
from orders o 
left join channels c 
on c.channel_id = o.channel_id 
left join payments p 
on p.payment_order_id = o.payment_order_id 
where o.order_status = 'FINISHED' and p.payment_status = 'PAID'
group by c.channel_name 
order by ticket_medio desc


/* 
Qual é a distribuição dos pedidos por região e hub?

PREMISSAS
-- Apenas pedidos que foram entregues
*/


select 
	h.hub_city,
	count(o.order_id) as pedidos
from deliveries d 
left join drivers dr
on dr.driver_id = d.driver_id 
left join orders o 
on o.delivery_order_id = d.delivery_order_id 
left join stores s 
on s.store_id = o.store_id 
left join hubs h
on h.hub_id = s.hub_id 
where d.delivery_status = 'DELIVERED'
group by h.hub_city


select 
	h.hub_name,
	count(o.order_id) as pedidos
from deliveries d 
left join drivers dr
on dr.driver_id = d.driver_id 
left join orders o 
on o.delivery_order_id = d.delivery_order_id 
left join stores s 
on s.store_id = o.store_id 
left join hubs h
on h.hub_id = s.hub_id 
where d.delivery_status = 'DELIVERED'
group by h.hub_name
order by pedidos desc


/* 
Quais lojas têm maior volume de vendas no modelo 'good' e no modelo 'food'?


PREMISSAS
- Apenas pedidos entregues, considerando o volume como quantitativo
- Separados por tipo de produto
*/



select 
	s.store_name,
	count(o.order_id) as pedidos
from deliveries d 
left join drivers dr
on dr.driver_id = d.driver_id 
left join orders o 
on o.delivery_order_id = d.delivery_order_id 
left join stores s 
on s.store_id = o.store_id 
where d.delivery_status = 'DELIVERED' and s.store_segment = 'FOOD'
group by S.store_name 
order by pedidos desc



select 
	s.store_name,
	count(o.order_id) as pedidos
from deliveries d 
left join drivers dr
on dr.driver_id = d.driver_id 
left join orders o 
on o.delivery_order_id = d.delivery_order_id 
left join stores s 
on s.store_id = o.store_id 
where d.delivery_status = 'DELIVERED' and s.store_segment = 'GOOD'
group by S.store_name 
order by pedidos desc