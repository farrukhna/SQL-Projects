-- <<<<<< Checking out whether the connection and datasets are being retrieved perfectly >>>>>>>

Select *
From PortfolioProject..CovidVaccinations
where continent is not null
Order by 3,4


Select *
From PortfolioProject..CovidDeaths
Order by 3,4




-- <<<<<< Data Preparation Process of both tables in the Portolfolioproject..CovidDeaths and CovidVaccinations >>>>>>>





-- Converting data type of attributes (columns) of CovidDeaths which we will need into the correct ones. You can use it to add and delete columns as well

alter table portfolioproject.dbo.CovidDeaths
alter column date date

alter table portfolioproject.dbo.CovidDeaths
alter column total_deaths int

alter table portfolioproject.dbo.CovidDeaths
alter column new_deaths int

alter table portfolioproject.dbo.CovidDeaths
alter column total_deaths_per_million float

alter table portfolioproject.dbo.CovidDeaths
alter column new_deaths_per_million float

alter table portfolioproject.dbo.CovidDeaths
alter column reproduction_rate float

alter table portfolioproject.dbo.CovidDeaths
alter column icu_patients int

alter table portfolioproject.dbo.CovidDeaths
alter column icu_patients_per_million float

alter table portfolioproject.dbo.CovidDeaths
alter column hosp_patients int

alter table portfolioproject.dbo.CovidDeaths
alter column hosp_patients_per_million float

alter table portfolioproject.dbo.CovidDeaths
alter column weekly_icu_admissions float

alter table portfolioproject.dbo.CovidDeaths
alter column weekly_icu_admissions_per_million float

alter table portfolioproject.dbo.CovidDeaths
alter column weekly_hosp_admissions float

alter table portfolioproject.dbo.CovidDeaths
alter column weekly_hosp_admissions_per_million float

-- Converting data type of attributes (columns) of CovidVaccinations which we will need into the correct ones.

alter table portfolioproject.dbo.CovidVaccinations
alter column date date

alter table portfolioproject.dbo.CovidVaccinations
alter column new_tests int

alter table portfolioproject.dbo.CovidVaccinations
alter column total_tests int

alter table portfolioproject.dbo.CovidVaccinations
alter column total_tests_per_thousand float

alter table portfolioproject.dbo.CovidVaccinations
alter column new_tests_per_thousand float

alter table portfolioproject.dbo.CovidVaccinations
alter column total_vaccinations int

alter table portfolioproject.dbo.CovidVaccinations
alter column people_vaccinated int

alter table portfolioproject.dbo.CovidVaccinations
alter column people_fully_vaccinated int

alter table portfolioproject.dbo.CovidVaccinations
alter column new_vaccinations int

alter table portfolioproject.dbo.CovidVaccinations
alter column total_vaccinations_per_hundred float

alter table portfolioproject.dbo.CovidVaccinations
alter column people_vaccinated_per_hundred float

alter table portfolioproject.dbo.CovidVaccinations
alter column people_fully_vaccinated_per_hundred float


-- Altering the Column Names which will need of the Table, Covid Deaths and Covid Vaccinations from the GUI.


-- Altering the data using Update / Set Queries

--Update PortfolioProject.dbo.CovidDeaths
--set total_deaths = 0
--Where location = 'Pakistan'





-- <<<<<< Data Exploration Process >>>>>>>






-- Select Data that we will be using

Select Location, Date, Total_Cases, New_Cases, Total_Deaths, Population
From PortfolioProject..CovidDeaths
Order by 1,2


-- Looking at total cases vs Total Deaths
-- Shows likelihood of dying if you contact covid in your country

Select Location,Date, Total_Cases, Total_Deaths, (Total_Deaths/Total_Cases)*100 as PercentageofDeaths
From PortfolioProject..CovidDeaths
Where Location like '%Pak%'
Order By 1,2

-- Looking at total cases as per population

Select Location,Date, Population, Total_Cases, (Total_Cases/Population)*100 as Population_Covid_Contracted
From PortfolioProject..CovidDeaths
Where Location like '%Pak%'
Order by 1,2

-- Countries with highest infection rate compared to population

Select Location, Population, MAX(Total_Cases) as HighestInfectionCount, MAX((Total_cases/Population))*100 as PopulationCovidContracted
From PortfolioProject..CovidDeaths
Group by Location,Population
Order by PopulationCovidContracted DESC

-- Showing the Countries with the Highest Death Count per Population

