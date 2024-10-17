# 1.Create a database called credit_card_classification.
drop database if exists credit_card_classification;
create database credit_card_classification;


#2. Create a table credit_card_data with the same columns as given in the csv file. Please make sure you use the correct data types for each of the columns.

drop table if exists credit_card_data;
CREATE TABLE credit_card_data (
  `Customer_Number` bigint NOT NULL,
  `Offer_Accepted` VARCHAR(10) DEFAULT NULL,
  `Reward` VARCHAR(10) DEFAULT NULL,
  `Mailer_Type` VARCHAR(10) DEFAULT NULL,
  `Income_Level` VARCHAR(10) DEFAULT NULL,
  `Bank_Accounts_Open` int(4) DEFAULT NULL,
  `Overdraft_Protection` VARCHAR(10) DEFAULT NULL,
  `Credit_Rating` VARCHAR(10) DEFAULT NULL,
  `Credit_Cards_Held` int(4) DEFAULT NULL,
  `Homes_Owned` int(4) DEFAULT NULL,
  `Household_Size` int(4) DEFAULT NULL,
  `Own_Your_Home` VARCHAR(10) DEFAULT NULL,
  `Average_Balance` float DEFAULT NULL,
  `Q1_Balance` int(11)  DEFAULT NULL,
  `Q2_Balance` int(11)  DEFAULT NULL,
  `Q3_Balance` int(11) DEFAULT NULL,
  `Q4_Balance` int(11) DEFAULT NULL,
  PRIMARY KEY (`Customer_Number`)
);


#3. Import the data from the csv file into the table. Before you import the data into the empty table, make sure that you have deleted the headers from the csv file.
#To not modify the original data, if you want you can create a copy of the csv file as well. 
# Note you might have to use the following queries to give permission to SQL to import data from csv files in bulk:

SHOW VARIABLES LIKE 'local_infile'; -- This query would show you the status of the variable ‘local_infile’. If it is off, use the next command, otherwise you should be good to go
SET GLOBAL local_infile = 1;

#4. Select all the data from table credit_card_data to check if the data was imported correctly.
select * from credit_card_data

#5. Use the alter table command to drop the column q4_balance from the database, as we would not use it in the analysis with SQL. Select all the data from the table to verify if the command worked. Limit your returned results to 10.
alter table credit_card_data
drop column `Q4_Balance`;

select * from credit_card_data

#6. Use sql query to find how many rows of data you have.
select count(Customer_Number) as "Customer Number" from credit_card_data


#7. Now we will try to find the unique values in some of the categorical columns:

What are the unique values in the column Offer_accepted?
select distinct(Offer_accepted) from credit_card_data
order by Offer_accepted asc


What are the unique values in the column Reward?
select distinct(Reward) from credit_card_data
order by Reward asc

What are the unique values in the column mailer_type?
select distinct(Mailer_Type) from credit_card_data
order by Mailer_Type asc

What are the unique values in the column credit_cards_held?
select distinct(`Credit_Cards_Held`) from credit_card_data
order by `Credit_Cards_Held` asc

What are the unique values in the column household_size?
select distinct(Household_Size) from credit_card_data
order by Household_Size asc

#8. Arrange the data in a decreasing order by the average_balance of the customer. Return only the customer_number of the top 10 customers with the highest average_balances in your data.
select Customer_Number, Average_Balance from credit_card_data
order by Average_Balance desc
limit 10;

#9. What is the average balance of all the customers in your data?
select avg(Average_Balance) as Average_Balance from credit_card_data

#10. In this exercise we will use simple group_by to check the properties of some of the categorical variables in our data. Note wherever average_balance is asked, please take the average of the column average_balance:

#What is the average balance of the customers grouped by Income Level? The returned result should have only two columns, income level and Average balance of the customers. Use an alias to change the name of the second column.
select Income_Level, avg(Average_Balance) as Average_Balance from credit_card_data
group by Income_Level
order by avg(Average_Balance)  asc

#What is the average balance of the customers grouped by number_of_bank_accounts_open? The returned result should have only two columns, number_of_bank_accounts_open and Average balance of the customers. Use an alias to change the name of the second column.
select Bank_Accounts_Open, avg(Average_Balance) as Average_Balance from credit_card_data
group by Bank_Accounts_Open
order by Bank_Accounts_Open asc

#What is the average number of credit cards held by customers for each of the credit card ratings? The returned result should have only two columns, rating and average number of credit cards held. Use an alias to change the name of the second column.
select Credit_Rating, avg (`Credit_Cards_Held`) as Average_Nb_of_Creditcards from credit_card_data
group by Credit_Rating

#Is there any correlation between the columns credit_cards_held and number_of_bank_accounts_open? You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. Visually check if there is a positive correlation or negative correlation or no correlation between the variables.
select  Bank_Accounts_Open ,  avg (`Credit_Cards_Held`) as Average_Nb_of_Creditcards  from credit_card_data
group by `Bank_Accounts_Open`
order by `Bank_Accounts_Open` asc   

#There is no correlation between these two variables.                              

#11. Your managers are only interested in the customers with the following properties:

Credit rating medium or high
Credit cards held 2 or less
Owns their own home
Household size 3 or more
For the rest of the things, they are not too concerned. Write a simple query to find what are the options available for them? Can you filter the customers who accepted the offers here?


select * from credit_card_data
Where Credit_Cards_Held <3 
and (Credit_Rating = 'medium' or Credit_Rating = 'high')
and Own_Your_Home= 'yes'
and Household_Size > 3


select * from credit_card_data
Where Credit_Cards_Held <3 
and (Credit_Rating = 'medium' or Credit_Rating = 'high')
and Own_Your_Home= 'yes'
and Household_Size > 3
and Offer_Accepted = 'yes'

#12. Your managers want to find out the list of customers whose average balance is less than the average balance of all the customers in the database. Write a query to show them the list of such customers. You might need to use a subquery for this problem.
select * from credit_card_data
Where Average_Balance < (select avg (Average_Balance) from credit_card_data)

#13.Since this is something that the senior management is regularly interested in, create a view of the same query.
create view below_average_balance as
select * from credit_card_data
where Average_Balance < (select avg(Average_Balance) from credit_card_data);

#14.What is the number of people who accepted the offer vs number of people who did not?
SELECT Offer_Accepted, count(Customer_Number) AS count
from credit_card_data
group by Offer_Accepted;

#15.Your managers are more interested in customers with a credit rating of high or medium. What is the difference in average balances of the customers with high credit card rating and low credit card rating?
Select (SELECT  avg(Average_Balance)from credit_card_data where Credit_Rating = 'high')
-(SELECT  avg(Average_Balance)from credit_card_data where Credit_Rating = 'medium')
as Difference_btw_High_vs_Medium_Ratings

#16. In the database, which all types of communication (mailer_type) were used and with how many customers?
Select  Mailer_Type, count(Customer_Number)as Customer_amount   from credit_card_data 
group by Mailer_Type

#17.Provide the details of the customer that is the 11th least Q1_balance in your database.

Select * from (Select * from credit_card_data
				order by Q1_balance asc)D
LIMIT 1 offset 10
