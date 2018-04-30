USE [chatbot]
GO
/****** Object:  StoredProcedure [dbo].[tfidf]    Script Date: 04/28/2018 08:56:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[tfidf] as
/*
CREATE TABLE MyTable_tfidf_1 (id INT,frq INT, txt VARCHAR(50));

drop TABLE MyTable
CREATE TABLE MyTable (id INT, txt VARCHAR(MAX));

insert into MyTable SELECT 1 AS Id, N'' AS txt 
http://bilgisayarkavramlari.sadievrenseker.com/2012/10/22/tf-idf/
id	txt
1	Bu yazının amacı, metin madenciliği (text mining) olarak da geçen ve doğal dil işleme (natural language processing) ve veri madenciliği (data mining) konularının ortak çalışma alanı olan metinler üzerinde istatistiksel incelemeler konusunda kullanılan TFIDF kavramını açılamaktır.  TF-IDF kavramı IR (information retrieval, bilgi getirimi) gibi konuların altında bir sıralama (ranking) algoritması olarak sıkça geçmektedir.
2	İngilizcedeki Term Frequency – Inverse Document Frequency (Terim frekansı – ters metin frekansı) olarak geçen kelimelerin baş harflerinden oluşan terim basitçe bir metinde geçen terimlerin çıkarılması ve bu terimlerin geçtiği miktara göre çeşitli hesapların yapılması üzerine kuruludur.
3	Klasik olarak TF yani terimlerin kaç kere geçtiğinden daha iyi sonuç verir. Kısaca TF-IDF hesabı sırasında iki kritik sayı bulunmaktadır. Bunlardan birincisi o anda ele alınan dokümandaki terimin sayısı diğeri ise bu terimi külliyatta içeren toplam doküman sayısıdır.
4	Örneğin 100 dokümandan oluşan bir külliyatımız olsun ve TF-IDF hesaplamak istediğimiz kelime de “şadi” olsun. Bu durumda birinci dokümana bakıp “şadi” kelimesinin kaç kere geçtiğini sayarız. Diyeli ki 4 kere geçiyor olsun. Ardından külliyatımızdaki 100 dokümandan kaçında “şadi” kelimesi geçiyor diye bakarız. Diyelim ki 10 dokümanda bu kelime geçiyor olsun (dikkat edilecek husu kelimenin geçip geçmediğidir diğer dokümanlarda kaç kere geçtiğinin bir önemi yoktur).
5	Şimdi TF ve IDF değerlerini ayrı ayrı hesaplayacağız ve sonra bu iki değeri çarpacağız, önce TF hesabına bakalım:
6	TF hesabı için ihtiyacımız olan bir diğer değer ise o andaki dokümanda en fazla geçen terim sayısıdır. Örneğin o anda baktığımız dokümanda en fazla geçen terimimizin sayısı da 80 olsun.
7	İlk hesaplama dokümanda bizim ilgilendiğimiz kelimenin en fazla geçen kelimeye oranıdır. Yani kelimemiz 4 kere geçtiğine ve en fazla geçen kelimemiz de 80 kere geçtiğine göre ilk oranımız (ki bu oran aynı zamanda TF (term frequency, terim frekansı) olarak tek başına da anlamlıdır)
8	IDF hesabı sırasında bir iki noktaya dikkat etmek gerekir. Öncelikle logaritmanın tabanının bir önemi yoktur. Amaç üssel fonksiyonun tersi yönde bir hesap yapmaktır. Doğal logaritma kökü e, 2 veya 10 gibi sayılar en çok kullanılan değerlerdir. Genelde TF-IDF değerinin kıyas için kullanıldığını ve diğer terimlerin TFIDF değerleri ile kıyaslandığını düşünecek olursak hepsinde aynı tabanın kullanılıyor olması sonucu değiştirmeyecektir.
9	Diğer dikkat edilecek bir husus ise IDF hesabı sırasında geçen “terimi içeren doküman sayısı” değeridir. Bu değer hesaplama sırasında paydada yer almaktadır ve bu değerin 0 (sıfır) olma ihtimali vardır. Bu durumda sonuç sıfıra bölüm belirsizliğine götürebileceğinden genelde bu değere 1 eklemek sıkça yapılan bir programlama yaklaşımıdır.
10	Son olarak TF-IDF yönteminin diğer yöntemlere göre farkını açıklamaya çalışalım. TF-IDF ile bir terimin kaç kere geçtiği kadar kaç farklı dokümanda da geçtiği önem kazanır. Örneğin sadece bir dokümanda 100 kere geçen bir terimle 10 farklı dokümanda onar kere geçen terimin ikisi de aslında toplamda 100 kere geçmiştir ancak TF-IDF ikincisine yani daha fazla dokümanda geçene önem veriri.

select *    from MyTable 


CREATE TABLE [dbo].[MyTable_tfidf_totCnt](
	[id] [int] NULL,
	[tot_cnt] float NULL,
	[mx_frq] float NULL
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [ix_MyTable_tfidf_totCnt] ON [dbo].[MyTable_tfidf_totCnt] 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
-------------
CREATE TABLE [dbo].[MyTable_tfidf_KFD](
	[txt] [varchar](50) NULL,
	[kac_farkli_dokumanda] float NULL
) ON [PRIMARY]
GO

CREATE UNIQUE NONCLUSTERED INDEX [ix_MyTable_tfidf_KFD] ON [dbo].[MyTable_tfidf_KFD] 
(
	[txt] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
--------------------------------------------------


CREATE TABLE [dbo].[MyTable_tfidf_TmpTbl](
	[id] [int] NULL,
	[frq] float NULL,
	[txt] [varchar](50) NULL,
	[kac_farkli_dokumanda] float NULL,
	[mx_frq] float NULL,
	[tot_cnt] float NULL
) ON [PRIMARY]

GO

CREATE  NONCLUSTERED INDEX [ix_MyTable_tfidf_TmpTbl_1] ON [dbo].[MyTable_tfidf_TmpTbl] 
(
	[txt] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

CREATE  NONCLUSTERED INDEX [ix_MyTable_tfidf_TmpTbl_2] ON [dbo].[MyTable_tfidf_TmpTbl] 
(
	id  ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
------------------------------------------------------
 */
 
 select * from  dbo.SeparateValues('1 1 2 2 3  4 56  6', ' ') 
 truncate table MyTable_tfidf_1;
 declare @id int
 declare @txt varchar(max)
 	DECLARE CRS_olumlu CURSOR FOR 
					
					--select id,txt from MyTable
					SELECT [eid] ,description   FROM [sozluk].[dbo].Szlk_Tbl_Entrysdbo
					OPEN CRS_olumlu
					FETCH NEXT FROM CRS_olumlu INTO @id , @txt
					WHILE @@FETCH_STATUS =0
					BEGIN
		
		-- declare @txt varchar(max)='1 12 2 22 2 3 3 3 3 4'				
		  insert into MyTable_tfidf_1
		   Select @id, Count(*), sep.Col FROM (
        Select * FROM (
            Select value = Upper(RTrim(LTrim(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(Replace(@txt, ',', ' '), '.', ' '), '"', ' '), '!', ' '), '+', ' '), ':', ' '), '-', ' '), ';', ' '), '(', ' '), ')', ' '), '/', ' '), '&', ''), '?', ' '), '  ', ' '), '  ', ' ')))) --FROM Responses
        ) easyValues
        Where value <> '' 
    ) actualValues 
    Cross Apply dbo.SeparateValues(value, ' ') sep
    Group By sep.Col
    Order By Count(*) Desc   

					FETCH NEXT FROM CRS_olumlu INTO @id , @txt
					END
					CLOSE CRS_olumlu
					DEALLOCATE CRS_olumlu;


 
 truncate table MyTable_tfidf_totCnt;
 
 insert into  MyTable_tfidf_totCnt
