/* Solving the business problem for the charity "Education For All" 

 With the datasets 
Donation_Data = id, first_name, last_name, email, gender, job_field, donation, state, shirt_size
Donor_Data = id, donation_frequency, university, car, second_language, favourite_colour, movie_genre

Using SQL to extract five insights to solve this business problem*/

--Insight 1 : Total number of Donors, donations and average donationDonation_Data

SELECT COUNT(Donation_Data.id) as total_donors,  SUM(Donation_Data.donation) AS total_donations, AVG(Donation_Data.donation) AS average_donation
FROM Donation_Data
JOIN Donor_Data
ON Donation_Data.id = Donor_Data.id;

--Insight 2 : The sum of donations per job_field in descending order

SELECT Donation_Data.job_field, SUM(Donation_Data.donation) as sum_donation
FROM Donation_Data
JOIN Donor_Data
ON Donation_Data.id = Donor_Data.id
GROUP BY Donation_Data.job_field
ORDER BY sum_donation DESC;

--Insight 3 : The count of donations by donation frequency in descending order

SELECT donation_frequency, COUNT(Donation_Data.donation) AS count_donation
FROM Donation_Data
JOIN Donor_Data
ON Donation_Data.id = Donor_Data.id
GROUP BY donation_frequency
order by count_donation DESC;

--Insight 4 : The count of doantions per shirt size in descending orderDonation_Data

SELECT Donation_Data.shirt_size, COUNT(Donation_Data.donation) AS count_donation
FROM Donation_Data
JOIN Donor_Data
ON Donation_Data.id = Donor_Data.id
GROUP BY Donation_Data.shirt_size
ORDER BY count_donation DESC;

--Insight 5 : The count of dontion per state in descending order

SELECT Donation_Data.state, SUM(Donation_Data.donation) AS sum_donation
FROM Donation_Data
JOIN Donor_Data
ON Donation_Data.id = Donor_Data.id
GROUP BY state
ORDER BY sum_donation DESC;





