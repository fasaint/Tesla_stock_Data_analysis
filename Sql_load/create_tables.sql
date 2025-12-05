CREATE TABLE tesla_stock_data (
  Date text,
  Close text,
  High text,
  Low text,
  Open text,
  Volume text
) ;

ALTER TABLE tesla_stock_data OWNER to postgres;

SELECT *
FROM tesla_stock_data;

\copy tesla_stock_data FROM 'C:\Users\Faggio\Desktop\tesla_stock_analysis\csv_file\Tesla_stock_data.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
