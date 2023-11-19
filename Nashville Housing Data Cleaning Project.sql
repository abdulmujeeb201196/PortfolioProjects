

/*

Cleaning Data in SQL Queries

*/


select * 
from NashvilleHousing
where OwnerName is NULL
--------------------------------------------------------------------------------------------------------------------------

-- Selecting Year Only
Select SaleDate, Year(SaleDate) as Year
--Month(SaleDate) as Month
from NashvilleHousing


-- Standardize Date Format

Select SaleDate,CONVERT(date, SaleDate)
from NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = Convert(date, SaleDate)   -- Not Updating the column

-- Let's try adding new column

ALTER TABLE NashvilleHousing
Add SaleDateConverted date;

UPDATE NashvilleHousing
SET SaleDateConverted = Convert(date, SaleDate)




 --------------------------------------------------------------------------------------------------------------------------

-------- Populate Property Address data  --------

---- Display rows where property address isn't entered
Select*
from NashvilleHousing
where PropertyAddress is null

---- Populating Property Address by ParcelID, if one ParcelID has Property Address then fill the other property address 
---- of missing row with same parcel ID
Select*
from NashvilleHousing
order by ParcelID

-- ISNULL is used to if values of first expression are null, then values of second expression will popukate them

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) 
from NashvilleHousing a
JOIN NashvilleHousing b
    ON A.ParcelID = B.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL

-- Now Replacing New Column values with Null Property Address values

UPDATE a
SET a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress) 
from NashvilleHousing a
JOIN NashvilleHousing b
    ON A.ParcelID = B.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL
--------------------------------------------------------------------------------------------------------------------------

-------- Breaking out Address into Individual Columns (Address, City, State)  --------

---- Splitting Property Address Column ----
Select PropertyAddress
from NashvilleHousing

Select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address, -- -1 for excluding cooma
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address -- +1 for excluding cooma
from NashvilleHousing

---- Creating Address, City Columns ----
ALTER TABLE NashvilleHousing  -- Adding New Columns
Add PropertySplitAddress nvarchar(255), 
PropertySplitCity nvarchar(255);

---- Inserting values in new columns from Property Address ----
UPDATE NashvilleHousing  
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) , 
PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


Select *
from NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------


-------- Splitting Onwer Address Column --------

Select OwnerAddress
from NashvilleHousing


---- Splitting Owner Address Column to Address, City and State Columns ----

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'),  3),   -- Replacing Comma with Period(Dot) to seperate the information in different columns
PARSENAME(REPLACE(OwnerAddress, ',', '.'),  2),  
PARSENAME(REPLACE(OwnerAddress, ',', '.'),  1)   
from NashvilleHousing

---- Creating Address, City and State Columns ----
ALTER TABLE NashvilleHousing 
Add OwnerSplitAddress nvarchar(255), 
OwnerSplitCity nvarchar(255), 
OwnerSplitState nvarchar(255);


---- Inserting values in new columns from Owner Address ----
UPDATE NashvilleHousing  
SET OwnerSplitAddress =PARSENAME(REPLACE(OwnerAddress, ',', '.'),  3) , 
OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),  2),
OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),  1)


---- Displaying newly created columns ----
Select NashvilleHousing.OwnerSplitAddress,
NashvilleHousing.OwnerSplitCity,
NashvilleHousing.OwnerSplitState
from NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------


-- Checking If Y and N exits in  "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
Order by 2

-- Change Y and N to Yes and No in "Sold as Vacant" field
Select SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
From NashvilleHousing

-- Updating Values
UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END

-- Checking if values are successfully updated
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
Order by 2

-----------------------------------------------------------------------------------------------------------------------------------------------------------

---- Remove Duplicates ----

-- Looking At Duplicate Values
WITH RownNumCTE As (
Select *,   -- If there is any duplicate data then row number column will be 2(All the columns except Unique Identifier)
		ROW_NUMBER() OVER (
		PARTITION BY  ParcelID,
					  PropertyAddress,
					  SalePrice,
					  SaleDate,
					  LegalReference
					  ORDER BY
						UniqueID) as row_num
						
From NashvilleHousing
--ORDER BY row_num  
)

Select *
From RownNumCTE
Where row_num > 1
Order BY PropertyAddress


-- Deleting Duplicate Values
WITH RownNumCTE As (
Select *,   -- If there is any duplicate data then row number column will be 2(All the columns except Unique Identifier)
		ROW_NUMBER() OVER (
		PARTITION BY  ParcelID,
					  PropertyAddress,
					  SalePrice,
					  SaleDate,
					  LegalReference
					  ORDER BY
						UniqueID) as row_num
						
From NashvilleHousing
--ORDER BY row_num  
)

DELETE
From RownNumCTE
Where row_num > 1



---------------------------------------------------------------------------------------------------------

---- Delete Unused Columns

-- Created New Table by Clicking Right Click on Table Name in Object Explorer,  Move to Script Table As then Select Create To and -
-- Click on New Query Editor. Chnage the name of the table and new table will be created as a clone of previous table

-- Inserting Data in new table from existed table 
INSERT INTO NEWNashvilleHousing 
Select * from NashvilleHousing;

SELECT * FROM NEWNashvilleHousing


ALTER TABLE NEWNashvilleHousing 
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict, SaleDate

CREATE VIEW NEWNashvilleHousingVI AS
Select * from NEWNashvilleHousing
Where OwnerName is not null
AND
Bedrooms is not null

select * from NEWNashvilleHousingVI  
 


-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------


