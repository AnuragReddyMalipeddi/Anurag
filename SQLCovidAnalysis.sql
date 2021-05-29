-- Checking data in Tables

SELECT * FROM CovidDeaths;

SELECT * FROM CovidVaccinations;

-- Selecting Data to work with

SELECT 
       Location, 
	   date, 
	   total_cases, 
	   new_cases, 
	   total_deaths, 
	   population
FROM CovidDeaths
ORDER BY Location, date;

-- Likelihood of dying with covid in India.

SELECT 
      Location, 
	  date, 
	  total_cases, 
	  total_deaths, 
	  (total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE Location LIKE '%india%'
ORDER BY Location, date;

-- Proportion of population that contracted Covid

SELECT 
      Location, 
	  date, 
	  total_cases, 
	  population, 
	  (total_cases/population)*100 AS PercentPopulationInfected
FROM CovidDeaths
--WHERE Location LIKE '%india%'
ORDER BY Location, date;

-- Country with Highest Infection count comapred to population

SELECT 
      Location,  
	  population,
	  MAX(total_cases) HighestInfectionCount, 
	  MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM CovidDeaths
GROUP BY Location, population
ORDER BY PercentPopulationInfected DESC;

-- Highest Death Count Per Population

SELECT 
      Location,  
	  MAX(CAST(total_deaths as INT)) TotalDeathCount 
FROM CovidDeaths
WHERE continent is NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC;


-- Death Content Per Continent

SELECT 
      continent,  
	  MAX(CAST(total_deaths as INT)) TotalDeathCount 
FROM CovidDeaths
WHERE continent is NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;


-- Global Deaths

SELECT 
      SUM(new_cases) as total_cases,
	  SUM(CAST(new_deaths as int)) as total_deaths,
	  (SUM(CAST(new_deaths as int))/SUM(new_cases)) * 100 as DeathPercentage
FROM CovidDeaths
WHERE continent is not null;

-- Total Population VS Vaccinations

SELECT 
      dea.continent,
	  dea.location,
	  dea.date,
	  dea.population,
	  vac.new_vaccinations,
	  SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
FROM CovidDeaths dea
INNER JOIN CovidVaccinations vac
      ON   dea.location = vac.location AND
	       dea.date     = vac.date
WHERE dea.continent is not null
ORDER BY dea.location, dea.date


-- Total population Vs vaccinations

WITH PopVsVacc (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) AS
(
SELECT 
      dea.continent,
	  dea.location,
	  dea.date,
	  dea.population,
	  vac.new_vaccinations,
	  SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
FROM CovidDeaths dea
INNER JOIN CovidVaccinations vac
      ON   dea.location = vac.location AND
	       dea.date     = vac.date
WHERE dea.continent is not null
)
SELECT *, (RollingPeopleVaccinated/Population)*100 AS popVaccPercentage FROM PopVsVacc;



-- Percent Population Vaccinated Using Temp Table
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric ,
RollingPeopleVacccinated numeric 
)

INSERT INTO #PercentPopulationVaccinated
SELECT 
      dea.continent,
	  dea.location,
	  dea.date,
	  dea.population,
	  vac.new_vaccinations,
	  SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
FROM CovidDeaths dea
INNER JOIN CovidVaccinations vac
      ON   dea.location = vac.location AND
	       dea.date     = vac.date
WHERE dea.continent is not null

SELECT * FROM #PercentPopulationVaccinated


-- CREATING A VIEW

CREATE VIEW PercentPopulationVaccinated AS
SELECT 
      dea.continent,
	  dea.location,
	  dea.date,
	  dea.population,
	  vac.new_vaccinations,
	  SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location ORDER BY dea.location,dea.date) as RollingPeopleVaccinated
FROM CovidDeaths dea
INNER JOIN CovidVaccinations vac
      ON   dea.location = vac.location AND
	       dea.date     = vac.date
WHERE dea.continent is not null

SELECT * FROM PercentPopulationVaccinated



