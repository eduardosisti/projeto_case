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

         
         