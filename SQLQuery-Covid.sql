--SELECT *
--FROM CovidDeaths
--ORDER BY 3,4


--Select Location, date, total_cases,total_deaths_per_million, (total_deaths_per_million/total_cases)*100 as DeathPercentage
--From CovidDeaths
--Where location like '%india%'

--order by 1,2

---Looking at courtries with highest infection rate

--Select Location, population, MAX(total_cases) as highestinfectioncount, MAX((total_cases/population))*100 as populationinfected
--From CovidDeaths
----Where location like '%india%'
--GROUP BY Location, population
--order by populationinfected DESC

--SHOWING COUNTRY WITH HIGHEST DEATH COUNT PER POPULATION

--Select Location, MAX(total_deaths) as TOTALDEATHCOUNT
--From CovidDeaths
----Where location like '%india%'
--GROUP BY Location
--order by TOTALDEATHCOUNT DESC

--Select Location, MAX(cast(total_deaths as int)) as TOTALDEATHCOUNT
--From CovidDeaths
----Where location like '%india%'
--where continent is not null
--GROUP BY Location
--order by TOTALDEATHCOUNT DESC

--Select Location, MAX(cast(total_deaths as int)) as TOTALDEATHCOUNT
--From CovidDeaths
----Where location like '%india%'
--where continent is null
--GROUP BY Location
--order by TOTALDEATHCOUNT DESC

--SELECT *
--FROM SHEET1$
--ORDER BY 3,4

--select dea.continent,dea.location,dea.date,dea.population,dea.new_vaccinations
--FROM CovidDeaths dea
--JOIN CovidVaccinations VAC
--ON dea.location=VAC.location
--and dea.date = VAC.date
--where dea.continent is not null
--order by 1,2,3

----Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
----, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
----, (RollingPeopleVaccinated/population)*100
----From CovidDeaths dea
----Join CovidVaccinations vac
----	On dea.location = vac.location
----	and dea.date = vac.date
----where dea.continent is not null 
----order by 2,3

--Temp Table-- Using CTE to perform Calculation on Partition By in previous query

--With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
--as
--(
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
--From CovidDeaths dea
--Join CovidVaccinations vac
--	On dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3
--)
--Select *, (RollingPeopleVaccinated/Population)*100
--From PopvsVac


-- Using Temp Table to perform Calculation on Partition By in previous query

--DROP Table if exists #PercentPopulationVaccinated
--Create Table #PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--Date datetime,
--Population numeric,
--New_vaccinations numeric,
--RollingPeopleVaccinated numeric
--)

--Insert into #PercentPopulationVaccinated
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
--From CovidDeaths dea
--Join CovidVaccinations vac
--	On dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

--Select *, (RollingPeopleVaccinated/Population)*100
--From #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

