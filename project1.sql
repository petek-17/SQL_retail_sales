SELECT * FROM [SQL - Retail Sales Analysis_utf ]

--Data Cleaning
--bos degerler olup olmadigına bakmak icin;
SELECT *
FROM [SQL - Retail Sales Analysis_utf ]
WHERE transactions_id IS NULL 
      OR
	  sale_date IS NULL
	  OR
	  sale_time IS NULL
	  OR
	  customer_id IS NULL
	  OR
	  gender IS NULL
	  OR
	  category IS NULL
	  OR
	  quantiy IS NULL
	  OR
	  cogs IS NULL
	  OR
	  total_sale IS NULL

--bos degerlerimizi silebiliriz.Silme islemini yapalim;
DELETE FROM [SQL - Retail Sales Analysis_utf ]
WHERE transactions_id IS NULL 
      OR
	  sale_date IS NULL
	  OR
	  sale_time IS NULL
	  OR
	  customer_id IS NULL
	  OR
	  gender IS NULL
	  OR
	  category IS NULL
	  OR
	  quantiy IS NULL
	  OR
	  cogs IS NULL
	  OR
	  total_sale IS NULL

--silindigini kontrol edelim
SELECT COUNT(*) 
FROM [SQL - Retail Sales Analysis_utf ] 

--Data Exploration
--kaç tane benzersiz müsterimiz var?
SELECT COUNT(DISTINCT customer_id) as total_customer 
FROM [SQL - Retail Sales Analysis_utf ]


--benzersiz katagorilerimiz neler?
SELECT DISTINCT category as category from [SQL - Retail Sales Analysis_utf ]

--Data Analysis & Business Key Problems & answers
--05.11.2022 tarihinde yapýlan satýþlarý getirelim:
SELECT * FROM [SQL - Retail Sales Analysis_utf ]
WHERE sale_date='2022-11-05'



--Kasým-2022 ayýnda kategorinin 'Clothing' oldugu ve satilan miktarın 4'ten fazla oldugu tüm islemleri almak için bir SQL sorgusu yazalim

SELECT *
FROM [SQL - Retail Sales Analysis_utf ]
WHERE category='Clothing'
and FORMAT(sale_date,'yyyy-MM')='2022-11' 
and quantiy>=4



--Her kategori için toplam satislari (total_sale) hesaplayan bir SQL sorgusu yazalim:
SELECT category,SUM(total_sale) total_sale,COUNT(*) total_orders
FROM [SQL - Retail Sales Analysis_utf ]
GROUP BY category



--'Beauty' kategorisinden ürün satın alan müsterilerin ortalama yasini bulmak için bir SQL sorgusu yazalim:
SELECT category,AVG(age)
FROM [SQL - Retail Sales Analysis_utf ]
WHERE category='Beauty'
Group By category


--total_sale 1000'den büyük oldugu tüm islemleri bulmak için bir SQL sorgusu yazalim.
SELECT *
FROM [SQL - Retail Sales Analysis_utf ]
WHERE total_sale>1000

--Her cinsiyetin her kategoride yaptıgı toplam islem sayisini (transaction_id) bulmak için bir SQL sorgusu yazalim
SELECT gender,category ,COUNT(*)
FROM [SQL - Retail Sales Analysis_utf ]
GROUP BY gender,category

--Her ayın ortalama satisini hesaplamak için bir SQL sorgusu yazalim. Her yil en çok satan ay bulalım :
SELECT year_,month_,avg_sale FROM (
        SELECT YEAR(sale_date) as year_,
               MONTH(sale_date) as month_,
               AVG(total_sale) avg_sale,
	           RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) as rank
        FROM [SQL - Retail Sales Analysis_utf ]
        GROUP BY YEAR(sale_date),MONTH(sale_date)
) AS tl
WHERE rank=1


--En yüksek toplam satislara göre ilk 5 müsteriyi bulmak için bir SQL sorgusu yazalim:
SELECT TOP 5 customer_id,SUM(total_sale) total_sale
FROM [SQL - Retail Sales Analysis_utf ]
GROUP BY customer_id
ORDER BY 2 DESC


--Her kategoriden ürün satin alan benzersiz müsteri sayisini bulmak için bir SQL sorgusu yazalim.
SELECT category,COUNT(DISTINCT customer_id) customer
FROM [SQL - Retail Sales Analysis_utf ]
GROUP BY category



--Her vardiyayi ve siparis sayisini olusturmak için bir SQL sorgusu yazalim (Örnek Sabah <12, Ogleden Sonra 12 ile 17 Arasi, Aksam >17)
;WITH hourly_sale AS (
SELECT *,
CASE
    WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
	WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE 'Evening'
END as shiftt
FROM [SQL - Retail Sales Analysis_utf ]
) 
SELECT shiftt,COUNT(*) total_orders 
FROM hourly_sale
GROUP BY shiftt

