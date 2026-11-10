-- Query 1: All trades, oldest first 
SELECT * FROM trades 
ORDER BY trade_date ASC, trade_time ASC;

-- Query 2: Number of trades per trader
SELECT trader, COUNT(*) AS trade_count
FROM trades
GROUP BY trader
ORDER BY trader;

-- Query 3: Net position by contract (buys positive, sells negative)
SELECT contract_code,
	SUM(CASE WHEN side = 'Buy' THEN quantity ELSE -quantity END) AS net_position
FROM trades
GROUP BY contract_code
ORDER BY contract_code; 
