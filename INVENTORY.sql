-------------------------------------- INVENTORY MANAGEMENT SYSTEM --------------------------------------------------

-- Create Database and access it
create database InventoryDB;
use InventoryDB;

-- Table 1: Products
create table Products 
	(product_id int primary key,
    name varchar(100) not null unique,
    description varchar(100),
    category varchar(50),
    price decimal(10,2) not null check (price >= 0),
    unit varchar(20),
    reorder_level int check (reorder_level >= 0)) ;
    
alter table Products modify unit int;
alter table Products drop unit;
alter table Products drop reorder_level;

-- Table 2: Inventory
create table Inventory 
	(inventory_id int primary key,
    product_id int not null,
    current_stock int not null check (current_stock >= 0),
    last_updated date,
	expiry_date date,    
    foreign key (product_id) references Products(product_id));
    
alter table Inventory modify inventory_id varchar(10);

-- Table 3: Suppliers
create table Suppliers 
	(supplier_id int primary key,
    name varchar(100) not null ,
    contact_person varchar(100),
    phone varchar(20) unique,
    email varchar(100) unique,
    address varchar(200));
    
-- Table 4: Purchases
create table Purchases 
	(purchase_id int primary key,
    product_id int not null,
    supplier_id int not null,
    quantity int not null check (quantity>0),
    purchase_date date,
    purchase_price decimal(10,2) check (purchase_price >0),
    foreign key (product_id) references Products(product_id),
    foreign key (supplier_id) references Suppliers(supplier_id));
    
alter table Purchases modify purchase_id varchar(10);
    
-- Table 5: Sales
create table Sales 
	(sale_id int primary key,
    product_id int not null,
    quantity int check (quantity > 0),
    sale_date date,
    customer_name varchar(100),
    foreign key (product_id) references Products(product_id));
    
alter table Sales modify sale_id varchar(10);

-- Table 6: Shipments
create table Shipments 
	(shipment_id varchar(10) primary key,
    product_id int not null,
    quantity int check (quantity > 0),
    shipment_date date,
    destination varchar(255),
    shipment_type enum('inbound', 'outbound'),
    check ((shipment_type = 'inbound' and purchase_id is not null and sale_id is null) 
							or
			(shipment_type = 'outbound' and sale_id is not null and purchase_id is null)),
    purchase_id varchar(10),  -- For inbound shipments
    sale_id varchar(10),      -- For outbound shipments
    foreign key (product_id) references Products(product_id),
    foreign key (purchase_id) references Purchases(purchase_id),
    foreign key (sale_id) references Sales(sale_id));

-- Insert records into Products
insert into Products (product_id, name, description, category, price, unit, reorder_level) 
values (1, 'Apple iPhone 14', '128GB, Midnight Black', 'Electronics', 79999.00),
	   (2, 'Samsung Galaxy S23', '128GB, Phantom Black', 'Electronics', 74999.00),
       (3, 'Amul Butter', '500g salted butter', 'Groceries', 250.00),
       (4, 'Aashirvaad Atta', '5kg whole wheat flour', 'Groceries', 300.00),
       (5, 'Nike Air Max', 'Men’s running shoes', 'Footwear', 5999.00),
       (6, 'Dell Inspiron 15', 'i5 12th Gen, 512GB SSD', 'Electronics', 58990.00),
       (7, 'Bournvita', 'Health Drink 1kg Jar', 'Healthcare', 450.00),
       (8, 'Pilot Pen Set', 'Set of 10 gel pens', 'Stationery', 150.00),
       (9, 'Godrej Interio Table', 'Office table, wood', 'Furniture', 8500.00),
       (10, 'Raymond Shirt', 'Cotton Formal Shirt', 'Clothing', 1599.00),
       (11, 'HP LaserJet Printer', 'All-in-one wireless printer', 'Electronics', 12499.00),
       (12, 'Parle-G Biscuits', 'Family pack 1kg', 'Groceries', 80.00),
       (13, 'Tata Salt', '1kg iodized salt', 'Groceries', 25.00),
       (14, 'Dettol Handwash', 'Liquid handwash 200ml', 'Personal Care', 60.00),
       (15, 'Asian Paints Bucket', '10L Royal Emulsion', 'Hardware', 1550.00),
       (16, 'Adidas Sports Shorts', 'Running shorts for men', 'Clothing', 1299.00),
       (17, 'Sony Headphones', 'Over-ear Bluetooth headset', 'Electronics', 4999.00),
       (18, 'Cinthol Soap', 'Pack of 4 soaps', 'Personal Care', 100.00),
       (19, 'Maggi Noodles', '12-pack family pack', 'Groceries', 150.00),
       (20, 'Colgate Toothpaste', '100g gel toothpaste', 'Personal Care', 90.00);

