# 🏡 Nashville Housing Data Cleaning in SQL

This project showcases the use of SQL to clean and preprocess 
real-world housing data from Nashville. It simulates a typical backend 
data cleaning scenario a data analyst would handle before performing further analysis or dashboarding.

---

## 🛠️ Tools Used

- Microsoft SQL Server
- SQL (T-SQL)
- Data Source: Public dataset from [Kaggle](https://www.kaggle.com/tmthyjames/nashville-housing-data)

---

## 📌 Tasks Performed

1. **Standardized Date Format**
2. **Populated Missing Property Address using JOIN**
3. **Split Address into Individual Columns (Address, City, State)**
4. **Used `PARSENAME` to split Owner Address**
5. **Standardized 'SoldAsVacant' values (Y/N → Yes/No)**
6. **Removed Duplicates using `ROW_NUMBER()`**
7. **Dropped Irrelevant Columns**

---

## 🔍 Sample Query Snippet

```sql
-- Remove duplicates using CTE and ROW_NUMBER
WITH duplicate_entry AS (
  SELECT *,
         ROW_NUMBER() OVER(
           PARTITION BY ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference
           ORDER BY UniqueID) AS row_num
  FROM NashvilleHousing
)
DELETE FROM duplicate_entry
WHERE row_num > 1;
