select * from administrator;

call add_blood_bag('123456789');
call add_blood_bag('9810368362');
select * from blood_bag;
select * from inventory;

call add_blood_bag('1234');

select * from inventory; 

select * from blood_bag;
call refresh_inventory(1);
call create_donor('test1', 'user2', '12', 'MA', '02120', '98987865', 'F', 24, 'test remark 2', 'B+', 1);
SELECT * FROM DONOR;

select * from donor;
select * from blood_bag;
select * from inventory;

call get_current_blood_stock_at_inventory();
call get_blood_by_group();

call create_donor('user2', 'test', 'address', 'MA', '02120', '34789520', 'F', 24, 'test remark', 'O+', 1);

select * from blood_bag;
select * from inventory;

call get_reasonofadmission();
call add_hospital('test_hospital', '123', 'Boston', '02115');
call add_patient_to_hospital('test', 'patient', 'B+', 'testing', 1, 'Surgery');
select * from patient;
select * from hospital_requests_blood;

select * from blood_bag;
select * from inventory;


select * from hospital_requests_blood;

call delete_donor('123');        
