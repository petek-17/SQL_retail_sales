SELECT * FROM [SQL - Retail Sales Analysis_utf ]

--Data Cleaning
--bo� de�erler olup olmad���na bakmak i�in;
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

--bo� de�erlerimizi silebiliriz.Silme i�lemini yapal�m;
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

--silindi�ini kontrol edelim
SELECT COUNT(*) 
FROM [SQL - Retail Sales Analysis_utf ] 

--Data Exploration
--ka� tane benzersiz m��terimiz var?
SELECT COUNT(DISTINCT customer_id) as total_customer 
FROM [SQL - Retail Sales Analysis_utf ]


--benzersiz katagorilerimiz neler?
SELECT DISTINCT category as category from [SQL - Retail Sales Analysis_utf ]

--Data Analysis & Business Key Problems & answers
--05.11.2022 tarihinde yap�lan sat��lar� getirelim:
SELECT * FROM [SQL - Retail Sales Analysis_utf ]
WHERE sale_date='2022-11-05'



--Kas�m-2022 ay�nda kategorinin 'Clothing' oldu�u ve sat�lan miktar�n 4'ten fazla oldu�u t�m i�lemleri almak i�in bir SQL sorgusu yaz�n 

SELECT *
FROM [SQL - Retail Sales Analysis_utf ]
WHERE category='Clothing'
and FORMAT(sale_date,'yyyy-MM')='2022-11' 
and quantiy>=4



--Her kategori i�in toplam sat��lar� (total_sale) hesaplayan bir SQL sorgusu yaz�n 
SELECT category,SUM(total_sale) total_sale,COUNT(*) total_orders
FROM [SQL - Retail Sales Analysis_utf ]
GROUP BY category



--'Beauty' kategorisinden �r�n sat�n alan m��terilerin ortalama ya��n� bulmak i�in bir SQL sorgusu yaz�n .
SELECT category,AVG(age)
FROM [SQL - Retail Sales Analysis_utf ]
WHERE category='Beauty'
Group By category


--total_sale'in 1000'den b�y�k oldu�u t�m i�lemleri bulmak i�in bir SQL sorgusu yaz�n .
SELECT *
FROM [SQL - Retail Sales Analysis_utf ]
WHERE total_sale>1000

--Her cinsiyetin her kategoride yapt��� toplam i�lem say�s�n� (transaction_id) bulmak i�in bir SQL sorgusu yaz�n .
SELECT gender,category ,COUNT(*)
FROM [SQL - Retail Sales Analysis_utf ]
GROUP BY gender,category

--Her ay�n ortalama sat���n� hesaplamak i�in bir SQL sorgusu yaz�n. Her y�l en �ok satan ay� bulun :
SELECT year_,month_,avg_sale FROM (
        SELECT YEAR(sale_date) as year_,
               MONTH(sale_date) as month_,
               AVG(total_sale) avg_sale,
	           RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) as rank
        FROM [SQL - Retail Sales Analysis_utf ]
        GROUP BY YEAR(sale_date),MONTH(sale_date)
) AS tl
WHERE rank=1


--En y�ksek toplam sat��lara g�re ilk 5 m��teriyi bulmak i�in bir SQL sorgusu yaz�n:
SELECT TOP 5 customer_id,SUM(total_sale) total_sale
FROM [SQL - Retail Sales Analysis_utf ]
GROUP BY customer_id
ORDER BY 2 DESC


--Her kategoriden �r�n sat�n alan benzersiz m��teri say�s�n� bulmak i�in bir SQL sorgusu yaz�n 
SELECT category,COUNT(DISTINCT customer_id) customer
FROM [SQL - Retail Sales Analysis_utf ]
GROUP BY category



--Her vardiyay� ve sipari� say�s�n� olu�turmak i�in bir SQL sorgusu yaz�n (�rnek Sabah <12, ��leden Sonra 12 ile 17 Aras�, Ak�am >17)
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

