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
