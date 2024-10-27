SELECT *
From PortfolioProject..CovidDeaths
Where continent is not null
Order By 3,4

--SELECT *
--From PortfolioProject..CovidVaccinations
--Order By 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order by 1,2



-- looking at the total cases verses total deaths
-- shows the likeleyhood of dying contract covid in your conutry
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
From PortfolioProject..CovidDeaths
Where location like '%Australia%'
Order by 1,2

-- looking at the total cases vs population
-- shows what percentage of population got covid

Select location, date, population, total_deaths, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Where location like '%Australia%'
Order by 1,2

-- looking at countires with the highest infection rate compared to population


Select location, population, MAX(total_deaths) as HighestInfectionCount, (Max(total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%Australia%'
Group by location, population
Order by PercentPopulationInfected DESC

-- Showing countries with highest death count per population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%Australia%'
Where continent is not null
Group by location
Order by TotalDeathCount DESC

-- showing continents with the highest death count per population

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%Australia%'
Where continent is null
Group by location
Order by TotalDeathCount DESC

--global number

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as deathpercentage
From PortfolioProject..CovidDeaths
Where continent is not null
--group by date
Order by 1,2

--looking at total population va vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) 
as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
    On dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- CTE

With PopVsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) 
as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
    On dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

Select *, (RollingPeopleVaccinated/Population)*100
From PopVsVac



--TEMP TABLE


Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) 
as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
    On dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

--making changes to TEMP table

DROP table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) 
as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
    On dea.location = vac.location
    and dea.date = vac.date
--where dea.continent is not null

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


--creating view to store datra for later visualizations 

Create view PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) 
as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths as dea
Join PortfolioProject..CovidVaccinations as vac
    On dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null

Select *
From PercentPopulationVaccinated
