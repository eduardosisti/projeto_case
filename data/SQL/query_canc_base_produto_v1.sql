-- Cancelamento por produto
with filtro_produto as (
select 'Device V1'
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