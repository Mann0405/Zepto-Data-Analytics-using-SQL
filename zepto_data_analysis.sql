drop table if exists zepto;

create table zepto(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGrams INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

SELECT * FROM zepto;

-- data exploration
-- checking for null values

select * from zepto
where name is null
or category is null
or mrp is null
or discountPercent is null
or availableQuantity is null
or discountedSellingPrice is null
or weightInGrams is null
or outOfStock is null
or quantity is null;

-- different categories

select distinct category 
from zepto
order by category;

-- products in stock vs out of stock

select outOfStock, count(*)
from zepto
group by outOfStock;

-- distinct product names 

select name, count(*)
from zepto
group by name
having count(*)>1
order by 2 desc;

--data cleaning

select * from zepto 
where mrp = 0
or discountedSellingPrice = 0;

delete from zepto 
where mrp = 0;

-- convert paise to rupees

UPDATE zepto 
set mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

select mrp, discountedSellingPrice from zepto;

-- Q1. Find the top 10 best-value products based on discount percentage?

select distinct name, mrp, discountPercent from zepto
order by discountPercent desc
limit 10;

-- Q2. What are the products with high MRP but out of stock?

select distinct name, mrp from zepto
where outOfStock is true and mrp>250
order by mrp desc;

-- Q3. Calculate estimated revenue for each category.

select category, sum(discountedSellingPrice * availableQuantity) as total_revenue 
from zepto
group by category
order by 2 desc;

-- Q4. Find all products where MRP is greater than 500 and discount is less than 10%.

select name, mrp, discountpercent
from zepto 
where mrp>500 
and discountPercent<10;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.

select category, round(avg(discountPercent),2) as avg_disc
from zepto 
group by category
order by 2 desc
limit 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.

select distinct name, weightInGrams, discountedSellingPrice, round(discountedSellingPrice/weightInGrams,2) as price_per_gram 
from zepto
where weightInGrams >= 100
order by 4;

-- Q7. Group the products into weight categories like low, medium, bulk.
select name, weightInGrams, 
case when weightInGrams < 1000 then 'low'
	 when weightInGrams < 5000 then 'medium'
	 else 'bulk'
	 end as weightCategory
from zepto;

-- Q8. What is the total inventory weight per category?

select category, sum(weightInGrams * availableQuantity) as total_weight_in_grams
from zepto
group by category;