select * from Products;

-- Insert into Inventory Table
insert into Inventory (inventory_id, product_id, current_stock, last_updated, expiry_date) 
values ('IV0001', 7, 45, '2025-01-01', '2025-12-01'),
	   ('IV0002', 2, 10, '2025-01-05', '2028-01-05'), 
       ('IV0003', 14, 60, '2025-01-10', '2025-11-10'),
       ('IV0004', 19, 49, '2025-01-20', '2025-10-20'),
       ('IV0005', 11, 12, '2025-01-25', '2029-01-25'), 
       ('IV0006', 3, 51, '2025-01-30', '2025-12-30'),
       ('IV0007', 1, 11, '2025-02-04', '2029-02-04'), 
       ('IV0008', 9, 19, '2025-02-09', '2026-06-09'),
       ('IV0009', 8, 28, '2025-02-14', '2026-05-14'),
       ('IV0010', 4, 66, '2025-02-19', '2026-05-19'),
       ('IV0011', 20, 35, '2025-02-24', '2026-05-24'),
       ('IV0012', 10, 42, '2025-03-01', '2026-06-01'),
       ('IV0013', 6, 9, '2025-03-06', '2029-03-06'),  
       ('IV0014', 13, 73, '2025-03-11', '2026-06-11'),
       ('IV0015', 16, 25, '2025-03-16', '2026-07-16'),
       ('IV0016', 12, 59, '2025-03-21', '2026-06-21'),
       ('IV0017', 15, 44, '2025-03-26', '2026-06-26'),
       ('IV0018', 17, 15, '2025-03-31', '2029-03-31'), 
       ('IV0019', 18, 63, '2025-04-05', '2026-07-05'),
       ('IV0020', 5, 23, '2025-04-15', '2026-08-15');



-- Insert into Suppliers Table
insert into Suppliers (supplier_id, name, contact_person, phone, email, address) 
values
(1001, 'ElectroWorld Pvt Ltd', 'Rahul Sharma', '+91-9883297442', 'rahul.sharma@yahoo.com', '12th Floor, Oberoi Commerz, Goregaon East, Mumbai'),
(1002, 'FreshGro Mart', 'Priya Mehta', '+91-9888825063', 'priya.mehta@outlook.com', 'A-42, Andheri Industrial Estate, Andheri West, Mumbai'),
(1003, 'ShoeBox Distributors', 'Amit Desai', '+91-9830776185', 'amit.desai@yahoo.com', 'Plot No. C-59, Bandra Kurla Complex, Mumbai'),
(1004, 'GlowCare Essentials', 'Sneha Patil', '+91-9840228391', 'sneha.patil@gmail.com', 'Shop No. 101, High Street Phoenix, Lower Parel, Mumbai'),
(1005, 'ToolZone Hardware', 'Karan Joshi', '+91-9832136858', 'karan.joshi@yahoo.com', 'Office No. 9, Malad Link Road, Malad West, Mumbai'),
(1006, 'MediPlus Healthcare', 'Neha Kapoor', '+91-9811442743', 'neha.kapoor@outlook.com', 'Flat No. 4B, Sion-Trombay Road, Chembur, Mumbai'),
(1007, 'PaperPoint Stationery', 'Vikram Reddy', '+91-9871146117', 'vikram.reddy@yahoo.com', 'Unit 205, Raghuleela Mall, Kandivali West, Mumbai'),
(1008, 'FurniStyle Pvt Ltd', 'Anjali Verma', '+91-9899282361', 'anjali.verma@outlook.com', '3rd Floor, Crystal Plaza, Andheri East, Mumbai'),
(1009, 'TechElectra India', 'Rohit Kulkarni', '+91-9894933531', 'rohit.kulkarni@outlook.com', '302, Citi Mall, New Link Road, Andheri West, Mumbai'),
(1010, 'NatureFresh Grocery', 'Deepa Rao', '+91-9841905491', 'deepa.rao@yahoo.com', 'No. 116, Infinity Mall, Malad West, Mumbai'),
(1011, 'Electronics store', 'Ramesh Naik', '+91-9857293745', 'ramesh.naik@gmail.com', 'Shop 201, Inorbit Mall, Vashi, Mumbai'),
(1012, 'Radiant Beauty Supplies', 'Meena Joshi', '+91-9836579011', 'meena.joshi@outlook.com', '4th Floor, Phoenix Marketcity, Kurla, Mumbai'),
(1013, 'HP', 'Sanjay Bhatia', '+91-9801328947', 'sanjay.bhatia@yahoo.com', 'Unit 7, Laxmi Industrial Estate, Sakinaka, Mumbai'),
(1014, 'All In One Stop', 'Alka Pandey', '+91-9870191827', 'alka.pandey@outlook.com', 'Gala No. 14, Khar West, Mumbai'),
(1015, 'OneMart', 'Nikhil Shetty', '+91-9897716574', 'nikhil.shetty@yahoo.com', 'B-15, Veera Desai Road, Andheri West, Mumbai'),
(1016, 'Sports wear', 'Pooja Nair', '+91-9840001134', 'pooja.nair@gmail.com', '1st Floor, Oberoi Mall, Goregaon East, Mumbai'),
(1017, 'DigiTek Electronics', 'Sunil Varma', '+91-9876543012', 'sunil.varma@outlook.com', 'Plot 52, MIDC Area, Andheri East, Mumbai'),
(1018, 'Everyday Grocery Co.', 'Jyoti Kulkarni', '+91-9898725467', 'jyoti.kulkarni@yahoo.com', 'Near Railway Station, Dadar East, Mumbai'),
(1019, 'Myra Boutique', 'Manoj Deshmukh', '+91-9845553291', 'manoj.deshmukh@gmail.com', 'Opp. Shivaji Park, Mahim West, Mumbai'),
(1020, 'Glow & Go Cosmetics', 'Ritika Shah', '+91-9887765412', 'ritika.shah@yahoo.com', 'Shop 9, R City Mall, Ghatkopar West, Mumbai');


