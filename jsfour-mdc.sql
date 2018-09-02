USE `essentialmode`;

CREATE TABLE `jsfour_incidents` (
	`pk` int(11) NOT NULL AUTO_INCREMENT,
	`number` VARCHAR(255) NULL,
	`text` VARCHAR(255) NULL,
	`uploader` VARCHAR(255) NULL,
	`date` VARCHAR(255) NULL,
	PRIMARY KEY (`pk`)
);

CREATE TABLE `jsfour_cardetails` (
	`pk` int(11) NOT NULL AUTO_INCREMENT,
  	`plate` varchar(255) NULL,
 	`owner` varchar(255) NULL,
  	`incident` varchar(255) NOT NULL DEFAULT '{}',
  	`inspected` varchar(255) NULL,
  	`identifier` varchar(255) NULL,
  	PRIMARY KEY (`pk`)
);

CREATE TABLE `jsfour_logs` (
	`pk` int(11) NOT NULL AUTO_INCREMENT,
	`type` varchar(255) NULL,
	`remover` varchar(255) NULL,
	`wanted` varchar(255) NULL,
	PRIMARY KEY (`pk`)
);

CREATE TABLE `jsfour_efterlysningar` (
	`pk` int(11) NOT NULL AUTO_INCREMENT,
	`wanted` VARCHAR(255) NULL,
	`dob` VARCHAR(255) NULL,
	`crime` VARCHAR(255) NULL,
	`uploader` VARCHAR(255) NULL,
	`date` VARCHAR(255) NULL,
	`incident` VARCHAR(255) NULL,
	PRIMARY KEY (`pk`)
);
