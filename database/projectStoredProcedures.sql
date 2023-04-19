USE bloodbankvarshneyabindrap;
-- stored procedures
DROP PROCEDURE IF EXISTS add_admin;
DELIMITER //
CREATE PROCEDURE add_admin(IN username varchar(30), 
							IN u_password varchar(30)) 
BEGIN
	INSERT INTO administrator(user_name, user_password)
	VALUES (username, u_password); 
END//
DELIMITER ;
CALL add_admin('testuser', 'pass123');

DROP PROCEDURE IF EXISTS select_blood_group;


DELIMITER //
CREATE PROCEDURE select_blood_group() 
BEGIN
	SELECT blood_group_type
	 FROM blood_group; 
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS create_donor;


DELIMITER //
CREATE PROCEDURE create_donor(in first_name_v CHAR(30),
							in last_name_v CHAR(30), 
                            in street_v varchar(30), 
                            in state_v CHAR(30), 
                            in zip_code_v CHAR(5), 
                            in phone_v VARCHAR(10), 
                            in gender_v CHAR(15), 
                            in age_v INT, 
                            in medical_remarks_v TEXT(200), 
                            in blood_group_v VARCHAR(3), 
                            in registrar_id_v INT) 
BEGIN 
	DECLARE duplicate_entry_for_key TINYINT DEFAULT FALSE; 
    BEGIN 
		DECLARE EXIT HANDLER FOR 1062
			SET duplicate_entry_for_key = TRUE;
		INSERT INTO donor(first_name, last_name, street, state, zip_code, phone, gender, age, medical_remarks, 
						blood_group, date_of_registration, registrar_id)
		VALUES (first_name_v, last_name_v, street_v, state_v, zip_code_v, phone_v, gender_v, age_v, medical_remarks_v,
					blood_group_v, current_date(), registrar_id_v); 
	END; 
	
    IF duplicate_entry_for_key = TRUE THEN
		SIGNAL SQLSTATE '23000'
			SET MESSAGE_TEXT = "Phone number already exists"; 
	END IF; 
END//
DELIMITER ;

-- test
call create_donor('test', 'user', '1', 'MA', '02120', '123456789', 'F', 24, 'test remark', 'B+', 1);
select * from donor;

DROP PROCEDURE IF EXISTS update_donor_details;
delimiter //
CREATE PROCEDURE update_donor_details(in phone_num CHAR(10),
								in fname char(30),
								in lname char(30),
                                in street_updated varchar(30),
                                in state_updated char(30),
                                in zip_code_updated CHAR(5),
                                in gender_updated CHAR(15),
								in age_updated INT,
								in medical_remarks_updated TEXT(200))
BEGIN
	DECLARE find_phone INT;
    DECLARE donor_match_id INT;
    
    SELECT count(phone) INTO find_phone 
     FROM donor WHERE phone = phone_num; 
	
    IF find_phone = 0 THEN
     SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No user found, please recheck phone';
	ELSE
		select donor_id into donor_match_id from donor where phone = phone_num;
        
		if fname is not null then
			update donor set first_name = fname where donor_id = donor_match_id;
        end if;
        if lname is not null then
			update donor set last_name = lname where donor_id = donor_match_id;
        end if;
		if street_updated is not null then
			update donor set street = street_updated where donor_id = donor_match_id;
        end if;
        if zip_code_updated is not null then
			update donor set zip_code = zip_code_updated where donor_id = donor_match_id;
        end if;
        if gender_updated is not null then
			update donor set gender = gender_updated where donor_id = donor_match_id;
        end if;
        if age_updated is not null then
			update donor set age = age_updated where donor_id = donor_match_id;
        end if;
        if medical_remarks_updated is not null then
			update donor set medical_remarks = medical_remarks_updated where donor_id = donor_match_id;
        end if;
	end if;
end//
delimiter ;

