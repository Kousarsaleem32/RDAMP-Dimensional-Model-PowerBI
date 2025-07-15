copy DimProduct
from 'D:\Realcare Data Analyst Mentorship Program (RDAMP)\TASK2\Dimension_for_Products.csv' 
delimiter ','
csv header;
SELECT * FROM DimProduct

copy DimOrder
from 'D:\Realcare Data Analyst Mentorship Program (RDAMP)\TASK2\DimOrder.csv' 
delimiter ','
csv header;
SELECT * FROM DimOrder