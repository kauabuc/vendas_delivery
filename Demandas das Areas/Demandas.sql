/* Demandas Passadas pela área */

/* 
Numa ação de marketing, para atrair mais entregadores, vamos dar uma bonificação para os 20 entregadores que possuem maior distância percorrida ao todo. 
A bonificação vai variar de acordo com o tipo de profissional que ele é e o modelo que ele usa para se locomover (moto, bike, etc). Levante essas informações.


PREMISSAS
- Iremos considerar apenas entregas finalizadas, status DELIVERED
- Como observamos na análise exploratória, iremos considerar apenas corridas com menos de 11KM, iremos considerar corridas com o valor acima disso, possíveis erros/fraudes
- Sem considerar entregas onde o entregador está como nulo
*/




select 
	d.driver_id,
	dr.driver_type,
	dr.driver_modal,
	sum(d.delivery_distance_meters / 1000) as km_percorridos
from deliveries d 
left join drivers dr
on dr.driver_id = d.driver_id 
where d.delivery_status = 'DELIVERED' and d.delivery_distance_meters < 11000 and d.driver_id is not null
group by d.driver_id, dr.driver_type, dr.driver_modal 
order by km_percorridos desc 



/* 
Além disso, o time de Pricing precisa ajustar os valores pagos aos entregadores. 
Para isso, eles precisam da distribuição da distância média percorrida pelos motoqueiros separada por estado, já que cada região terá seu preço.


PREMISSAS
- Iremos considerar apenas entregas finalizadas, status DELIVERED
- Como observamos na análise exploratória, iremos considerar apenas corridas com menos de 11KM, iremos considerar corridas com o valor acima disso, possíveis erros/fraudes
- Sem considerar entregas onde o entregador está como nulo
*/




select 
	h.hub_state,
	avg(d.delivery_distance_meters / 1000) as distancia_media_km
from deliveries d 
left join drivers dr
on dr.driver_id = d.driver_id 
left join orders o 
on o.delivery_order_id = d.delivery_order_id 
left join stores s 
on s.store_id = o.store_id 
left join hubs h
on h.hub_id = s.hub_id 
where d.delivery_status = 'DELIVERED' and d.delivery_distance_meters < 11000 and dr.driver_modal = 'MOTOBOY' and d.driver_id is not null
group by h.hub_state 
order by distancia_media_km desc



/* 
Por fim, o CFO precisa de alguns indicadores de receita para apresentar para a diretoria executiva. 
Dentre esses indicadores, vocês precisarão levantar (1) a receita média e total separada por tipo (Food x Good), (2) A receita média e total por estado. Ou seja, são 4 tabelas ao todo.


PREMISSAS
- Iremos considerar apenas entregas finalizadas e que foram pagaas, status FINISHED e PAID
- Como observamos na análise exploratória, iremos considerar apenas corridas com menos de 11KM, iremos considerar corridas com o valor acima disso, possíveis erros/fraudes
- Sem considerar entregas onde o entregador está como nulo
*/



select 
	s.store_segment,
	avg(o.order_amount + o.order_delivery_fee) as Receita_Media,
	sum(o.order_amount + o.order_delivery_fee) as Total_Receita
from 
	orders o
left join stores s
on s.store_id = o.store_id 
left join payments p 
on p.payment_order_id = o.payment_order_id 
where o.order_status = 'FINISHED' and p.payment_status = 'PAID'
group by s.store_segment 


select 
	h.hub_state,
	avg(o.order_amount + o.order_delivery_fee) as Receita_Media,
	sum(o.order_amount + o.order_delivery_fee) as Total_Receita
from 
	orders o
left join stores s
on s.store_id = o.store_id 
left join hubs h
on h.hub_id = s.hub_id 
left join payments p 
on p.payment_order_id = o.payment_order_id 
where o.order_status = 'FINISHED' and p.payment_status = 'PAID'
group by h.hub_state 





/* 
Se a empresa tem um gasto fixo de 5 reais por entrega, recebe 15% do valor de cada entrega como receita e, do total do lucro, 
distribui 20% em forma de bônus para os 2 mil funcionários, quanto cada um irá receber no período contido no dataset.

PREMISSAS
- Receita sendo considerada como (order_amount) + (order_delivery_fee) 
- Custo Fixo de 5 reais
- Entregas finalizadas e Pagas
*/




with receita as (
	select 
		o.order_id as ordem,
		sum(o.order_amount + o.order_delivery_fee) as Receita,
		sum(o.order_amount + o.order_delivery_fee) * 0.15 as Receita_15
	from 
		orders o
	left join payments p 
	on p.payment_order_id = o.payment_order_id 
	where o.order_status = 'FINISHED' and p.payment_status = 'PAID'
	group by o.order_id 
), lucro_por_entrega as (
	select 
		Receita_15 - 5 as Lucro_Entrega
	from receita
), total_lucro as (
	select
		Sum(lucro_entrega) as lucro
	from lucro_por_entrega
)
select 
		lucro * 0.2 as Distribuição,
		( lucro * 0.2 ) / 2000 as Por_funcionario
from total_lucro