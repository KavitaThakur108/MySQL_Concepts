-- INNER JOIN
-- Policies with customer names
 Select policy_number,c.first_name,c.last_name from policies p JOIN customers c on p.customer_id=c.customer_id;
-- Policies with customer names 
 Select policy_number,c.first_name,c.last_name from policies p Left JOIN customers c on p.customer_id=c.customer_id;
 
 -- MULTI-JOIN (Multiple Tables at Once)
 -- Claims + policy info + customer info
Select 
cl.claim_number,
    p.policy_number,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    cl.status
FROM claims cl
JOIN policies p ON cl.policy_id = p.policy_id
JOIN customers c ON p.customer_id = c.customer_id

-- JOIN + GROUP BY
-- Number of policies sold by each agent
Select count(policy_id) as -- Total_policies ,a.first_name from policies p join agents a on a.agent_id=p.agent_id  group By a.agent_id ;

-- JOIN +Group By+ HAVING
 -- Customers who have more than 1 policy
Select count(policy_id) as Total,p.customer_id,CONCAT(c.first_name, ' ',c.last_name)as Fullname from policies p join Customers c on c.customer_id=p.customer_id group By p.customer_id having total>1;
 
 -- JOIN + WHERE (Filtering After Joining)
 -- Get all active policies with customer names
 Select policy_number,p.customer_id,c.first_name from policies p  join customers c on p.customer_id=c.customer_id where status='active';
 
 -- Policies having more than one payment
 Select p.policy_id ,p.policy_number ,count(pa.payment_id) from policies p Join payments pa on p.policy_id=pa.policy_id group By pa.policy_id having count(pa.payment_id)>1;
