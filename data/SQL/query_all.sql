--dias ate o cancelamento
select start_date::date, cancellation_date::date, cancellation_date::date -  start_date::date dias_ate_cancelamento from raw_case_parte_dois
where cancellation_date is not null
order by cancellation_date::date -  start_date::date desc


--contagem de cancellation_reason 
select cancellation_reason, count(cancellation_reason) from raw_case_parte_dois
where cancellation_date is not null
group by cancellation_reason

--cancelamentos por dia
select cancellation_date::date, count(cancellation_date) from raw_case_parte_dois 
where cancellation_date is not null
group by cancellation_date::date
order by cancellation_date::date desc


--cancelamentos por mes
select to_char(cancellation_date::date, 'YYYY-MM')mes_ano, count(cancellation_date) cancelamentos from raw_case_parte_dois 
where cancellation_date is not null
group by to_char(cancellation_date::date, 'YYYY-MM')
order by to_char(cancellation_date::date, 'YYYY-MM') desc


--Quantidade de tickets abertos até o cancelamento
select tickets_opened, count(tickets_opened) cancelamento_por_tickets from raw_case_parte_dois 
where cancellation_date is not null
group by tickets_opened
order by tickets_opened desc

--tempo até o primeiro chamado
select first_ticket_open_date::date - start_date::date dias_ate_cancelamento , count(first_ticket_open_date::date - start_date::date) frequencia from raw_case_parte_dois 
where first_ticket_open_date is not null
group by first_ticket_open_date::date - start_date::date
order by first_ticket_open_date::date - start_date::date asc


-- produtos cancelados
select product, count(product) from raw_case_parte_dois 
where cancellation_date is not null
group by product


--contratos novos por mes
select to_char(start_date::date, 'YYYY-MM') mes_ano, count(start_date) from raw_case_parte_dois 
group by to_char(start_date::date, 'YYYY-MM')
order by to_char(start_date::date, 'YYYY-MM') desc


--base e quebras de contratos
select count(start_date) contratos_mes, count(cancellation_date)contratos_cancelados, count(cancellation_date)/ count(start_date)::float media_cancelamento from raw_case_parte_dois 

--contratos quebrados pelo mes de aquisição
select to_char(start_date::date, 'YYYY-MM')mes_ano, count(start_date) contratos_mes, count(cancellation_date)contratos_cancelados, count(cancellation_date)/ count(start_date)::float media_cancelamento from raw_case_parte_dois 
group by to_char(start_date::date::date, 'YYYY-MM')
order by to_char(start_date::date::date, 'YYYY-MM') desc



--produtos contratos por mes
select to_char(start_date::date, 'YYYY-MM'), product, count(product) from raw_case_parte_dois 
group by to_char(start_date::date, 'YYYY-MM'), product
order by to_char(start_date::date, 'YYYY-MM') desc

--cameras contratadas por mes
select to_char(start_date::date, 'YYYY-MM'), cameras, count(cameras) from raw_case_parte_dois 
group by to_char(start_date::date, 'YYYY-MM'), cameras
order by to_char(start_date::date, 'YYYY-MM') desc, cameras desc


--cameras contratadas  
select  cameras, count(cameras) from raw_case_parte_dois 
group by cameras
order by count(cameras) desc


select count(distinct phone_number)  from raw_case_parte_um

select count(*) from (
select phone_number, count(phone_number)  from raw_case_parte_um
group by phone_number
having count(phone_number) > 1
)


--cancelamento pelo tempo
with frame as (
select to_char(start_date::date, 'YYYY') ano ,to_char(start_date::date, 'MM') mes, count(start_date) novos_contratos_mes  from raw_case_parte_dois p2
group by to_char(start_date::date, 'YYYY') ,to_char(start_date::date, 'MM')
order by to_char(start_date::date, 'YYYY') asc ,to_char(start_date::date, 'MM') asc
)
,canc_mes as (
select to_char(cancellation_date::date, 'YYYY') ano ,to_char(cancellation_date::date, 'MM') mes, count(cancellation_date) cancelamento_mes  from raw_case_parte_dois p2 
group by to_char(cancellation_date::date, 'YYYY') ,to_char(cancellation_date::date, 'MM')
order by to_char(cancellation_date::date, 'YYYY') asc ,to_char(cancellation_date::date, 'MM') asc
)
select frame.ano
,frame.mes
,frame.novos_contratos_mes
,cm.cancelamento_mes
,frame.novos_contratos_mes - cm.cancelamento_mes base_ativa_mes
, SUM(frame.novos_contratos_mes - cm.cancelamento_mes ) OVER (order by frame.ano, frame.mes) base_ativa_acum
, SUM(frame.novos_contratos_mes - cm.cancelamento_mes ) OVER (order by frame.ano, frame.mes) + cm.cancelamento_mes base_total
, replace((cm.cancelamento_mes/(SUM(frame.novos_contratos_mes - cm.cancelamento_mes ) OVER (order by frame.ano, frame.mes) + cm.cancelamento_mes)*100)::varchar,'.',',') percent_cancel
from frame
left join canc_mes cm on cm.ano = frame.ano and cm.mes = frame.mes




