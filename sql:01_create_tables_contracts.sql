CREATE TABLE contracts(
	contract_code VARCHAR(5) PRIMARY KEY, 
	commodity VARCHAR(8) NOT NULL,
	contract_month DATE NOT NULL, 
	exchange VARCHAR(5) NOT NULL,
	contract_size INTEGER NOT NULL CHECK (contract_size > 0),
	expiration_date DATE NOT NULL, 
	CHECK (expiration_date >= contract_month)
);
CREATE TABLE settlement_prices( 
	settlement_date DATE NOT NULL,
	contract_code VARCHAR(5) NOT NULL REFERENCES contracts(contract_code),
	settlement_price NUMERIC(6,4) NOT NULL, 
	daily_high NUMERIC(6,4) NOT NULL,
	daily_low NUMERIC(6,4) NOT NULL,
	PRIMARY KEY (settlement_date, contract_code),
	CHECK (daily_low <= settlement_price AND settlement_price <= daily_high)
);
CREATE TABLE trades (
	trade_id VARCHAR(5) PRIMARY KEY,
	trade_date DATE NOT NULL,
	trade_time TIME NOT NULL,
	trader VARCHAR(8) NOT NULL,
	side VARCHAR(4) NOT NULL CHECK (side IN ('Buy', 'Sell')),
	quantity INTEGER NOT NULL CHECK (quantity > 0),
	contract_code VARCHAR(5) NOT NULL REFERENCES contracts(contract_code),
	price NUMERIC(6,4) NOT NULL CHECK (price > 0),
	broker VARCHAR(8) NOT NULL
);