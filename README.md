# SQL_retail_sales
Proje Adı : Perakende Satış Analizi
Veri Temizleme : Eksik veya boş değerlere sahip kayıtları belirlemek ve kaldırmak.
Keşifsel Veri Analizi (EDA) : Veri setini anlamak için temel keşifsel veri analizi gerçekleştirmek.
İş Analizi : Belirli iş sorularını yanıtlamak ve satış verilerinden içgörüler elde etmek için SQL kullanmak.




1.boş değerler olup olmadığına bakmak için;
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

2.boş değerlerimizi silebiliriz.Silme işlemini yapalım;
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

3.silindiğini kontrol edelim
SELECT COUNT(*) 
FROM [SQL - Retail Sales Analysis_utf ] 


4.kaç tane benzersiz müşterimiz var?
SELECT COUNT(DISTINCT customer_id) as total_customer 
FROM [SQL - Retail Sales Analysis_utf ]


5.benzersiz katagorilerimiz neler?
SELECT DISTINCT category as category from [SQL - Retail Sales Analysis_utf ]


6.05.11.2022 tarihinde yapılan satışları getirelim:
SELECT * FROM [SQL - Retail Sales Analysis_utf ]
WHERE sale_date='2022-11-05'



7.Kasım-2022 ayında kategorinin 'Clothing' olduğu ve satılan miktarın 4'ten fazla olduğu tüm işlemleri almak için bir SQL sorgusu yazın 

SELECT *
FROM [SQL - Retail Sales Analysis_utf ]
WHERE category='Clothing'
and FORMAT(sale_date,'yyyy-MM')='2022-11' 
and quantiy>=4



8.Her kategori için toplam satışları (total_sale) hesaplayan bir SQL sorgusu yazın 
SELECT category,SUM(total_sale) total_sale,COUNT(*) total_orders
FROM [SQL - Retail Sales Analysis_utf ]
GROUP BY category



9.'Beauty' kategorisinden ürün satın alan müşterilerin ortalama yaşını bulmak için bir SQL sorgusu yazın .
SELECT category,AVG(age)
FROM [SQL - Retail Sales Analysis_utf ]
WHERE category='Beauty'
Group By category


10.total_sale'in 1000'den büyük olduğu tüm işlemleri bulmak için bir SQL sorgusu yazın .
SELECT *
FROM [SQL - Retail Sales Analysis_utf ]
WHERE total_sale>1000

11.Her cinsiyetin her kategoride yaptığı toplam işlem sayısını (transaction_id) bulmak için bir SQL sorgusu yazın .
SELECT gender,category ,COUNT(*)
FROM [SQL - Retail Sales Analysis_utf ]
GROUP BY gender,category

12.Her ayın ortalama satışını hesaplamak için bir SQL sorgusu yazın. Her yıl en çok satan ayı bulun :
SELECT year_,month_,avg_sale FROM (
        SELECT YEAR(sale_date) as year_,
               MONTH(sale_date) as month_,
               AVG(total_sale) avg_sale,
	           RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) as rank
        FROM [SQL - Retail Sales Analysis_utf ]
        GROUP BY YEAR(sale_date),MONTH(sale_date)
) AS tl
WHERE rank=1


13.En yüksek toplam satışlara göre ilk 5 müşteriyi bulmak için bir SQL sorgusu yazın:
SELECT TOP 5 customer_id,SUM(total_sale) total_sale
FROM [SQL - Retail Sales Analysis_utf ]
GROUP BY customer_id
ORDER BY 2 DESC


14.Her kategoriden ürün satın alan benzersiz müşteri sayısını bulmak için bir SQL sorgusu yazın 
SELECT category,COUNT(DISTINCT customer_id) customer
FROM [SQL - Retail Sales Analysis_utf ]
GROUP BY category



15.Her vardiyayı ve sipariş sayısını oluşturmak için bir SQL sorgusu yazın (Örnek Sabah <12, Öğleden Sonra 12 ile 17 Arası, Akşam >17)
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
