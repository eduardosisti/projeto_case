--Quantidade de tickets abertos até o cancelamento
select tickets_opened, count(tickets_opened) cancelamento_por_tickets from raw_case_parte_dois 
where cancellation_date is not null
group by tickets_opened
order by tickets_opened desc