select id, count( txt)tot_cnt,  max( frq)mx_frq
 from MyTable_tfidf_1
 group by id;

 truncate table MyTable_tfidf_KFD;
 insert into  MyTable_tfidf_KFD 
select txt,  count(distinct  id) kac_farkli_dokumanda
from MyTable_tfidf_1
 group by txt;
 
 truncate table MyTable_tfidf_TmpTbl;
 insert into MyTable_tfidf_TmpTbl
  select  x.id,x.frq,x.txt ,  kac_farkli_dokumanda,   mx_frq,  tot_cnt
 -- select *
 from MyTable_tfidf_1 x left join MyTable_tfidf_KFD y on x.txt=y.txt
  left join MyTable_tfidf_totCnt z on x.id=z.id  --and  x.txt=z.txt
 
  
  --select * from MyTable_tfidf_2
   declare @kulliyat float;
  select --@kulliyat=
  count(distinct id)  from MyTable_tfidf_totCnt;
  
  
  
 truncate table MyTable_tfidf_fnl;
  insert into MyTable_tfidf_fnl
 select * ,  (frq/mx_frq) tf  ,(frq/tot_cnt) tf2,  log10 ( @kulliyat / kac_farkli_dokumanda) idf
 ,(frq/mx_frq ) * log10 ( @kulliyat / kac_farkli_dokumanda  ) tfidf  
 ,(frq/tot_cnt) * log10 ( @kulliyat /kac_farkli_dokumanda  ) tfidf2 
  from MyTable_tfidf_TmpTbl
 
 select txt, count(*) from (
select * from MyTable_tfidf_fnl x
where x.tfidf>=(select avg(tfidf) from MyTable_tfidf_fnl y where x.id=y.id)
--order by tfidf 
)x group by txt
order by 2 desc