Select Location, MAX(cast(Total_Deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is not null
Group by Location
Order by TotalDeathCount DESC

-- Breaking things down by Continent

Select location, MAX(CAST(Total_Deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is null and location <> 'International' and location <> 'World'
Group by location
Order by TotalDeathCount DESC

-- Showing the continents with the highest death count per population

Select location, MAX(Total_Deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
where continent is null and location <> 'International'
Group by location
Order by TotalDeathCount DESC


-- Global Numbers

Select Date, SUM(New_Cases) as TotalCases, SUM(CAST(New_Deaths as int)) as TotalDeaths, SUM(CAST(New_Deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Date
Order by 1,2

Select SUM(New_Cases) as TotalCases, SUM(CAST(New_Deaths as int)) as TotalDeaths, SUM(CAST(New_Deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where Continent is not null
Order by 1,2

-- Counting the Number of instances where there were highest cases in all the countries

Select location, MAX(new_cases) as Highest_Cases_Recorded
From PortfolioProject..CovidDeaths 
where continent is not null
group by location
order by Highest_Cases_Recorded DESC

-- Counting the Number of instances where there were lowest cases in all the countries

Select location, MIN(new_cases) as Lowest_Cases_Recorded
From PortfolioProject..CovidDeaths 
where continent is not null
group by location
order by Lowest_Cases_Recorded DESC


-- Querying the average number of cases in all the countries per day

Select location, AVG(new_cases) as Avg_Cases_Recorded
From PortfolioProject..CovidDeaths 
where continent is not null
group by location
order by Avg_Cases_Recorded DESC


-- Querying Average of New Cases per two specefic countries without using Where Clause

Select location, AVG(new_cases) as Avg_Cases_Recorded
From PortfolioProject..CovidDeaths 
where continent is not null and location In ('Pakistan', 'India')
group by location
order by Avg_Cases_Recorded DESC

-- Combining the Column data 

Select continent + ', ' + location as Continent_and_Country_Names, date, total_cases 
From PortfolioProject..CovidDeaths
order by Continent_and_Country_Names asc


-- Finding out whether the Cases per Million in a country are on alarming rate or not

Select date,location, total_cases_per_million,

Case 
	When total_cases_per_million <= 50.0 Then 'Under Control'
	When total_cases_per_million <= 80.0 Then 'Need To Act'
	When total_cases_per_million > 100.0 Then 'Need To Act'
	Else 'No Data Available'
End As Decision 

From PortfolioProject.dbo.CovidDeaths 


-- Joining the two tables of Cases and Vaccinations for having a complete picture

Select Dea.Date, Dea.location, Vac.location, Dea.New_Cases, Dea.Total_Cases, Vac.new_vaccinations, Vac.total_vaccinations
From PortfolioProject..CovidDeaths as Dea
Inner Join PortfolioProject..CovidVaccinations as Vac
On Dea.date = Vac.Date and Dea.location = Vac.location
Order by Dea.Location, Dea.Date asc







-- <<<<<< Advanced Querying of Data using Stored Procedures,Temp Table, CTE, and Views >>>>>>>









-- Usage of Stored Procedures for Easy Reusability of SQL Codes

Drop Procedure QueryData

Create Procedure QueryData

As
Select *
From PortfolioProject..CovidVaccinations

Select *
From PortfolioProject..CovidVaccinations

Go;

Exec QueryData


-- Creation of Stored Procedure for Location Selection

Drop Procedure CountrySelection
Create Procedure CountrySelection @Location nvarchar(30)
As
Select *
From PortfolioProject..CovidDeaths
where location Like @Location
Go

Exec CountrySelection @Location = 'Pak%'




-- Looking at Total Population vs Vaccinations (usage of CTE)


Select Dea.continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations, SUM(Cast(Vac.New_Vaccinations as int)) over (Partition By Dea.location Order By 
Dea.Location,Dea.Date) as RollingPeopleVaccinated,
From PortfolioProject..CovidDeaths as Dea
Join PortfolioProject..CovidVaccinations as Vac
On Dea.Location = Vac.Location
Where Dea.continent is not null
and Dea.Date = Vac.Date 
Order By 2,3


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select Dea.continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations, 
SUM(Cast(Vac.New_Vaccinations as int)) over (Partition By Dea.location Order By 
Dea.Location,Dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths as Dea
Join PortfolioProject..CovidVaccinations as Vac
On Dea.Location = Vac.Location
Where Dea.continent is not null
and Dea.Date = Vac.Date 
--Order By 2,3
)

Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac




-- Temp Table 
DROP Table if exists #PercentPopulationPercentage
Create Table #PercentPopulationPercentage
(

Continent nvarchar(255),
Location nvarchar(255),
Date DateTime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,

)

Insert into #PercentPopulationPercentage
Select Dea.continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations, 
SUM(Cast(Vac.New_Vaccinations as int)) over (Partition By Dea.location Order By 
Dea.Location,Dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths as Dea
Join PortfolioProject..CovidVaccinations as Vac
On Dea.Location = Vac.Location
Where Dea.continent is not null
and Dea.Date = Vac.Date 
--Order By 2,3


Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationPercentage




-- Creating View to store data for later Visualizations

Create View PercentPopulationVaccinated as
Select Dea.continent, Dea.Location, Dea.Date, Dea.Population, Vac.New_Vaccinations, 
SUM(Cast(Vac.New_Vaccinations as int)) over (Partition By Dea.location Order By 
Dea.Location,Dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths as Dea
Join PortfolioProject..CovidVaccinations as Vac
On Dea.Location = Vac.Location
Where Dea.continent is not null
and Dea.Date = Vac.Date 
--Order By 2,3

Select *
From PercentPopulationVaccinated