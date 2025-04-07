-- ADIM 1: VERİTABANI OLUŞTURMA
CREATE DATABASE KitaplikDB;
GO

USE KitaplikDB;
GO

-- Örnek tablo oluştur
CREATE TABLE Kitaplar (
    KitapID INT PRIMARY KEY IDENTITY(1,1),
    KitapAdi NVARCHAR(100),
    Yazar NVARCHAR(100),
    BasimYili INT
);
GO

-- Örnek veriler ekle
INSERT INTO Kitaplar (KitapAdi, Yazar, BasimYili)
VALUES 
('Simyacı', 'Paulo Coelho', 1995),
('Sefiller', 'Victor Hugo', 1862),
('Kürk Mantolu Madonna', 'Sabahattin Ali', 1943);
GO


-- ADIM 2: MANUEL YEDEKLEME (İsteğe bağlı test için)
BACKUP DATABASE KitaplikDB  
TO DISK = 'D:\SQL_Backups\KitaplikDB_Manuel.bak'  
WITH INIT, FORMAT;
GO


-- ADIM 3: SQL SERVER AGENT İLE OTOMATİK YEDEKLEME İÇİN STEP KODU
-- Bu kod bir Job adımına eklenmelidir (SQL Server Agent içinde)
BACKUP DATABASE KitaplikDB  
TO DISK = 'D:\SQL_Backups\KitaplikDB_Gunluk.bak'  
WITH INIT, FORMAT;
GO


-- ADIM 4: JOB LOG RAPORU (İşlem geçmişini görmek için)
SELECT 
    j.name AS Job_Adi,
    h.run_date AS Tarih,
    h.run_time AS Saat,
    h.run_duration AS Süre,
    CASE h.run_status
        WHEN 0 THEN 'Başarısız'
        WHEN 1 THEN 'Başarılı'
        WHEN 2 THEN 'Tamamlanmadı'
        WHEN 3 THEN 'İptal Edildi'
        WHEN 4 THEN 'Devam Ediyor'
    END AS Durum
FROM msdb.dbo.sysjobhistory h
JOIN msdb.dbo.sysjobs j ON h.job_id = j.job_id
WHERE j.name = 'KitaplikDB_GunlukYedek'
ORDER BY h.run_date DESC, h.run_time DESC;
GO
