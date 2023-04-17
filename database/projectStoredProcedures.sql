USE bloodbankvarshneyabindrap;
-- stored procedures
drop procedure if exists add_admin;
delimiter //
create procedure add_admin(username varchar(30),
							u_password varchar(30))
begin
	insert into administrator values (username, u_password);
end//
delimiter ;

drop procedure if exists select_blood_group;
delimiter //
create procedure select_blood_group()
begin
	select blood_group_type from blood_group;
end//
delimiter ;

drop procedure if exists create_donor;
delimiter //
create procedure create_donor(in first_name_v char(30),
								in last_name_v char(30),
                                in street_v varchar(30),
                                in state_v char(30),
                                in zip_code_v int(5),
                                in phone_v INT(10),
								in gender_v CHAR(15),
								in age_v INT,
								in medical_remarks_v TEXT(200),
								in blood_group_v VARCHAR(3),
                                in registrar_id_v INT
                                )
begin
    insert into donor(first_name, last_name, street, state, zip_code, phone, gender, 
    age, medical_remarks, blood_group, date_of_registration, registrar_id) 
    values (first_name_v, last_name_v, street_v, state_v, zip_code_v, phone_v, gender_v, 
    age_v, medical_remarks_v, blood_group_v, current_date(), registrar_id_v);
end//
delimiter ;

-- test
call create_donor('test', 'user', '1', 'MA', 02120, 123456789, 'F', 24, 'test remark', 'B+', 1);

select * from donor;

drop procedure if exists update_donor_details;
delimiter //
create procedure update_donor_details(in phone_num int(10),
								in fname char(30),
								in lname char(30),
                                in street_updated varchar(30),
                                in state_updated char(30),
                                in zip_code_updated int(5),
                                in gender_updated CHAR(15),
								in age_updated INT,
								in medical_remarks_updated TEXT(200))
begin
	declare find_phone int;
    
    select count(phone) into find_phone 
     from donor where phone = phone_num; 
	
    if find_phone = 0 then
     SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No user found, please recheck phone';
	else
		if fname <> null then
			update donor set first_name = fname;
        end if;
        if lname <> null then
			update donor set last_name = lname;
        end if;
		if street_updated <> null then
			update donor set street = street_updated;
        end if;
        if zip_code_updated <> null then
			update donor set zip_code = zip_code_updated;
        end if;
        if gender_updated <> null then
			update donor set gender = gender_updated;
        end if;
        if age_updated <> null then
			update donor set age = age_updated;
        end if;
        if medical_remarks_updated <> null then
			update donor set medical_remarks = medical_remarks_updated;
        end if;
	end if;
end//
delimiter ;

drop procedure if exists delete_donor;
delimiter //
create procedure delete_donor(in phone_num int(10))
begin
	declare find_phone int;
	
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

drop procedure if exists add_blood_bag;
delimiter //
create procedure add_blood_bag(in phone_num int(10))
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
	update inventory set blood_bag_available_quantity = blood_bag_available_quantity + 1 where inventory_id = inventory_id_var;
    end if;
end//
delimiter ;  

call add_blood_bag(123456789);
select * from blood_bag;
select * from inventory;

call add_blood_bag(1234);

drop procedure if exists refresh_inventory;
delimiter //
create procedure refresh_inventory()
begin
	declare inventory_id_var int;
    set inventory_id_var = 1;
	update inventory set blood_bag_available_quantity = (select count(bag_id) from blood_bag group by inventory_id) where inventory_id = inventory_id_var;
end//
delimiter ;  

call refresh_inventory();
select * from inventory; 

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
        UPDATE inventory 
			SET blood_bag_available_quantity = blood_bag_available_quantity + 1 
             where inventory_id = inventory_id_var;
END$$
delimiter ;

call create_donor('test1', 'user2', '12', 'MA', '02120', 1230897809, 'F', 24, 'test remark 2', 'B+', 1);

select * from donor;
select * from blood_bag;
select * from inventory;