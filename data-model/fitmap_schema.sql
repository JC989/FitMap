CREATE TABLE MunicipalEntities (
  municipal_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  entity_type VARCHAR(50) NOT NULL,
  contact_email VARCHAR(255),
  phone VARCHAR(20),
  plan_tier VARCHAR(20) NOT NULL DEFAULT 'free'
);

CREATE TABLE Users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  municipal_id INT NULL,
  role ENUM('visitor', 'municipal_admin', 'developer', 'trainer', 'business') NOT NULL DEFAULT 'visitor',
  username VARCHAR(50) NOT NULL UNIQUE,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (municipal_id) REFERENCES MunicipalEntities(municipal_id)
);

CREATE TABLE EquipmentTypes (
  equipment_type_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  category VARCHAR(50)
);

CREATE TABLE OutdoorGyms (
  gym_id INT AUTO_INCREMENT PRIMARY KEY,
  municipal_id INT NOT NULL,
  name VARCHAR(150) NOT NULL,
  street_address VARCHAR(255),
  city VARCHAR(100),
  state VARCHAR(50),
  zip_code VARCHAR(10),
  latitude DECIMAL(9,6),
  longitude DECIMAL(9,6),
  photo_url VARCHAR(500),
  wheelchair_accessible BOOLEAN NOT NULL DEFAULT FALSE,
  accessibility_notes TEXT,
  is_featured BOOLEAN NOT NULL DEFAULT FALSE,
  FOREIGN KEY (municipal_id) REFERENCES MunicipalEntities(municipal_id)
);

CREATE TABLE EquipmentInventory (
  gym_id INT NOT NULL,
  equipment_type_id INT NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  `condition` VARCHAR(20),
  last_updated DATETIME,
  PRIMARY KEY (gym_id, equipment_type_id),
  FOREIGN KEY (gym_id) REFERENCES OutdoorGyms(gym_id),
  FOREIGN KEY (equipment_type_id) REFERENCES EquipmentTypes(equipment_type_id)
);

CREATE TABLE ReviewsAndRatings (
  user_id INT NOT NULL,
  gym_id INT NOT NULL,
  rating TINYINT NOT NULL,
  comment TEXT,
  photo_url VARCHAR(500),
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, gym_id),
  FOREIGN KEY (user_id) REFERENCES Users(user_id),
  FOREIGN KEY (gym_id) REFERENCES OutdoorGyms(gym_id)
);

CREATE TABLE MaintenanceRequests (
  request_id INT AUTO_INCREMENT PRIMARY KEY,
  gym_id INT NOT NULL,
  equipment_type_id INT NOT NULL,
  reported_by INT NOT NULL,
  handled_by INT NULL,
  description TEXT,
  status ENUM('open', 'scheduled', 'resolved') NOT NULL DEFAULT 'open',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  scheduled_for DATETIME NULL,
  resolved_at DATETIME NULL,
  FOREIGN KEY (gym_id, equipment_type_id) REFERENCES EquipmentInventory(gym_id, equipment_type_id),
  FOREIGN KEY (reported_by) REFERENCES Users(user_id),
  FOREIGN KEY (handled_by) REFERENCES Users(user_id)
);

CREATE TABLE TrainerBookings (
  booking_id INT AUTO_INCREMENT PRIMARY KEY,
  trainer_id INT NOT NULL,
  client_id INT NOT NULL,
  gym_id INT NOT NULL,
  session_start DATETIME NOT NULL,
  duration_min INT NOT NULL,
  price DECIMAL(8,2) NOT NULL,
  platform_fee DECIMAL(8,2) NOT NULL,
  status ENUM('booked', 'completed', 'cancelled') NOT NULL DEFAULT 'booked',
  FOREIGN KEY (trainer_id) REFERENCES Users(user_id),
  FOREIGN KEY (client_id) REFERENCES Users(user_id),
  FOREIGN KEY (gym_id) REFERENCES OutdoorGyms(gym_id)
);

CREATE TABLE Promotions (
  promotion_id INT AUTO_INCREMENT PRIMARY KEY,
  business_id INT NOT NULL,
  gym_id INT NULL,
  promo_type ENUM('offer', 'ad') NOT NULL,
  title VARCHAR(150) NOT NULL,
  details TEXT,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  fee DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (business_id) REFERENCES Users(user_id),
  FOREIGN KEY (gym_id) REFERENCES OutdoorGyms(gym_id)
);
