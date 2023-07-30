












create view portfolioprojectcoviddeaths as 
select location, date, total_cases, new_cases, total_deaths, population
from [PORTFOLIO PROJECT]..CovidDeaths
 
 select*
 from portfolioprojectcoviddeaths

----looking at total cases vs total deaths in each country
create view deathpercentage as
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from [PORTFOLIO PROJECT]..CovidDeaths

-- For locations
create view deathpercentagebylocations as
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from [PORTFOLIO PROJECT]..CovidDeaths
where location like '%states%'
 
 select*
 from deathpercentage


 --show likelyhood of dying if contract Covid in your country as at 2020
 create view percentpopulationinfected as
 select location, date total_cases, population, (total_cases/population)*100 as Percentpopulationinfected
from [PORTFOLIO PROJECT]..CovidDeaths
where location like '%states%'
 select*
 from percentpopulationinfected


--Countries with highest infection rate compared to population
create view Highestinfectioncount as
 select location, population, MAX(total_cases)*100 as Highestinfectioncount, MAX(total_cases/population)*100 as percentpopulationinfected
from [PORTFOLIO PROJECT]..CovidDeaths
group by location, population
--order by percentpopulationinfected

select*
from  Highestinfectioncount

--Countries with highest death count per population
create view totaldeathcount as
select location, MAX(cast(total_deaths as int)) as totaldeathcount
from [PORTFOLIO PROJECT]..CovidDeaths
where continent is not null
group by location
--order by totaldeathcount desc

select*
from totaldeathcount

--Break things down by continent
create view totaldeathcountbycontinent as 
select location, MAX(cast(total_deaths as int)) as totaldeathcount
from [PORTFOLIO PROJECT]..CovidDeaths
where continent is null
group by location
--order by totaldeathcount desc

select*
from totaldeathcountbycontinent

--Global numbers
create view Globalnumbers as 
select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/
SUM(new_cases)*100 as Deathpercentage
from [PORTFOLIO PROJECT]..CovidDeaths
where continent is not null
group by date
--order by 1,2

select*
from Globalnumbers

--For total global cases
create view totalglobalcases as 
select  SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/
SUM(new_cases)*100 as Deathpercentage
from [PORTFOLIO PROJECT]..CovidDeaths
where continent is null
--order by 1,2

select*
from totalglobalcases


--Total population vs Total vaccination
create view totalpopulationvstotalvaccinations as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from [PORTFOLIO PROJECT]..CovidDeaths dea
join [PORTFOLIO PROJECT]..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date 
where dea.continent is not null
--order by 1,2

select*
from totalpopulationvstotalvaccinations



--For new vaccination per day(rolling count) using partition by
create view  totalpopulationvstotalvaccinationusingpartitionby as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
from [PORTFOLIO PROJECT]..CovidDeaths dea
join [PORTFOLIO PROJECT]..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date 
where dea.continent is not null
--order by 2,3

select*
from totalpopulationvstotalvaccinationusingpartitionby


CREATE VIEW Percentpopulationvaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations))
OVER (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
from [PORTFOLIO PROJECT]..CovidDeaths dea
JOIN [PORTFOLIO PROJECT]..CovidVaccinations vac
ON dea.location = vac.location 
AND dea.date = vac.date
WHERE dea.continent is not null 


select*
from Percentpopulationvaccinated