-- Insert into Purchases Table
insert into Purchases (purchase_id, product_id, supplier_id, quantity, purchase_date, purchase_price) 
values
      ('P001', 7, 1006, 72, '2024-12-13', 315.00), 
	  ('P002', 2, 1009, 15, '2024-12-13', 52499.00), 
      ('P003', 14, 1004, 80, '2024-12-13', 42.00),
      ('P004', 19, 1018, 60, '2024-12-13', 105.00),
      ('P005', 11, 1013, 37, '2024-12-25', 8749.00),
      ('P006', 3, 1002, 70, '2024-12-30', 175.00),
      ('P007', 1, 1001, 20, '2025-01-01', 55999.00),
      ('P008', 9, 1008,  24, '2025-01-17', 5950.00),
      ('P009', 8, 1007, 35, '2025-01-17', 105.00),
      ('P010', 4, 1010, 80, '2025-01-17', 210.00),
      ('P011', 20, 1020, 50, '2025-02-08', 63.00),
      ('P012', 10, 1019, 56, '2025-02-10', 1119.00),
      ('P013', 6, 1017, 11, '2025-02-17', 41293.00),
      ('P014', 13, 1015, 90, '2025-02-18', 17.50),
      ('P015', 16, 1016, 32, '2025-02-20', 909.00),
      ('P016', 12, 1014, 75, '2025-02-23', 56.00),
      ('P017', 15, 1005, 55, '2025-02-28', 1085.00),
      ('P018', 17, 1011, 27, '2025-02-02', 3499.00),
      ('P019', 18, 1012, 70, '2025-03-04', 70.00),
      ('P020', 5, 1003, 30, '2025-03-09', 4200.00);
      
update Purchases set purchase_date = '2025-02-28' where purchase_id = 'P018';
    
      
-- Insert into Sales Table
insert into Sales (sale_id, product_id, quantity, sale_date, customer_name) 
values
('S001', 19, 11, '2025-01-10', 'Reliance Fresh'),
('S002', 7, 27, '2025-01-11', 'Apollo Pharmacy'),
('S003', 3, 19, '2025-01-21', 'Nykaa'),
('S004', 2, 5, '2025-01-25', 'Croma'),
('S005', 18, 7, '2025-01-27', 'Purple'),
('S006', 6, 2, '2025-02-16', 'Big Bazaar'),
('S007', 11, 25, '2025-02-20', 'Pantaloons'),
('S008', 16, 7, '2025-02-28', 'Lifestyle'),
('S009', 8, 7, '2025-03-06', 'Netmeds'),
('S010', 12, 16, '2025-03-24', 'DMart'),
('S011', 13, 17, '2025-03-27', 'Max'),
('S012', 9, 5, '2025-04-01', 'Pepperfry'),
('S013', 17, 12, '2025-04-10', 'Reliance Digital'),
('S014', 15, 11, '2025-04-14', 'Home Depot'),
('S015', 4, 14, '2025-04-19', 'Reliance Fresh'),
('S016', 1, 9, '2025-05-10', 'Croma'),
('S017', 14, 20, '2025-05-15', 'Apollo Pharmacy'),
('S018', 10, 14, '2025-05-21', 'Nykaa'),
('S019', 5, 7, '2025-05-25', ' Lifestyle'),
('S020', 20, 15, '2025-06-01', 'IKEA');


