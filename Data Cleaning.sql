select *
from NashvilleHousing

-- Standarize Date formate

select SaleDateConverted, CONVERT(Date,SaleDate)
from NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted DATE;

Update NashvilleHousing
set SaleDateConverted = CONVERT(date,SaleDate)

--Populate Property Address data

select *
from NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
  on a.ParcelID = b.ParcelID
  AND A.[UniqueID ] <> B.[UniqueID ]
Where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
  on a.ParcelID = b.ParcelID
  AND A.[UniqueID ] <> B.[UniqueID ]

-- Breaking out Address into Individual  Columns (Address, City, State)

select PropertyAddress
from NashvilleHousing

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

from NashvilleHousing


ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(255);

Update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE NashvilleHousing
ADD PropertySplitCity nvarchar(255);

Update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


select *
from NashvilleHousing

select OwnerAddress
from NashvilleHousing

select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
from NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress nvarchar(255);

Update NashvilleHousing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
ADD OwnerSplitCity nvarchar(255);

Update NashvilleHousing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState nvarchar(255);

Update NashvilleHousing
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

---Changing Y and N to Yes and NO "Sold as Vacant" field

select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
, CASE When SoldAsVacant = 'Y' then 'Yes'
   WHEN SoldAsVacant = 'N' then 'No'
   ELSE SoldAsVacant
   End
from NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' then 'Yes'
   WHEN SoldAsVacant = 'N' then 'No'
   ELSE SoldAsVacant
   End

--Removing Duplicates
WITH RowNumCTE AS(
select *,
   ROW_NUMBER() over (
   Partition by ParcelID,
                PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
				  UniqueID
				) row_num


from NashvilleHousing
--order by ParcelID
)
SELECT *
from RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

--Deleting Columns

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

select *
from NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate