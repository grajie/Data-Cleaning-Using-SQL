# Data Cleaning of Housing Dataset with SQL

  Data forms the backbone of any data analytics you do. **Data cleaning** is the process of editing, correcting, and structuring data within a data set so that it’s generally       uniform and prepared for analysis. 
  This includes
  - Removing irrelevent and duplicate Values
  - Dealing with missing data
  - Formatting Data for analysis
  - Fixing structural errors
  
 This Project is purely based on SQL Server , employing its innate capabilities : **String Functions , Window Functions , Joins , CTE**
  
 
 **Table Of Contents**
 - [Dataset Overview](#dataset-overview "Dataset Overview")
 - [Tools Used](#tools-used "Tools USed")
 - [Data Cleaning Steps Adhered](#data-cleaning-steps-adhered "Data Cleaning Steps Adhered")


## Dataset Overview
- Data Source: https://www.kaggle.com/tmthyjames/nashville-housing-data
- Rows: 56373 Columns: 19

## Tools Used
- RDBMS: Microsoft SQL Server Management Studio

## [Data Cleaning Steps Adhered](https://github.com/grajie/Data-Cleaning--Using-SQL/blob/main/HousingData_DataCleaning.sql)
1. Standardize Date Format
2. Populate Missing Address Fields
3. Breaking Address into Induvidual Columns( Street,City,State) (String Functions)
4. Formatting Address ( PARSENAME() )
5. Structural Error : Changing 'Y' to 'Yes' , 'N' to 'No'
6. Removing Duplicates (using CTE , Rank())

