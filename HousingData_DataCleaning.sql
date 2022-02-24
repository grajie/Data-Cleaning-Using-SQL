
/************Data Cleaning UseCase:***************/

		--1) Standardize Date Format
		--2) Populate Missing Property Address Field
		--3) Breaking out Address into Individual Columns (Address, City, State)
		--4) Formatting Owner Address
		--5) Change Y and N to Yes and No in "Sold as Vacant" field
		--6) Remove Duplicates

/************SQL Concepts Used:********************/

		-- CONVERT()
		-- ISNULL()
		-- JOIN
		-- UPDATE with JOIN
		-- UPDATE with CASE
		-- Deleting DUPLICATES using RANK() with CTE()
		-- STRING Functions
			--SUBSTRING()
			--CHARINDEX()
			--TRIM()
			--LEN()
			--PARSENAME()
			--REPLACE()


--1) Standardize Date Format

	SELECT CONVERT(date,SaleDate)  
	FROM NashHousing

	ALTER TABLE nashhousing 
	add saledateUpdated date;

	SELECT saledate,saledateUpdated
	FROM nashhousing

--2) Populate Property Address data

	SELECT parcelid,propertyaddress 
	FROM NashHousing 
	order by parcelID

	-- Since parcelID is the same for propertyAddress, INNER JOIN on parcelID with ISNULL() can be used

	SELECT a.ParcelID,a.PropertyAddress,b.parcelid,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
	FROM NashHousing a
	join NashHousing b
		on a.ParcelID = b.ParcelID 
		and a.UniqueID <> b.UniqueID
	WHERE a.PropertyAddress is null

	update a
	set propertyaddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
	FROM NashHousing a
	join NashHousing b
		on a.ParcelID = b.ParcelID 
		and a.UniqueID <> b.UniqueID
	WHERE a.PropertyAddress is null

--3)Breaking out Address into Individual Columns (Address, City, State)

	-- Extracting Address , City

	SELECT SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1),
		   TRIM(SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,LEN(propertyaddress)))
	FROM NashHousing

	-- Update the split Address

	ALTER table nashhousing
	ADD SplitAddress nvarchar(255) 

	ALTER table nashhousing
	ADD SplitCity nvarchar(255) 

	Update nashhousing 
	SET SplitAddress = SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1)

	update NashHousing 
	set SplitCity = TRIM(SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,LEN(propertyaddress)))

	Select propertyaddress,splitaddress,splitCity 
	FROM nashhousing

--4)Format OwnerAddress  -- Using PARSENAME() for this format

	SELECT PARSENAME(REPLACE(owneraddress, ',' , '.'),3)
	,PARSENAME(REPLACE(owneraddress, ',' , '.'),2)
	,PARSENAME(REPLACE(owneraddress, ',' , '.'),1)
	From NashHousing

	ALTER table nashhousing
	ADD SplitOwnerAddress nvarchar(255)

	ALTER table nashhousing
	ADD SplitOwnerCity nvarchar(255)

	ALTER table nashhousing
	ADD SplitOwnerState nvarchar(255)

	update nashhousing
	set SplitOwnerAddress = PARSENAME(REPLACE(owneraddress, ',' , '.'),3)

	update NashHousing
	set SplitOwnerCity = PARSENAME(REPLACE(owneraddress, ',' , '.'),2)

	update NashHousing
	set SplitOwnerState = PARSENAME(REPLACE(owneraddress, ',' , '.'),1)

	SELECT splitowneraddress,splitownercity,splitownerstate
	FROM NashHousing


--5)Change Y and N to Yes and No in "Sold as Vacant" field    


	SELECT case when SoldAsVacant='Y' then 'Yes'  
				when SoldAsVacant='N' then 'No' end		 
	FROM NashHousing
	WHERE SoldAsVacant in ('Y','N')


	UPDATE NashHousing
	SET SoldAsVacant = case SoldAsVacant 
					   when 'Y' then 'YES' 
					   when 'N' then  'No' 
					   end
	WHERE SoldAsVacant in ('Y','N')

	SELECT distinct SoldAsVacant
	FROM NashHousing


--6)Remove Duplicates

	SELECT * 
	FROM NashHousing 
	order by ParcelID

	-- When the combination of ParcelID,PropertyAddress,SaleDate,LegalReference repeat then its a duplicate

	with CTE as
	(
		SELECT *,ROW_NUMBER () 
				 OVER (partition by ParcelID,PropertyAddress,SaleDate,saleprice,LegalReference order by ParcelID) as rownum
		FROM NashHousing
	) 
	delete * FROM CTE WHERE CTE.rownum>1

	select * from NashHousing