-- Cancelamento por produto
with filtro_produto as (
select 'Device V2'
)
, frame as (
select to_char(start_date::date, 'YYYY') ano ,to_char(start_date::date, 'MM') mes, count(start_date) novos_contratos_mes  from raw_case_parte_dois p2
where product = (select * from filtro_produto)
group by to_char(start_date::date, 'YYYY') ,to_char(start_date::date, 'MM')
order by to_char(start_date::date, 'YYYY') asc ,to_char(start_date::date, 'MM') asc
)
,canc_mes as (
select to_char(cancellation_date::date, 'YYYY') ano ,to_char(cancellation_date::date, 'MM') mes, count(cancellation_date) cancelamento_mes  from raw_case_parte_dois p2 
where product = (select * from filtro_produto)
group by to_char(cancellation_date::date, 'YYYY') ,to_char(cancellation_date::date, 'MM')
order by to_char(cancellation_date::date, 'YYYY') asc ,to_char(cancellation_date::date, 'MM') asc
)
select frame.ano
,frame.mes
,frame.novos_contratos_mes
,coalesce(cm.cancelamento_mes,0)
,frame.novos_contratos_mes - coalesce(cm.cancelamento_mes,0) base_ativa_mes
, SUM(frame.novos_contratos_mes - coalesce(cm.cancelamento_mes,0)) OVER (order by frame.ano, frame.mes) base_ativa_acum
, SUM(frame.novos_contratos_mes - coalesce(cm.cancelamento_mes,0))  OVER (order by frame.ano, frame.mes) + coalesce(cm.cancelamento_mes,0) base_total
, replace((coalesce(cm.cancelamento_mes,0)/(SUM(frame.novos_contratos_mes - coalesce(cm.cancelamento_mes,0) ) OVER (order by frame.ano, frame.mes) + coalesce(cm.cancelamento_mes,0)))::varchar,'.',',') percent_cancel
from frame
left join canc_mes cm on cm.ano = frame.ano and cm.mes = frame.mes



--cohort de cancelamento
select  
to_char(cancellation_date ::date, 'YYYY') ano,
(DATE_PART('year', cancellation_date) - DATE_PART('year', start_date)) * 12 
         + (DATE_PART('month', cancellation_date) - DATE_PART('month', start_date)) months_to_cancelation,
         count(*) quant_canc
         from raw_case_parte_dois p2
         where cancellation_date is not null
         group by to_char(cancellation_date ::date, 'YYYY'),(DATE_PART('year', cancellation_date) - DATE_PART('year', start_date)) * 12 + (DATE_PART('month', cancellation_date) - DATE_PART('month', start_date))
         order by to_char(cancellation_date ::date, 'YYYY') asc, (DATE_PART('year', cancellation_date) - DATE_PART('year', start_date)) * 12 + (DATE_PART('month', cancellation_date) - DATE_PART('month', start_date)) asc

         
     
         
--cancelamento cameras        
with filtro_camera as (
select 12
)
, frame as (
select to_char(start_date::date, 'YYYY') ano ,to_char(start_date::date, 'MM') mes, count(start_date) novos_contratos_mes  from raw_case_parte_dois p2
where cameras = (select * from filtro_camera)
group by to_char(start_date::date, 'YYYY') ,to_char(start_date::date, 'MM')
order by to_char(start_date::date, 'YYYY') asc ,to_char(start_date::date, 'MM') asc
)
,canc_mes as (
select to_char(cancellation_date::date, 'YYYY') ano ,to_char(cancellation_date::date, 'MM') mes, count(cancellation_date) cancelamento_mes  from raw_case_parte_dois p2 
where cameras = (select * from filtro_camera)
group by to_char(cancellation_date::date, 'YYYY') ,to_char(cancellation_date::date, 'MM')
order by to_char(cancellation_date::date, 'YYYY') asc ,to_char(cancellation_date::date, 'MM') asc
)
select frame.ano
,frame.mes
,frame.novos_contratos_mes
,coalesce(cm.cancelamento_mes,0) cancelamento_mes
,frame.novos_contratos_mes - coalesce(cm.cancelamento_mes,0) base_ativa_mes
, SUM(frame.novos_contratos_mes - coalesce(cm.cancelamento_mes,0)) OVER (order by frame.ano, frame.mes) base_ativa_acum
, SUM(frame.novos_contratos_mes - coalesce(cm.cancelamento_mes,0))  OVER (order by frame.ano, frame.mes) + coalesce(cm.cancelamento_mes,0) base_total
, replace((coalesce(cm.cancelamento_mes,0)/(SUM(frame.novos_contratos_mes - coalesce(cm.cancelamento_mes,0) ) OVER (order by frame.ano, frame.mes) + coalesce(cm.cancelamento_mes,0)))::varchar,'.',',') percent_cancel
from frame
left join canc_mes cm on cm.ano = frame.ano and cm.mes = frame.mes

