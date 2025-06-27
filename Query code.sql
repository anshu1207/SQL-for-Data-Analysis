-- Use the correct database
USE sql_invoicing;

-- 1. Show all invoices (LIMIT 5)
SELECT * FROM invoices LIMIT 5;

-- 2. List all invoices with total > 150
SELECT * FROM invoices
WHERE invoice_total > 150
ORDER BY invoice_total DESC;

-- 3. Top 5 clients by total invoice amount
SELECT c.name AS client_name, SUM(i.invoice_total) AS total_invoiced
FROM clients c
JOIN invoices i ON c.client_id = i.client_id
GROUP BY c.client_id
ORDER BY total_invoiced DESC
LIMIT 5;

-- 4. Number of invoices per client (GROUP BY)
SELECT c.name AS client_name, COUNT(i.invoice_id) AS total_invoices
FROM clients c
JOIN invoices i ON c.client_id = i.client_id
GROUP BY c.client_id;

-- 5. Average invoice total
SELECT AVG(invoice_total) AS average_invoice_total
FROM invoices;

-- 6. Clients who paid more than the average invoice total (SUBQUERY + HAVING)
SELECT c.name, SUM(i.payment_total) AS total_paid
FROM clients c
JOIN invoices i ON c.client_id = i.client_id
GROUP BY c.client_id
HAVING total_paid > (
    SELECT AVG(invoice_total) FROM invoices
);

-- 7. Create a view for monthly invoice revenue
CREATE OR REPLACE VIEW monthly_invoice_revenue AS
SELECT 
  DATE_FORMAT(invoice_date, '%Y-%m') AS month,
  SUM(invoice_total) AS monthly_total
FROM invoices
GROUP BY month;

-- 8. Select from the view to show monthly revenue
SELECT * FROM monthly_invoice_revenue;

-- 9. Join with payment_methods to show payment method for each payment
SELECT p.payment_id, c.name AS client_name, p.amount, pm.name AS method, p.date
FROM payments p
JOIN clients c ON p.client_id = c.client_id
JOIN payment_methods pm ON p.payment_method = pm.payment_method_id;

-- 10. Create an index on client_id to optimize queries
CREATE INDEX idx_client_id ON invoices(client_id);