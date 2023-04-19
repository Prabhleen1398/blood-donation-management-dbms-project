use bloodbankvarshneyabindrap;
call add_admin('aditya','aditya');
select * from administrator where user_name = 'aditya' AND user_password = 'aditya';
select * from administrator;
select * from donor;
select * from blood_bag;
select * from hospital;
call add_patient_to_hospital('name','name','A+','No remarks','New Amsterdam','Accident',8);
call get_hospitals();
select * from patient;

select * from admission;
call select_blood_group();

call select_hospital_requests();

select * from hospital_requests_blood ;
select * from patient;