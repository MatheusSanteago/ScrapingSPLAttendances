# Saudi Pro League - Attendance // Scraping Transfermarket

![SPLogo](https://upload.wikimedia.org/wikipedia/en/thumb/7/75/Roshn_Saudi_League_Logo.svg/208px-Roshn_Saudi_League_Logo.svg.png)


The Saudi Pro League (SPL), is the highest division of association football in the Saudi Arabia.

In the last few years of the SPL, it has been linked to transfers and million-dollar contracts, and more recently big European football stars packed their bags and went to Saudi Arabia, bringing greater exposure to the League.

I decided to extract this data in order to enable analysis of the league.

Saudi Pro League - [Wikipedia](https://en.wikipedia.org/wiki/Saudi_Pro_League)

#### Extract

When it comes to gathering data from [Transfermarket](https://www.transfermarkt.com.br/), I rely on Selenium, BeautifulSoup, Pandas, and re. To complete this project, I opted for the Google Chrome driver.

Within the extract notebook, there are three separate areas for scraping different URLs. These areas include:
  1. Extracting attendance data from the 2007-2008 season.
  2. Gathering information on 1st Division teams.
  3. Extracting data on all 1st Division champions.

I use Pandas to scrape data, transform it into CSV format, and then store it in the RAW Zone.

#### Raw Dataframes 

##### Attendances
![Attendances](./Images/AttendancesRAWDataFrame.png)
<hr>

##### Champions
![Champions](./Images/ChampionsRAWDataframe.png)
<hr>

##### SPL Teams
![sa1TeamsRAWDataFrame](./Images/sa1TeamsRAWDataFrame.png)


# Not done!
