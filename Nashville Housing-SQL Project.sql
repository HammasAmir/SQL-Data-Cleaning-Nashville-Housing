
--Cleaning Data in SQL

Select *
From demodb.dbo.Nashvillehousing

-- Standardize Date Format

Select SaleDateConverted, CONVERT(Date,SaleDate)
From demodb.dbo.Nashvillehousing

//Update Nashvillehousing
SET SaleDate=CONVERT(Date,SaleDate)//           # Did not work here

Alter Table Nashvillehousing
Add SaleDateConverted Date;

Update Nashvillehousing
SET SaleDateConverted=CONVERT(Date,SaleDate)


--Populate Property Address Data

Select *
From demodb.dbo.Nashvillehousing
WHERE PropertyAddress IS NULL

Select a.ParcelD, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From demodb.dbo.Nashvillehousing a
JOIN demodb.dbo.Nashvillehousing b
ON a.ParcelID= b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = b.PropertyAddress
FROM demodb.dbo.Nashvillehousing a
JOIN demodb.dbo.Nashvillehousing b
  ON a.ParcelID = b.ParcelID
  AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;


--Breaking Address into Individual Columns (Address, City, State)

Select SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress) -1) As Address
     , SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

FROM demodb.dbo.Nashvillehousing 

Alter Table Nashvillehousing
Add PropertySplitAddress VARCHAR(255);

Update Nashvillehousing
SET PropertySplitAddress=SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress) -1) As Address

Alter Table Nashvillehousing
Add PropertySplitCity VARCHAR(255);

Update Nashvillehousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress));


# Doing same thing in owner address using PARSENAME

Select OwnerAddress
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3 )
, PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2 )
, PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1 )


FROM demodb.dbo.Nashvillehousing 



-- Change Y and N to Yes and No in "Sold as vacant" field:

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
FROM demodb.dbo.Nashvillehousing 
GROUP BY SoldAsVacant
ORDER BY 2


Select SoldAsVacant
, CASE WHEN SoldAsVacant='Y' then 'Yes'
       WHEN SoldAsVacant='N' then 'No'
       ELSE SoldAsVacant
       END
FROM demodb.dbo.Nashvillehousing 

Update Nashvillehousing
SET SoldAsVacant= CASE WHEN SoldAsVacant='Y' then 'Yes'
       WHEN SoldAsVacant='N' then 'No'
       ELSE SoldAsVacant
       END


--Remove duplicates

WITH duplicate_entry AS(
Select *,
ROW_NUMBER() OVER(PARTITION BY ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference
                  ORDER BY UniqueID) AS row_num
FROM demodb.dbo.Nashvillehousing 
ORDER BY ParcelID)

DELETE
FROM duplicate_entry
WHERE row_num>1;


-- Delete Unused Columns

ALTER TABLE demodb.dbo.Nashvillehousing 
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate