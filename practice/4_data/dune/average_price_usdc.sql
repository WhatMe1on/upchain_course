--Possibly relevant tables based on your question: ['erc20_ethereum.evt_Transfer', 'prices.usd']

SELECT
  DATE_TRUNC('day', minute) AS day,
  AVG(price) AS avg_price
FROM prices.usd
WHERE
  blockchain = 'ethereum'
-- the address are usdc erc20 token contract_address
  AND contract_address = 0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48
  AND minute >= CURRENT_DATE - INTERVAL '30' day
GROUP BY
  1
ORDER BY
  day desc;