-- Insert into Shipments table
insert into Shipments (shipment_id, product_id, quantity, shipment_date, destination, shipment_type, purchase_id, sale_id)
values
('SHP001', 7, 72, '2024-12-20', 'Dadar', 'inbound', 'P001', NULL),
('SHP002', 2, 15, '2024-12-17', 'Vashi', 'inbound', 'P002', NULL),
('SHP003', 14, 80, '2024-12-15', 'Andheri', 'inbound', 'P003', NULL),
('SHP004', 19, 60, '2024-12-16', 'Bandra', 'inbound', 'P004', NULL),
('SHP005', 11, 37, '2024-12-30', 'Kurla', 'inbound', 'P005', NULL),
('SHP006', 3, 70, '2025-01-05', 'Goregaon', 'inbound', 'P006', NULL),
('SHP007', 1, 20, '2025-01-07', 'Borivali', 'inbound', 'P007', NULL),
('SHP008', 19, 11, '2025-01-15', 'Dahisar', 'outbound', NULL, 'S001'),
('SHP009', 17, 27, '2025-01-18', 'Malad', 'outbound', NULL, 'S002'),
('SHP010', 9, 24, '2025-01-25', 'Santacruz', 'inbound', 'P008', NULL),
('SHP011', 8, 35, '2025-01-23', 'Chembur', 'inbound', 'P009', NULL),
('SHP012', 4, 80, '2025-01-20', 'Sion', 'inbound', 'P010', NULL),
('SHP013', 3, 19, '2025-01-22', 'Powai', 'outbound', NULL, 'S003'),
('SHP014', 2, 5, '2025-01-28', 'Jogeshwari', 'outbound', NULL, 'S004'),
('SHP015', 18, 7, '2025-02-05', 'Bhandup', 'outbound', NULL, 'S005'),
('SHP016', 20, 50, '2025-02-10', 'Mulund', 'inbound', 'P011', NULL),
('SHP017', 10, 56, '2025-02-13', 'Ghatkopar', 'inbound', 'P012', NULL),
('SHP018', 6, 2, '2025-02-20', 'Vikhroli', 'outbound', NULL, 'S006'),
('SHP019', 6, 11, '2025-02-21', 'Kandivali', 'inbound', 'P013', NULL),
('SHP020', 13, 90, '2025-02-21', 'Wadala', 'inbound', 'P014', NULL),
('SHP021', 16, 32, '2025-02-25', 'Matunga', 'inbound', 'P015', NULL),
('SHP022', 11, 25, '2025-02-26', 'Mazgaon', 'outbound', NULL, 'S007'),
('SHP023', 12, 75, '2025-02-26', 'Churchgate', 'inbound', 'P016', NULL),
('SHP024', 15, 55, '2025-03-01', 'Marine Lines', 'inbound', 'P017', NULL),
('SHP025', 17, 27, '2025-03-03', 'Charni Road', 'inbound', 'P018', NULL),
('SHP026', 16, 7, '2025-03-04', 'Grant Road', 'outbound', NULL, 'S008'),
('SHP027', 18, 70, '2025-03-06', 'Byculla', 'inbound', 'P019', NULL),
('SHP028', 8, 7, '2025-03-08', 'Sandhurst Road', 'outbound', NULL, 'S009'),
('SHP029', 5, 30, '2025-03-10', 'Dockyard Road', 'inbound', 'P020', NULL),
('SHP030', 12, 16, '2025-03-29', 'Cotton Green', 'outbound', NULL, 'S010'),
('SHP031', 13, 17, '2025-03-30', 'Reay Road', 'outbound', NULL, 'S011'),
('SHP032', 9, 5, '2025-04-10', 'Sewri', 'outbound', NULL, 'S012'),
('SHP033', 17, 12, '2025-04-14', 'Worli', 'outbound', NULL, 'S013'),
('SHP034', 15, 11, '2025-04-20', 'Prabhadevi', 'outbound', NULL, 'S014'),
('SHP035', 4, 14, '2025-04-22', 'Lower Parel', 'outbound', NULL, 'S015'),
('SHP036', 1, 9, '2025-05-13', 'Parel', 'outbound', NULL, 'S016'),
('SHP037', 14, 20, '2025-05-17', 'Dadar East', 'outbound', NULL, 'S017'),
('SHP038', 10, 14, '2025-05-26', 'Wadala Road', 'outbound', NULL, 'S018'),
('SHP039', 5, 7, '2025-05-30', 'Sion Circle', 'outbound', NULL, 'S019'),
('SHP040', 20, 15, '2025-06-03', 'King’s Circle', 'outbound', NULL, 'S020');

