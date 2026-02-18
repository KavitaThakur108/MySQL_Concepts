--View firstname,lastname,city and email of customers
 Select first_name, last_name,city,email from customers;
--Agents that are active 
 Select * from agents where active=1;
--Print all types of policies
 Select * from policy_types;
--Payments done through UPI
 Select * from payments where method="UPI";
--Policies with customer names
 Select policy_id,customers.customer_id,customers.first_name from policies,customers where policies.customer_id=customers.customer_id ;
--Policies with agent names
 Select policy_id , a.agent_id from policies p,agents a where p.agent_id=a.agent_id;
-- Claims with policy & customer
 Select c.claim_id,c.policy_id,p.customer_id,cu.first_name from claims c,policies p,customers cu where c.policy_id=p.policy_id and p.customer_id=cu.customer_id;
-- Total premium paid per policy
 Select policy_id,sum(premium_amount) from policies group by policy_id;
-- Policies sold by each agent
 Select  a.agent_id,a.first_name,count(p.policy_id) from agents a,policies p where a.agent_id=p.agent_id group By a.agent_id;
-- Customers with multiple policies
 Select Count(*),p.customer_id from policies p group By p.customer_id having count(*)>1 ;
-- Latest payment per policy
 Select max(payment_date), policy_id from payments group by policy_id  ;
--Expired policies
 Select policy_id,end_date from policies where end_date< Curdate();
--Policies expiring in next 90 days
 Select policy_id,end_date from policies where end_date>Curdate() and (curdate()+90)>end_date;
--OR another method using Between
 SELECT * FROM policies WHERE end_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 90 DAY);
--Claim counts by status
 Select count(*),status from claims group BY status;

