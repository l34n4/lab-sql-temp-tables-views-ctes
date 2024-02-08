/*Step 1: Create a View
#First, create a view that summarizes rental information for each customer.
#The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
 rental for customer */
 
#where can i find info ? 
# customer : id,  name ( first name last name) , email address
# rental :  total number of rental count number of rental id groupby customer ?
USE sakila;
CREATE VIEW customer_rental_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email AS email_address,
    COUNT(r.rental_id) AS rental_count
FROM 
    customer c
LEFT JOIN 
    rental r ON c.customer_id = r.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name, c.email;

#looking if it work 

SELECT * 
FROM customer_rental_summary;

/*- Step 2: Create a Temporary Table

Next, create a Temporary Table 
that calculates the total amount paid by each customer (total_paid). 
The Temporary Table should use the rental summary view created in Step 1 to join with the payment table 
and calculate the total amount paid by each customer.*/
# payment amount  group by customer id   join the wiew

CREATE TEMPORARY TABLE temp_customer_payment_summary2 AS
SELECT crs.customer_id, SUM(p.amount) AS total_paid, crs.customer_name
FROM 
    customer_rental_summary crs
JOIN 
    payment p ON crs.customer_id = p.customer_id
GROUP BY 
    crs.customer_id;


SELECT* 
FROM temp_customer_payment_summary2 ;

/*Step 3: Create a CTE and the Customer Summary Report

Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
The CTE should include the customer's name, email address, rental count, and total amount paid. */


#join wiew /temporary 


WITH customersum AS (
    SELECT 
        crs.customer_id,
        crs.customer_name,
        crs.email_address,
        crs.rental_count,
        cps.total_paid
    FROM 
        customer_rental_summary crs
    JOIN 
        temp_customer_payment_summary2 cps 
	ON crs.customer_id = cps.customer_id)
/*Next, using the CTE, create the query to generate the final customer summary report,
 which should include: customer name, email, rental_count, total_paid and
 average_payment_per_rental, this last column is a derived column 
 from total_paid and rental_count.
*/

SELECT customer_name, email_address, rental_count, total_paid, total_paid/rental_count as average_payment_per_rental
FROM customersum;










