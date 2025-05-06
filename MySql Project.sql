use zomato;

-- Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets--
select case when price_range=1 then "0-500"
 when price_range=2 then "500-3000"
 when price_range=3 then "3000-10000"
 when price_range=4 then ">10000"
 end price_range,count(RestaurantID)
 from restaurant
 group by price_range
 order by price_range;
 
 
 -- Count of Resturants based on Average Ratings--
 select case WHEN rating <= 2 THEN '0-2'
    WHEN rating > 2 AND rating <= 3 THEN '2-3'
    WHEN rating > 3 AND rating <= 4 THEN '3-4'
    WHEN rating > 4 AND rating <= 5 THEN '4-5'
    ELSE 'Unrated'
 end rating_range,count(RestaurantID)as restaurants
 from restaurant
 group by rating_range
 order by rating_range;
 
 
 
 -- Numbers of Resturants opening based on Year , Quarter , Month --
SELECT 
    YEAR(datekey_opening) AS Opening_Year,
    QUARTER(datekey_opening) AS Opening_Quarter,
    MONTH(datekey_opening) AS Opening_Month,
    COUNT(*) AS Restaurant_Count
FROM calendar_table
WHERE Year  IS NOT NULL
and QUARTER IS NOT NULL
and MonthNo IS NOT NULL
GROUP BY Opening_Year, Opening_Quarter, Opening_Month
ORDER BY Opening_Year, Opening_Quarter, Opening_Month;

 
 
 -- Convert the Average cost for 2 column into USD dollars (currently the Average cost for 2 in local currencies--
SELECT 
    r.RestaurantName,
    r.Average_Cost_for_two,
    r.Currency,
    c.`USD Rate`,
    r.Average_Cost_for_two * c.`USD Rate` AS USD_Cost
FROM 
    restaurant r
JOIN 
    currency c ON r.Currency = c.Currency
WHERE 
    r.Average_Cost_for_two IS NOT NULL;
    



-- no.of restaurants based on city and country--
SELECT 
    c.Countryname,
    r.City,
    COUNT(r.RestaurantID) AS Number_of_Restaurants
FROM 
    restaurant r
JOIN 
    country c ON r.CountryCode = c.CountryID 
GROUP BY 
    c.Countryname, r.City
ORDER BY 
    c.Countryname, r.City;
    



-- Percentage of Resturants based on "Has_Table_booking"--
SELECT 
    r.Has_Table_booking,
    ROUND(COUNT(r.RestaurantID) / (SELECT COUNT(*) FROM restaurant) * 100, 2) AS Percentage
FROM 
    restaurant r
GROUP BY 
    r.Has_Table_booking;


-- Percentage of Resturants based on "Has_Online_delivery"--
SELECT 
    r.Has_Online_delivery,
    ROUND(COUNT(r.RestaurantID) / (SELECT COUNT(*) FROM restaurant) * 100, 2) AS Percentage
FROM 
    restaurant r
GROUP BY 
    r.Has_Online_delivery;


