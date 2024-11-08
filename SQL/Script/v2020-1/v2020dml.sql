insert into plan_uso_mineral(id_cocho,id_mineral,data,id_usuario)
select
 id,id_mineral,cast(datareg as date),id_usuario from cocho
where status=1 and id not in(select id_cocho from plan_uso_mineral);

UPDATE ANIMAL SET FLAG_SYNC_TERCEIROS=0
WHERE FLAG_SYNC_TERCEIROS IS NULL;
        