call update_donor_details('8573179963', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Fit to donate');
select * from donor;
call update_donor_details('8573179963', NULL, NULL, NULL, NULL, NULL, NULL, 26, 'Fit to donate');

drop procedure if exists delete_donor;
delimiter //
create procedure delete_donor(in phone_num CHAR(10))
begin
	declare find_phone CHAR(10);
	
    select count(phone) into find_phone 
     from donor where phone = phone_num; 
	
    if find_phone = 0 then
     SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No user found, please recheck phone';
	else
		delete from donor where phone = phone_num;
	end if;
end//
delimiter ;        


call delete_donor('123456789');
select * from donor;  

call delete_donor('123');        

DROP PROCEDURE IF EXISTS add_blood_bag;
delimiter //
create procedure add_blood_bag(in phone_num CHAR(10))
begin
	declare inventory_id_var int;
    set inventory_id_var = 1;
	if phone_num not in (select phone from donor where phone = phone_num) then
     SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'User not yet registered, please register first';
	else
     insert into blood_bag(blood_group, date_of_issue, date_of_use, inventory_id, donor_id)
								values ((select blood_group from donor where phone = phone_num), 
									curdate(), date_add(curdate(), INTERVAL 7 DAY), inventory_id_var, 
                                    (select donor_id from donor where phone_num = phone));
	update inventory set blood_bag_available_quantity = (select count(available) 
														  from blood_bag 
                                                          group by inventory_id 
														) 
							where inventory_id = inventory_id_var;
    end if;
end//
delimiter ;  

call add_blood_bag('123456789');
call add_blood_bag('9810368362');
select * from blood_bag;
select * from inventory;

call add_blood_bag('1234');

drop procedure if exists refresh_inventory;
delimiter //
create procedure refresh_inventory(in inventory_id_in int)
begin
	update inventory set blood_bag_available_quantity = (select count(bag_id) 
														  from blood_bag 
                                                          group by inventory_id, available
                                                          having available = true) 
							where inventory_id = inventory_id_in;
end//
delimiter ;  

call refresh_inventory(1);
select * from inventory; 

select * from blood_bag;

DROP TRIGGER IF EXISTS insert_blood_bag_after_adding_donor;
delimiter $$
CREATE TRIGGER insert_blood_bag_after_adding_donor
AFTER INSERT ON donor
FOR EACH ROW
BEGIN
	declare inventory_id_var int;
    set inventory_id_var = 1;
		insert into blood_bag(blood_group, date_of_issue, date_of_use, inventory_id, donor_id)
								values (NEW.blood_group, 
									curdate(), date_add(curdate(), INTERVAL 7 DAY), inventory_id_var, 
                                    NEW.donor_id);
END$$
delimiter ;

DROP TRIGGER IF EXISTS update_inventory_after_bag_added;
delimiter $$
CREATE TRIGGER update_inventory_after_bag_added
AFTER INSERT ON blood_bag
FOR EACH ROW
BEGIN
	call refresh_inventory(NEW.inventory_id);
END$$
delimiter ;

call create_donor('test1', 'user2', '12', 'MA', '02120', '8573179963', 'F', 24, 'test remark 2', 'B+', 1);
SELECT * FROM DONOR;

select * from donor;
select * from blood_bag;
select * from inventory;

drop procedure if exists get_current_blood_stock_at_inventory;
delimiter //
create procedure get_current_blood_stock_at_inventory()
begin
	select inventory_id, blood_bag_available_quantity from inventory;
end//
delimiter ; 

call get_current_blood_stock_at_inventory();

drop procedure if exists get_blood_by_group;
delimiter //
create procedure get_blood_by_group()
begin
	select inventory_id, blood_group, count(blood_group) 
     from blood_bag 
     group by inventory_id, blood_group;
end//
delimiter ;

call get_blood_by_group();

call create_donor('user2', 'test', 'address', 'MA', '02120', '8573179963', 'F', 24, 'test remark', 'AB+', 1);

select * from blood_bag;
select * from inventory;

-- stored procedure and trigger from hospital perspective
drop procedure if exists add_hospital;
delimiter //
create procedure add_hospital(in hospital_name_in VARCHAR(30),
							in street_in VARCHAR(30),
							in state_in CHAR(30),
							in zip_code_in CHAR(5))
begin
	insert into hospital(hospital_name, street, state, zip_code)
     values
	(hospital_name_in, street_in, state_in, zip_code_in);
end//
delimiter ;


drop procedure if exists get_hospitals;
delimiter //
create procedure get_hospitals()
begin
	SELECT hospital_id,hospital_name from hospital;
end//
delimiter ;

drop procedure if exists get_reasonofadmission;
delimiter //
create procedure get_reasonofadmission()
begin
	SELECT type_of_admission,severity from admission;
end//
delimiter ;

call get_reasonofadmission();

drop procedure if exists add_patient_to_hospital;
delimiter //
create procedure add_patient_to_hospital(in fname CHAR(30),
										in lname CHAR(30),
										in blood_group_in VARCHAR(3),
										in remarks_in TEXT(100),
										in hospital_name_in VARCHAR(30),
										in admission_reason_in VARCHAR(30),
                                        in severity_in int)
begin
	
	insert into patient(first_name, last_name, blood_group, remarks, hospital_id,  admission_reason,severity)
     values
	(fname, lname, blood_group_in, remarks_in, (SELECT hospital_id FROM hospital WHERE hospital_name = hospital_name_in), admission_reason_in,severity_in);
end//
delimiter ;

call add_hospital('test_hospital', '123', 'Boston', '02115');
call add_patient_to_hospital('test', 'patient', 'B+', 'testing', 1, 'Surgery');


select * from patient;
select * from hospital_requests_blood;

select * from blood_bag;
select * from inventory;

DROP TRIGGER IF EXISTS hospital_request_blood_from_inventory;
delimiter $$
CREATE TRIGGER hospital_request_blood_from_inventory
AFTER INSERT ON patient
FOR EACH ROW
BEGIN
declare bag_id_chosen int;
	declare severity_var int;
    select severity into severity_var from admission 
    where type_of_admission = (select NEW.admission_reason from patient where patient_id = NEW.patient_id);
    
    if severity_var < 5 then
    
		select bag_id into bag_id_chosen 
		from blood_bag where blood_group = any( 
			select blood_group_donor 
			from blood_group_receiver 
			where blood_group_receiver = (select blood_group from patient where patient_id = NEW.patient_id))
            and available = true
		order by date_of_use limit 1;
		
        if bag_id_chosen is null then
        
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Sorry, no blood units currently available';
		
        else
        
			insert into hospital_requests_blood(inventory_id, hospital_id, bag_id, blood_group_requested, blood_group_received)
			 values 
			((select inventory_id from blood_bag where bag_id = bag_id_chosen), 
			NEW.hospital_id, bag_id_chosen, NEW.blood_group, 
			(select blood_group from blood_bag where bag_id = bag_id_chosen));    
			
			update blood_bag set available = false where bag_id = bag_id_chosen;
		
        end if;
	end if;
END$$
delimiter ;


select * from hospital_requests_blood;

drop procedure if exists select_hospital_requests;
delimiter //
create procedure select_hospital_requests()
begin
	select request_id, inventory_id, hospital_name, bag_id, blood_group_requested, blood_group_received 
     from hospital_requests_blood 
     join hospital ON hospital_requests_blood.hospital_id = hospital.hospital_id
     where approver_id is null;
end//
delimiter ;
	
drop procedure if exists approve_hospital_request;
delimiter //
create procedure approve_hospital_request(in request_id_in int,
										 in approver_id_in int)
begin
	update hospital_requests_blood set approver_id = approver_id_in, 
										datetime_of_dispatch = current_timestamp()
									where request_id = request_id_in;
end//
delimiter ;


DROP TRIGGER IF EXISTS update_inventory_after_blood_bag_updated;
delimiter $$
CREATE TRIGGER update_inventory_after_blood_bag_updated
AFTER UPDATE ON blood_bag
FOR EACH ROW
BEGIN
	call refresh_inventory(NEW.inventory_id);
END$$
delimiter ;