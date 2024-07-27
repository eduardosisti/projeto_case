with email_process as (
select 
customer_id
,email
,  CASE WHEN
    SUBSTRING(
        LOWER(email),
        '^[a-zA-Z0-9à-ÿ._+-]+@[a-zA-Z0-9à-ÿ.-]+\.[a-zA-Z]{2,}$'
    ) IS NOT NULL
    THEN email
   ELSE null
  END AS email_processed -- Validar estrutura do e-mail
from raw_case_parte_um 
)
,phone_process AS(
	with phone_string_replaces as(
	select customer_id
	,phone_number
	,replace(replace(replace(replace(replace(phone_number,'+',''),'(',''),')',''),'-',''),' ','') string_phone_processed -- retirar caracters especiais do telefone
	from raw_case_parte_um
)
select customer_id,
phone_number
,substring(string_phone_processed,0,3) country_code
,substring(string_phone_processed,3,2) ddd
,substring(string_phone_processed,3) phone_number_processed
from phone_string_replaces
where length(substring(string_phone_processed,3)) = 11 -- Validar tamanho do número de telefone
)
,postal_code_process as (
select 
customer_id
,postal_code
,lpad(replace(replace(postal_code,'-',''),' ',''),8,'0') postal_code_processed
from raw_case_parte_um 
where length(lpad(replace(replace(postal_code,'-',''),' ',''),8,'0')) = 8 -- Validar tamanho do postal_code
)
select
raw.customer_id
,raw.first_name
,raw.last_name
,ep.email_processed email
,pp.country_code
,pp.ddd
,pp.phone_number_processed phone_number
,raw.address
,raw.city
,raw.state
,raw.country
,pcp.postal_code_processed postal_code
from raw_case_parte_um raw 
left join email_process ep on ep.customer_id =  raw.customer_id
left join phone_process pp on pp.customer_id =  raw.customer_id
left join postal_code_process pcp on pcp.customer_id = raw.customer_id