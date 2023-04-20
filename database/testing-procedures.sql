select * from blood_bag;

select * from patient;
select * from admission;

call add_hospital('hospital 2', '111', 'MA', '02115');

select * from inventory;

call add_patient_to_hospital('user', 'test', 'B+', 'test add', 'hospital 2', 'anemia', 4);

select * from blood_bag;
select * from hospital_requests_blood;

select * from approve_requests_archive;

call approve_hospital_request(2, 1);

select * from patient;

call add_additional_blood_bag(1);

call get_blood_by_group();

select inventory_id, bg.blood_group_type, count(blood_group) as available_count from(
select inventory_id, blood_group, count(available) from blood_bag as count_bg
group by blood_group, available, inventory_id
having available = 1) as t
right join blood_group bg
on bg.blood_group_type = t.blood_group
group by bg.blood_group_type, inventory_id
order by available_count desc;


select inventory_id, bg.blood_group_type, count(available) as count_units
     from blood_group bg
     left join blood_bag b
     on b.blood_group = bg.blood_group_type
     group by inventory_id, bg.blood_group_type
     order by count_units desc;