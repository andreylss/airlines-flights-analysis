# Airlines Flights SQL Analysis

## Overview
This project explores an **Airlines Flights dataset** using **SQL Server**. The main idea was to create questions about the dataset and answer them using SQL queries. This approach helped practice **exploratory data analysis (EDA)** with real-world flight data.

The dataset contains flight travel details between cities in India, including features such as:
- Source & destination city
- Arrival & departure time
- Duration
- Price
- Flight class
- Number of stops

The dataset is originally from Kaggle:
- [Airlines Flights Dataset](https://www.kaggle.com/datasets/rohitgrewal/airlines-flights-data)

## Dataset Description
The Airlines Flights dataset is a CSV file with structured records of flight.

Columns include:
- `airline`: Name of the airline
- `flight`: Flight code
- `source_city`: City where the flight departs
- `departure_time`: Time of day the flight departs
- `stops`: Number of stops (e.g., zero, one)
- `arrival_time`: Time of day the flight arrives
- `destination_city`: City where the flight lands
- `class`: Flight class (Economy, Business, etc.)
- `duration`: Flight duration in hours
- `days_left`: Days remaining until the flight
- `price`: Flight price in local currency

## Project Goal
The goal of this project is to **explore the dataset using SQL queries**. Some of the questions answered include:

## SQL Server Setup
- The dataset is loaded into a SQL Server table called `AirlinesFlights`.
- `BULK INSERT` is used to import the CSV.
- Queries are structured to answer each question clearly.

