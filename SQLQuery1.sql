select * 
from PortfolioProject..covidDeaths
where continent is not null

--select * 
--from PortfolioProject..covidvacciations

--select Data that we are going to be using 

select location,date,total_cases,new_cases,total_deaths,population 
from PortfolioProject..covidDeaths
order by 1,2

--looking at total_cases and total_Deaths
select location,date,new_cases_smoothed,new_deaths_smoothed,(new_cases_smoothed/new_deaths_smoothed)*100 as per
from PortfolioProject..covidDeaths
where location like '%Brazil%'
order by 1,2

--looking at total_cases vs Population
--shows what precentage of population got covid
select location,date,total_cases,population,(total_cases/population)*100 as Deathpercentage
from PortfolioProject..covidDeaths
--where location like '%brazil%'
order by 1,2


--Looking at Country With Highest Rate Compared To Population
select location,population,max(new_cases_smoothed) as max_cases
from PortfolioProject..covidDeaths
group by location,population
 
 ---Showing Countries with Highest death count per Population
 select location,max(cast(total_deaths as int))as Totadeathcount
 from PortfolioProject..covidDeaths
 where continent is not null
 group by location
 order by Totadeathcount desc

 --Let's break things down by continent 
  select continent,max(cast(total_cases as int))as Totadeathcount
 from PortfolioProject..covidDeaths
 --where continent is null
 where continent is not null
 group by continent
 order by Totadeathcount desc

 --new deaths and new cases across the world
 select date, sum(new_cases),sum(cast(new_deaths as int))  as DeathPercentage
 from PortfolioProject..covidDeaths
 where continent is not null 
 GROUP by date 
 order by 1,2

 --Join the Two Tables
  SELECT * 
 FROM PortfolioProject..covidDeaths as dea
 join PortfolioProject..covidvacciations as vac
 ON dea.location = vac.location
 and dea.date = vac.date

 --Looking Total Population and Toatal Vaccinations
 SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(CONVERT(INT,vac.new_vaccinations))over(partition by dea.location ORDER BY dea.location,dea.Date) as RollingpeopleVaccinated
 FROM PortfolioProject..covidDeaths as dea
 join PortfolioProject..covidvacciations as vac
 ON dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
  --where vac.new_vaccinations is not null
 order by 2,3

 --USE CTE
 with popvsvac (continent,location,date,population,new_vaccinations,Rollingpeoplevaccinated)
 as
 (
 SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(CONVERT(INT,vac.new_vaccinations))over(partition by dea.location ORDER BY dea.location,dea.Date) as RollingpeopleVaccinated
 FROM PortfolioProject..covidDeaths as dea
 join PortfolioProject..covidvacciations as vac
 ON dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
  --where vac.new_vaccinations is not null
 --order by 2,3
 )
 select * 
 from popvsvac

 --Temp Table
 Drop table if exists #percentpeoplevaccinated
 create Table #percentpeoplevaccinated
 (
 continent nvarchar(255),
 location nvarchar(255),
 date datetime,
 population numeric,
 new_vaccinations numeric,
 rollingpeoplevaccinated numeric
 )
 insert into #percentpeoplevaccinated
  SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(CONVERT(INT,vac.new_vaccinations))over(partition by dea.location ORDER BY dea.location,dea.Date) as RollingpeopleVaccinated
 FROM PortfolioProject..covidDeaths as dea
 join PortfolioProject..covidvacciations as vac
 ON dea.location = vac.location
 and dea.date = vac.date
-- where dea.continent is not null
 --order by 2,3

 select * 
 from #percentpeoplevaccinated


 --creating view to store data for later visualization
 create view percentpeoplevaccinated as 
   SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(CONVERT(INT,vac.new_vaccinations))over(partition by dea.location ORDER BY dea.location,dea.Date) as RollingpeopleVaccinated
 FROM PortfolioProject..covidDeaths as dea
 join PortfolioProject..covidvacciations as vac
 ON dea.location = vac.location
 and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
from percentpeoplevaccinated