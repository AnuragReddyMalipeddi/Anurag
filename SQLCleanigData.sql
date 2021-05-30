--Cleaning Data in SQL
Select * FROM NashvilleHousing

-- Standardizing Date Format

ALTER TABLE NashvilleHousing
ADD DateConverted Date

UPDATE NashvilleHousing
SET DateConverted = CONVERT(Date,SaleDate)

SELECT TOP 10 * FROM NashvilleHousing 

-- Populating Property Address Data

SELECT * 
FROM NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT 
--COUNT(*)
  a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing a
INNER JOIN NashvilleHousing b
ON a.ParcelID = b.ParcelID AND 
   a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


UPDATE a
SET a.PropertyAddress = b.PropertyAddress
FROM NashvilleHousing a 
INNER JOIN NashvilleHousing b
ON a.ParcelID = b.ParcelID AND
a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL



-- Breaking Address Column into individual columns (Address, City, State)

SELECT 
       SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) AS Address,
	   SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) AS City
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

SELECT TOP 10 * FROM NashvilleHousing

-- Separating OWner Address


SELECT 
      PARSENAME(REPLACE(OwnerAddress,',','.'),3) AS Address,
	  PARSENAME(REPLACE(OwnerAddress,',','.'),2) AS City,
	  PARSENAME(REPLACE(OwnerAddress,',','.'),1) AS State
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


-- Change Y and N to Yes and No in 'Sold as Vacant' field

SELECT DISTINCT(SoldAsVacant)
From NashvilleHousing

SELECT 
       SoldAsVacant,
	   CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	        WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
	   END AS SoldAsVacantUpdated
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
                        WHEN SoldAsVacant = 'N' THEN 'No'
					ELSE SoldAsVacant 
					END

-- Removing Duplicates

WITH RowNumCTE AS(
SELECT *,
       ROW_NUMBER() OVER ( PARTITION BY ParcelID,
	                                    PropertyAddress,
										SaleDate,
										SalePrice,
										LegalReference
							ORDER BY UniqueID) AS row_num
FROM NashvilleHousing
)

SELECT * FROM RowNumCTE
--DELETE FROM RowNumCTE
WHERE row_num>1;


--DELETE UNUSED COLUMNS

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate




