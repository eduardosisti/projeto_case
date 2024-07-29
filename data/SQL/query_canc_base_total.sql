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