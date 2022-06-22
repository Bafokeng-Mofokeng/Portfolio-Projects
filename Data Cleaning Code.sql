--Cleaning Data in SQL Queries

Select *
From [Portfolio Project]..NashvilleHousing

------------------------------------------------------------------------------------------------------

--Standardize Date Format

Select SaleDateConverted, CONVERT(Date, SaleDate)
From [Portfolio Project]..NashvilleHousing

Update NashvilleHousing
Set SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted =  CONVERT(Date, SaleDate)

---------------------------------------------------------------------------------------------------------

--Populate Property Address Data


Select *
From [Portfolio Project]..NashvilleHousing
--Where PropertyAddress is Null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project]..NashvilleHousing a
JOIN [Portfolio Project]..NashvilleHousing b
 on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a 
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project]..NashvilleHousing a
JOIN [Portfolio Project]..NashvilleHousing b
 on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]

-------------------------------------------------------------------------------------------------------

--Breaking out address into individual columns (address, city, state)

Select PropertyAddress
From [Portfolio Project]..NashvilleHousing


Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))  as Address
FROM [Portfolio Project]..NashvilleHousing



ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress =  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity =  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))



Select OwnerAddress
From [Portfolio Project]..NashvilleHousing


Select 
PARSENAME(Replace(OwnerAddress,',','.'),3)
,PARSENAME(Replace(OwnerAddress,',','.'),2)
,PARSENAME(Replace(OwnerAddress,',','.'),1)
From [Portfolio Project]..NashvilleHousing







ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress =  PARSENAME(Replace(OwnerAddress,',','.'),3) 

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity =  PARSENAME(Replace(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState =  PARSENAME(Replace(OwnerAddress,',','.'),1)




-------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold As Vacant" Field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Portfolio Project]..NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant,
	Case when SoldAsVacant = 'Y' then 'Yes'
	When SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	End
From [Portfolio Project]..NashvilleHousing


Update NashvilleHousing
set SoldAsVacant =
	Case when SoldAsVacant = 'Y' then 'Yes'
	When SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	End
From [Portfolio Project]..NashvilleHousing

------------------------------------------------------------------------------------------------------

--Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	Partition by ParcelId,
				PropertyAddress,	
				SalePrice,
				SaleDate,
				LegalReference
				Order by 
					UniqueId
					) row_num

From [Portfolio Project]..NashvilleHousing
--Order by ParcelId
)
delete 
From RowNumCTE
where row_num > 1
--order by PropertyAddress




--------------------------------------------------------------------------------------
--Delete Unused Columns


select *
From [Portfolio Project]..NashvilleHousing


Alter table [Portfolio Project]..NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

