# Grain Futures Trade Operations Database

A PostgreSQL database for a small CBOT grain futures trading desk, with the queries an operations analyst uses every day to track positions, calculate P&L, and catch errors before they cost money.

## The Scenario

A grain desk trades corn, soybeans, and wheat futures on the CBOT. Traders place orders through brokers, the brokers execute them on the exchange, and the operations team keeps the desk's records accurate: knowing every position, marking it to the day's settlement price, and making sure the desk's trades match the brokers' records.

This project builds that operations layer from scratch.

## Design Decisions

| Decision | Choice |
| --- | --- |
| Market | CBOT corn, soybeans, and wheat futures |
| Period | May 2023 – April 2024 |
| Desk | 3 traders (all trade every commodity), 2 brokers |
| Pricing | Specific contract months, not continuous front-month prices |
| Market data | Real daily settlement, high, and low prices (source: Barchart) |
| Trade data | Simulated trades, each priced within that day's actual trading range |

**Why contract months:** Trades are recorded by specific contract month (for example, July 2023 corn) because each contract month is a separate contract with its own price and expiration date. Using a single continuous price series would value positions at the wrong contract's price, which can make P&L inaccurate, even turning a gain into a loss. The trade-off is extra work: sourcing prices for each contract month, maintaining a contracts table, and tracking expirations and position rolls.

## Build Stages

| Stage | Focus | Status |
| --- | --- | --- |
| Lite | End-to-end build: tables, real prices, trades, basic queries | ✅ Complete |
| Core | All three grains for the full year, trader and broker tables, daily P&L | In progress |
| Full | Broker reconciliation, data quality checks, daily ops report | Planned |
| Pro | Performance tracking, position limits, roll analysis, break trends | Planned |

## Repository Structure

- `data/`: CSV files loaded into the database
- `sql/01_create_tables.sql`: table definitions, keys, and constraints
- `sql/02_queries.sql`: analysis queries

**Tools:** PostgreSQL, pgAdmin, Excel

## Current Stage: Lite

A working end-to-end version of the database for one market and two months.

**Scope:** CBOT corn futures, July 2023 (ZCN23) and September 2023 (ZCU23) contracts, May–June 2023

**Data**
- `contracts.csv`: contract details, including size and expiration date
- `settlement_prices.csv`: 86 rows of daily settlement, high, and low prices from Barchart, converted from cents to dollars per bushel and verified against the source files
- `trades.csv`: 25 simulated trades across 3 traders and 2 brokers, each priced within that day's actual high-low range

**Database design**
- Primary keys on each table, including a composite key (date + contract) for daily prices
- Foreign keys linking trades and prices to contracts
- CHECK constraints that reject invalid data: side must be Buy or Sell, quantity and price must be positive, settlement must fall between the day's low and high, and expiration can't come before the contract month

**Queries**
1. All trades in time order
2. Trade count by trader
3. Net position by contract (buys positive, sells negative)

**Result:** All traders closed their July positions before the first notice day (June 30). The desk ends June long 18 September contracts.

**How to run**
1. Create a PostgreSQL database
2. Run `sql/01_create_tables.sql`
3. Import the CSVs in order: contracts, settlement_prices, trades
4. Run `sql/02_queries.sql`

## Next: Core
Expand to corn, soybeans, and wheat over May 2023 – April 2024, add trader and broker tables, and calculate daily P&L marked to settlement prices.