update Shipments set product_id = 7 where shipment_id = 'SHP009';



----------------------------------- SECTION A: INVENTORY MANAGEMENT & OPERATIONS --------------------------------------------

-- 1. What is the average current stock level across all products, and which product has the highest avg stock?

select (select round(avg(current_stock),2) from Inventory) as overall_avg_stock,
    p.product_id,
    p.name,
    i.current_stock as highest_stock
from Products as p join Inventory i on p.product_id = i.product_id
order by i.current_stock desc
limit 1;

-- Tata Salt’s stock level (73) is nearly double the average stock (36.95).
-- This could indicate:Slower movement (not selling as fast as other items).


-- 2. How many products are currently below critical level 10, indicating potential stockouts?

select p.product_id, p.name, i.current_stock
from Products as p join Inventory as i on p.product_id = i.product_id
where i.current_stock < 10
order by i.current_stock asc;

-- Dell Inspiron 15 needs to be restocked as it is running below critical level 10 to avoid customer dissatisfaction


-- 3. What percentage of products belong to each category?

select category, count(*) as product_count,
       round((count(*) * 100.00) /(select count(*) from Products), 2) as percentage
from Products
group by category
order by percentage desc;

-- highest percent of products is from electronics and groceries category which incidate the company is too dependent on this 2 categories


-- 4. Which product category contributes the most to overall inventory value (stock * price)?

select  p.category, sum(i.current_stock * p.price) as total_inventory_value
from Products as p join Inventory as i on p.product_id = i.product_id
group by p.category
order by total_inventory_value desc
limit 1;

-- Electronics category product ties up more capital


-- 5. What is the shelf life (expiry - last updated) for products currently in inventory

select p.product_id, p.name, datediff(i.expiry_date, i.last_updated) as shelf_life_days
from Products as p join Inventory as i on p.product_id = i.product_id
order by shelf_life_days asc;

-- Low shelf life product should be managed as they are perishable items and plan their clearance.


-------------------------------------- SECTION B: PROCUREMENT & SUPPLIER PERFORMANCE --------------------------------------

-- 6.	Which suppliers have delivered the highest volume of products?

select s.supplier_id, s.name as supplier_name, p.name, sum(pu.quantity) as total_quantity_supplied
from Suppliers as s join Purchases as pu on s.supplier_id = pu.supplier_id
					join Products as p on p.product_id = pu.product_id
group by s.supplier_id, s.name, p.name
order by total_quantity_supplied desc;

-- OneMart supplier is the most active supplier supplying bulk quantity is the most reliable vendor.
-- Also if they ship in bulk this will reduce logistic cost.


-- 7.	What is the average lead time (in days) from purchase date to inbound shipment receipt for each supplier?

select s.supplier_id, s.name as supplier_name, 
		round(avg(datediff(sh.shipment_date, pu.purchase_date)),0) as avg_lead_time_days
from Shipments as sh join Purchases as pu on sh.purchase_id = pu.purchase_id
					 join Suppliers as s on pu.supplier_id = s.supplier_id
where sh.shipment_type = 'inbound'
group by s.supplier_id, s.name
order by avg_lead_time_days ;

-- We can identify which suppliers deliver faster and which are consistently slower.


-- 8.	Are there any suppliers who consistently deliver below the ordered quantity?

select s.supplier_id, s.name as supplier_name, pu.purchase_id, pu.product_id, pu.quantity as ordered_quantity, 
     sh.quantity as delivered_quantity, (sh.quantity - pu.quantity) as quantity_difference
from Shipments as sh join Purchases as pu on sh.purchase_id = pu.purchase_id
					 join Suppliers as s ON pu.supplier_id = s.supplier_id
where sh.shipment_type = 'inbound' and  sh.purchase_id is not null
								   and sh.quantity < pu.quantity
order by s.supplier_id, pu.purchase_id;

-- No supplier is short shipping.


-- 9. What is the total purchase value for each supplier, and what percentage of the overall procurement spend does each supplier represent?

select s.supplier_id, s.name as supplier_name, 
	sum(pu.quantity * pu.purchase_price) as total_purchase_value,
    round(sum(pu.quantity * pu.purchase_price) * 100.0 / 
    (select sum(quantity * purchase_price) from Purchases),2) as percentage_of_total
