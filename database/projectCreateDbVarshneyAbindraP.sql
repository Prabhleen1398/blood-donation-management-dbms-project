DROP DATABASE IF EXISTS bloodbankvarshneyabindrap;
CREATE DATABASE bloodbankvarshneyabindrap;

USE bloodbankvarshneyabindrap;

DROP TABLE IF EXISTS administrator;
CREATE TABLE administrator(
	volunteer_id INT AUTO_INCREMENT PRIMARY KEY,
	user_name VARCHAR(30) UNIQUE NOT NULL,
	user_password VARCHAR(20) NOT NULL
);

DROP TABLE IF EXISTS blood_group;
CREATE TABLE blood_group(
	blood_group_type VARCHAR(3) PRIMARY KEY,
    text_description TEXT(100)
);

DROP TABLE IF EXISTS donor;
CREATE TABLE donor(
	donor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name CHAR(30) NOT NULL,
    last_name CHAR(30) NOT NULL,
    street VARCHAR(30),
    state CHAR(30),
    zip_code CHAR(5) NOT NULL,
    phone INT(11) UNIQUE NOT NULL,
    gender CHAR(15) NOT NULL,
    age INT NOT NULL,
    medical_remarks TEXT(200),
    blood_group VARCHAR(3),
    date_of_registration DATE NOT NULL,
    registrar_id INT,
    CONSTRAINT donor_bg_fk
	FOREIGN KEY (blood_group) REFERENCES blood_group(blood_group_type)
    ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT donor_registered_by_fk
	FOREIGN KEY (registrar_id) REFERENCES administrator(volunteer_id)
    ON UPDATE CASCADE ON DELETE SET NULL
);


DROP TABLE IF EXISTS blood_group_receiver;
CREATE TABLE blood_group_receiver(
    blood_group_donor VARCHAR(3),
	blood_group_receiver VARCHAR(3),
    CONSTRAINT blood_group_combination_pk
	PRIMARY KEY (blood_group_donor, blood_group_receiver), 
    CONSTRAINT blood_group_donor_fk
	FOREIGN KEY (blood_group_donor) REFERENCES blood_group(blood_group_type)
    ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT blood_group_receiver_fk
	FOREIGN KEY (blood_group_receiver) REFERENCES blood_group(blood_group_type)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

DROP TABLE IF EXISTS inventory;
CREATE TABLE inventory(
	inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    street VARCHAR(30) UNIQUE NOT NULL,
    state CHAR(30) NOT NULL,
    zip_code CHAR(5) NOT NULL,
    blood_bag_available_quantity INT DEFAULT 0
);

DROP TABLE IF EXISTS blood_bag;
CREATE TABLE blood_bag(
	bag_id INT AUTO_INCREMENT PRIMARY KEY,
    blood_group VARCHAR(3),
    date_of_issue DATE NOT NULL,
    date_of_use DATE NOT NULL,
    inventory_id INT,
    donor_id INT,
    CONSTRAINT blood_bag_group_fk
    FOREIGN KEY (blood_group) REFERENCES blood_group(blood_group_type)
    ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT inventory_blood_fk
	FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT blood_donor_fk
	FOREIGN KEY (donor_id) REFERENCES donor(donor_id)
    ON UPDATE CASCADE ON DELETE SET NULL
);
 
DROP TABLE IF EXISTS hospital;
CREATE TABLE hospital(
	hospital_id INT AUTO_INCREMENT PRIMARY KEY,
    hospital_name VARCHAR(30),
    street VARCHAR(30) UNIQUE NOT NULL,
    state CHAR(30) NOT NULL,
    zip_code CHAR(5) NOT NULL
);

-- severity 10 means low risk, while 1 is high severity and needs blood from any of the inventories.
-- ALL ADMISSION REASONS TILL SEVERITY 5 NEED HOSPITAL TO REQUEST BLOOD FROM BANKS.
DROP TABLE IF EXISTS admission;
CREATE TABLE admission(
	type_of_admission VARCHAR(30),
    severity INT NOT NULL CHECK (severity between 1 and 10),
    CONSTRAINT admission_pk
    PRIMARY KEY (type_of_admission, severity)
);

DROP TABLE IF EXISTS patient;
CREATE TABLE patient(
	patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name CHAR(30),
    last_name CHAR(30),
    blood_group VARCHAR(3),
    remarks TEXT(100),
    hospital_id INT,
    admission_reason VARCHAR(30),
    CONSTRAINT blood_group_fk
    FOREIGN KEY (blood_group) REFERENCES blood_group(blood_group_type)
    ON UPDATE RESTRICT ON DELETE RESTRICT,
    CONSTRAINT patient_hospital_fk
    FOREIGN KEY (hospital_id) REFERENCES hospital(hospital_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT patient_reason_fk
    FOREIGN KEY (admission_reason) REFERENCES admission(type_of_admission)
    ON UPDATE RESTRICT ON DELETE RESTRICT
);

DROP TABLE IF EXISTS hospital_requests_blood;
CREATE TABLE hospital_requests_blood(
	request_id INT AUTO_INCREMENT PRIMARY KEY,
	inventory_id INT,
    hospital_id INT,
    approver_id INT,
    CONSTRAINT request_approved_by_admin_fk
	FOREIGN KEY (approver_id) REFERENCES administrator(volunteer_id)
    ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT hospital_inventory_fk
    FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT hospital_fk
    FOREIGN KEY (hospital_id) REFERENCES hospital(hospital_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);