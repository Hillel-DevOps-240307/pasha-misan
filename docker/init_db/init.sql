CREATE database flask_db;
CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY 'Pa55WD';
GRANT ALL on flask_db.* to  'admin'@'%';