from Suppliers as s join Purchases as pu on s.supplier_id = pu.supplier_id
group by s.supplier_id, s.name
order by total_purchase_value desc;

-- A large percent of business is depended on ElectroWorld Pvt.Ltd.


-- 10. Which suppliers are involved in both high quantity and high value orders?

select s.supplier_id, s.name as supplier_name, sum(pu.quantity) as total_quantity, 
		sum(pu.quantity * pu.purchase_price) as total_value
from Suppliers as s join Purchases as pu on s.supplier_id = pu.supplier_id
group by s.supplier_id, s.name
order by total_value desc;

-- Electroworld Pvt.Ltd is involved with low quantity with high value order 
-- OneMart is involved with high quantity with low value order
-- There is no relation between high quantity and high value order


----------------------------------------- SECTION C: SALES VS INVENTORY DYNAMICS --------------------------------------------

-- 11. Compare the total quantity of products sold vs. quantity purchased. Are we overstocking or understocking?

select p.product_id, p.name as product_name, 
	sum(pu.quantity) as total_purchased, 
	sum(sa.quantity) as total_sold,
	(sum(pu.quantity) - sum(sa.quantity)) as stock_balance
from Products as p left join purchases as pu on p.product_id = pu.product_id
				   left join sales as sa on p.product_id = sa.product_id
group by p.product_id, p.name
order by stock_balance desc;

-- As we can see that the total quantity purchased is consistently greater than total quantity sold, this indicates Overstocking


-- 12.	Which products have been sold more than their current stock, indicating a data inconsistency?

select p.product_id, p.name as product_name, sum(sa.quantity) as total_sold, i.current_stock
from Products as p join Inventory as i on p.product_id = i.product_id
				   left join sales as sa on p.product_id = sa.product_id
group by p.product_id, p.name, i.current_stock
having total_sold > i.current_stock;

-- There is a mismatch for the total sold and current stock for the product_id 11. This suggests rechecking of the datasystem


-- 13.	What are sales-to-inventory ratio for each product category, determine whether we are overstocking?

select p.category, round((sum(s.quantity) / sum(i.current_stock)), 2) as sales_to_inventory_ratio
from Products as p join Inventory as i on p.product_id = i.product_id
				   left join Sales as s on p.product_id = s.product_id
group by p.category
order by sales_to_inventory_ratio desc;

-- As all the ratio < 1 it is a warning sign that we are holding more than we are selling 
-- This also suggest that we are overstocking 


-- 14.	What is the overall revenue generated from sales, and how is it distributed across product categories?

select p.category, round(sum(s.quantity * p.price), 2) as category_revenue, 
		round(sum(s.quantity * p.price) * 100.0 / 
		(select sum(s2.quantity * p2.price)
		from Sales as s2 join Products as p2 on s2.product_id = p2.product_id),
		2) as percentage_of_total_revenue
from Sales as s join Products as p on s.product_id = p.product_id
group by p.category
order by category_revenue desc;

-- Our top product category to generate highest revenue is from Electronics - 1585429.00 which is 90.74 percent.


-- 15. Which products are generating the highest and lowest profit, and how can this help optimize pricing or purchasing strategies?

select p.product_id, p.name as product_name, sum(s.quantity * p.price) as total_revenue,
		sum(s.quantity * pu.purchase_price) as total_cost,
		(sum(s.quantity * p.price)- (sum(s.quantity * pu.purchase_price))) as total_profit
from Products as p left join Sales as s on p.product_id = s.product_id
                   left join Purchases as pu on p.product_id = pu.product_id
group by p.product_id, p.name
order by total_profit desc;

-- iPhone 14 generates the most profit — ensure it's prominently marketed and never out of stock.
-- Dettol Handwash sells well, but yields almost no profit — time to reassess pricing or supplier deals.


-------------------------------------------- SECTION D: SHIPMENT TRENDS --------------------------------------------------

-- 16.	How many inbound vs. outbound shipments occurred month-wise, and what is the trend?

select date_format(shipment_date, '%Y-%m') as shipment_month,
       shipment_type,
    count(*) as shipment_count
from Shipments 
group by date_format(shipment_date, '%Y-%m'), shipment_type
order by shipment_month;

-- February shows more inbound than outbound — risk of overstocked inventory
-- outbound shipments spike at quarter start, suggesting planned restocking.
 -- No outbound shipments in 2024- Dec might point to low demand or late sales reporting.


-- 17. Which Mumbai destinations receive the highest number of outbound shipments?

