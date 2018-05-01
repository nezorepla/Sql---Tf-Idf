alter proc tfidf_report as

truncate table MyTable_rpr_allWords; 
 insert into MyTable_rpr_allWords
select *  from (
select ROW_NUMBER() OVER(partition by tip ORDER BY adet DESC) AS SIRA , * from (
 select   cast('hepsi' as varchar(50)) Tip,
  word_form, convert(float,count(*)) adet , convert(float,sum(frequency)) frequency 
 from (
select y.*,tfidf
 from MyTable_tfidf_fnl x 
left join dbo.tbl_word_forms_stems_and_frequencies y on x.txt =upper(y.word_form)
where x.tfidf>(select avg(tfidf) from MyTable_tfidf_fnl y where x.id=y.id)
--and morphological_analysis like'%Abl%'
) x  group by word_form
) y
) z where SIRA <=10 
order by 1  ;


 insert into MyTable_rpr_allWords
select *  from (
select ROW_NUMBER() OVER(partition by tip ORDER BY adet DESC) AS SIRA , * from (
 select  case replace( left(morphological_analysis,(charindex('+',morphological_analysis))),'+','') 
 when 'Adj' then 'sýfat' 
 when 'Postp' then 'edat' 
 when 'Adv' then 'zarf' 
 when 'Noun' then 'isim'
 when 'Pron' then 'zamir' 
 when 'Conj' then 'baðlaç' 
 when 'Verb' then 'fiil' 
 else 'x' end 
 Tip,
  word_form, convert(float,count(*)) adet , convert(float,sum(frequency)) frequency 
 from (
select y.*,tfidf
 from MyTable_tfidf_fnl x 
left join dbo.tbl_word_forms_stems_and_frequencies y on x.txt =upper(y.word_form)
where x.tfidf>(select avg(tfidf) from MyTable_tfidf_fnl y where x.id=y.id)
--and morphological_analysis like'%Abl%'
) x  group by word_form,  case replace( left(morphological_analysis,(charindex('+',morphological_analysis))),'+','') 
 when 'Adj' then 'sýfat' 
 when 'Postp' then 'edat' 
 when 'Adv' then 'zarf' 
 when 'Noun' then 'isim'
 when 'Pron' then 'zamir' 
 when 'Conj' then 'baðlaç' 
 when 'Verb' then 'fiil' 
 else 'x' end 
) y
) z where SIRA <=10 
order by 1   

truncate table MyTable_rpr_topList;

insert into MyTable_rpr_topList
select  h.SIRA, hepsi,fiil,sýfat,zamir,edat,zarf,baðlaç,isim,x
 from(
select SIRA, word_form  'hepsi' from MyTable_rpr_allWords
where tip= 'hepsi'
) h left join (
select SIRA, word_form 'fiil' from MyTable_rpr_allWords
where tip= 'fiil'
) f  on h.SIRA=f.SIRA  left join (
select SIRA, word_form 'sýfat' from MyTable_rpr_allWords
where tip= 'sýfat'
) s  on h.SIRA=s.SIRA  left join (
select SIRA, word_form 'zamir' from MyTable_rpr_allWords
where tip= 'zamir'
) z  on h.SIRA=z.SIRA left join (
select SIRA, word_form 'edat' from MyTable_rpr_allWords
where tip= 'edat'
) e  on h.SIRA=e.SIRA left join (
select SIRA, word_form 'zarf' from MyTable_rpr_allWords
where tip= 'zarf'
) z2  on h.SIRA=z2.SIRA left join (
select SIRA, word_form 'baðlaç' from MyTable_rpr_allWords
where tip= 'baðlaç'
) b  on h.SIRA=b.SIRA left join (
select SIRA, word_form  'isim' from MyTable_rpr_allWords
where tip= 'isim'
) i on h.SIRA=i.SIRA   left join (
select SIRA, word_form  'x' from MyTable_rpr_allWords
where tip= 'x'
) x on h.SIRA=x.SIRA  

DECLARE @html nvarchar(MAX);
EXEC spQueryToHtmlTable @html = @html OUTPUT,  @query = N'SELECT * FROM chatbot.dbo.MyTable_rpr_topList', @orderBy = N'ORDER BY SIRA desc';

EXEC msdb.dbo.sp_send_dbmail
    @body = @html,
    @body_format = 'HTML',
    @query_no_truncate = 1,
    @attach_query_result_as_file = 0,
    @profile_name = 'Gmail'
    , @recipients = 'Alperozen84@gmail.com'
    , @subject = 'SQl 2008 R2 Email Test'
    
    /*
select distinct left(morphological_analysis,(charindex('+',morphological_analysis)))
  from tbl_word_forms_stems_and_frequencies

Adj+ --> sýfat
Postp+ -->edat
Adv+ --> adverb- zarf
Noun+-->Nouns isim
Pron+ -->pronouns- zamir
Conj+ -->conjunctions -baðlaç
Verb+ -->fiil
*/
/*
declare @bodi varchar(max);

set @bodi = cast( (
select td = dbtable + '</td><td>' + cast( entities as varchar(30) ) + '</td><td>' + cast( rows as varchar(30) )
from (
      select dbtable  = object_name( object_id ),
             entities = count( distinct name ),
             rows     = count( * )
      from sys.columns
      group by object_name( object_id )
      ) as d
for xml path( 'tr' ), type ) as varchar(max) )

set @bodi = '<table cellpadding="2" cellspacing="2" border="1">'
          + '<tr><th>Database Table</th><th>Entity Count</th><th>Total Rows</th></tr>'
          + replace( replace( @bodi, '&lt;', '<' ), '&gt;', '>' )
          + '</table>'

 

 DECLARE @body_custom VARCHAR(MAX)
SET @body_custom = '<head>
                        <title> Embedded Logo Example</title>
                        <meta name="Generator" content="EditPlus">
                        <meta name="Author" content="">
                        <meta name="Keywords" content="">
                        <meta name="Description" content="">
                    </head>
                    <body> '+@bodi+'
                    </body>'
EXEC msdb.dbo.sp_send_dbmail 
    @profile_name = 'Gmail'
    , @recipients = 'Alperozen84@gmail.com'
    , @subject = 'SQl 2008 R2 Email Test'
    , @body = @body_custom
    , @body_format = 'HTML'
   -- , @file_attachments = 'C:\Users\alper\Desktop\image_1.png'
   */