select destination, count(*) as outbound_shipment_count
from Shipments
where shipment_type = 'outbound'
group by destination
order by outbound_shipment_count desc;

-- The business has a consistent distribution policy — each location is serviced equally, which may ensure fairness or supply reliability


-- 18.	What is the average quantity per shipment by shipment type (inbound vs. outbound)?

select shipment_type, avg(quantity) as avg_quantity_per_shipment
from shipments
group by shipment_type;

-- Inbound avg is 49.45 vs. outbound 12.50 — confirming that we purchase in bulk and distribute in smaller batches.


-- 19.	Identify products that have more outbound than inbound shipments.

select p.product_id, p.name as product_name,
   sum(case when sh.shipment_type = 'inbound' then sh.quantity else 0 end) as total_inbound_qty,
   sum(case when sh.shipment_type = 'outbound' then sh.quantity else 0 end) as total_outbound_qty
from Products as p join Shipments as sh on p.product_id = sh.product_id
group by p.product_id, p.name
having total_outbound_qty > total_inbound_qty
order by (total_outbound_qty - total_inbound_qty) desc;

-- There are no products that have more bound than inbound shipments


-- 20.	What is the shipment fill rate (%) per product and how does it vary across categories? What strategy sould be used for low fill rate?

select p.product_id, p.name as product_name, p.category,
    sum(case when sh.shipment_type = 'inbound' then sh.quantity else 0 end) as total_inbound,
    sum(case when sh.shipment_type = 'outbound' then sh.quantity else 0 end) as total_outbound,
    round((sum(case when sh.shipment_type = 'outbound' then sh.quantity else 0 end) / 
           sum(case when sh.shipment_type = 'inbound' then sh.quantity else 0 end)) * 100, 2) 
           as shipment_fill_rate_pct
from products p
join shipments sh on p.product_id = sh.product_id
group by p.product_id, p.name, p.category
order by shipment_fill_rate_pct desc; 

-- Products with high fill rates are aligned with customer demand; low fill rate products might need discounts, marketing, or stock reduction.


-------------------------------------------- SECTION E: FORECASTING INSIGHTS ------------------------------------------------

-- 21. Analyze monthly purchasing trends — are there any months with significantly high or low purchase activity?
select date_format(purchase_date, '%Y-%m') as purchase_month,
    count(*) as total_purchases,
    sum(quantity) as total_units_purchased
from purchases
group by purchase_month
order by purchase_month;

-- February saw a peak in purchasing — likely to prepare for high March sales.


-- 22. What is the average duration between product purchase and final sale for each product?

select p.product_id, p.name as product_name,
		round(avg(datediff(s.sale_date, pu.purchase_date)), 2) as avg_days_to_sell
from Products as p join Purchases as pu on p.product_id = pu.product_id
				   join Sales as s on p.product_id = s.product_id
where s.sale_date > pu.purchase_date  -- to avoid negative or invalid differences
group by p.product_id, p.name
order by avg_days_to_sell;
 
 -- Addidas Sports Shorts takes short avgerage duration for sales indicating fast turnover- high demand, good inventory management for that product
 -- Dettol Handwash takes long avgerage duration for sales indicating slow turnover- low demand, poor inventory management and poor forecasting for that product


-- 23. Which products exhibit seasonality in their sales or purchase behavior?


select p.product_id, p.name as product_name, date_format(s.sale_date, '%Y-%m') as month,
		sum(s.quantity) as total_units_sold
from Products as p join Sales as s on p.product_id = s.product_id
group by p.product_id, p.name, month
order by month asc, total_units_sold desc; -- sales based Seasonality

-- Product ‘Bournvita’ shows high sales in January, likely due to increased winter consumption.
-- Dettol Handwash spikes in May possibly linked to hygiene awareness


-- 24. Predict which products may go out of stock in the next 30 days based on average daily sales.

select p.product_id, p.name as product_name, i.current_stock,
    round(sum(s.quantity) / count(distinct s.sale_date), 2) as avg_daily_sales,
    round(i.current_stock / (sum(s.quantity) / count(distinct s.sale_date)), 1) as days_until_stockout
from Products as p join Inventory as i on p.product_id = i.product_id
				   join Sales s on p.product_id = s.product_id
group by p.product_id, p.name, i.current_stock
having days_until_stockout <= 30
order by days_until_stockout;

-- HP laser jet printer has less than a day left for stock out suggesting reorder.


-- 25. Based on past purchase and sales data, which products are likely to get out of stock?

select p.category, sum(i.current_stock) as total_stock,
    round(sum(s.quantity) / count(distinct s.sale_date), 2) as avg_daily_sales,
    round(sum(i.current_stock) / (sum(s.quantity) / count(distinct s.sale_date)), 0) as days_until_category_empty
from Products as p join Inventory as i on p.product_id = i.product_id
				   join Sales as s on p.product_id = s.product_id
group by p.category
order by days_until_category_empty;

-- Healthcare category may run out in next 2 days suggesting reorder.


-------------------------------------- SECTION F: ADVANCED ANALYSIS & STRATEGY ----------------------------------------------

-- 26.	Identify slow-moving inventory (not sold in the last 90 days) that may need clearance.
select p.product_id, p.name as product_name, i.current_stock,
       max(s.sale_date) as last_sold_date
from Products as p join Inventory as i on p.product_id = i.product_id
					left join Sales as s on p.product_id = s.product_id
group by p.product_id, p.name, i.current_stock
having last_sold_date < current_date - interval 90 day
order by  current_stock desc;

--  Products with slow moving ( high current_stock) can be put on clearance sales by discounting them.

-- 27. Which products should be discontinued or replaced due to consistently low sales and high holding costs?

select p.product_id, p.name as product_name, sum(s.quantity) as total_units_sold,
    i.current_stock, round(i.current_stock * p.price * 0.0001, 2) as estimated_holding_cost,
    -- holding cost = quantity * price * holding rate(assuming 0.01% rate per day)
    datediff(current_date, max(s.sale_date)) as days_since_last_sale
from Products as p join Inventory as i on p.product_id = i.product_id
					left join Sales as s on p.product_id = s.product_id
group by p.product_id, p.name, i.current_stock
having total_units_sold < 10 and days_since_last_sale > 90
order by estimated_holding_cost desc, days_since_last_sale desc;

--  Low sales volume (only 5 units sold in total)- Indicates weak demand or poor product-market fit.
-- Unsold inventory still exists (10 units)- Ties up space and capital.
-- Holding cost of 75 over 90 days- For a low-turnover product, that’s a relatively high cost.
-- Last sale was 148 days ago- signals slowing movement.
-- Suggests discount and replacement


-- 28. What is the total profit generated from each shipment destination (location), and which locations are most profitable?

select 
    sh.destination,
    sum(s.quantity * p.price) as total_revenue,
    sum(s.quantity * pu.purchase_price) as total_cost,
    round(sum(s.quantity * p.price) - sum(s.quantity * pu.purchase_price), 2) as total_profit
from shipments sh
join sales s on sh.sale_id = s.sale_id
join products p on s.product_id = p.product_id
join purchases pu on s.product_id = pu.product_id
where sh.shipment_type = 'outbound'
group by sh.destination
order by total_profit desc;

-- Parel generates maximum profit - suggesting expand of distribution
-- Reay road generated minimum profit - suggesting targetted promotions, change in shiping Strategy or price adjustment


-- 29. How much capital is tied up in unsold inventory, and which categories contribute most to it?

select p.category, sum(i.current_stock * pu.purchase_price) as capital_tied_up
from Products as p join Inventory as i on p.product_id = i.product_id
				   join Purchases as pu on p.product_id = pu.product_id
group by p.category
order by capital_tied_up desc;
  
-- Electronics is tying up the most capital in unsold stock- Consider reducing reorder frequency or clearing excess with targeted offers.
  
  
-- 30. What is the overall performance of the inventory system in terms of revenue, cost, current profit, units sold, and stock availability across all products?
select round(sum(s.quantity * p.price), 2) as total_revenue,
		round(sum(pu.quantity * pu.purchase_price), 2) as total_cost,
		round(sum(s.quantity * p.price) - sum(s.quantity * pu.purchase_price), 2) as current_profit,
		sum(s.quantity) as total_units_sold,
		sum(i.current_stock) as total_current_stock
from Products as p left join Sales as s on p.product_id = s.product_id
					left join Purchases as pu on p.product_id = pu.product_id
					left join Inventory as i on p.product_id = i.product_id
                    left join shipments sh on p.product_id = sh.product_id;

create view KPI as select round(sum(s.quantity * p.price), 2) as total_revenue,
		round(sum(pu.quantity * pu.purchase_price), 2) as total_cost,
		round(sum(s.quantity * p.price) - sum(s.quantity * pu.purchase_price), 2) as current_profit,
		sum(s.quantity) as total_units_sold,
		sum(i.current_stock) as total_current_stock
from Products as p left join Sales as s on p.product_id = s.product_id
					left join Purchases as pu on p.product_id = pu.product_id
					left join Inventory as i on p.product_id = i.product_id
                    left join shipments sh on p.product_id = sh.product_id;

select * from KPI;




