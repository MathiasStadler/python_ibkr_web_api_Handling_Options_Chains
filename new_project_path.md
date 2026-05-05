# restart 05.05.2026 - call put option chain via IBKR  restful api on IBgateway
<!-- ktf-->
## fallow intruction on webpage Option Chains - Web API v1.0 Documentation [![alt text][1]](https://www.interactivebrokers.com/campus/ibkr-api-page/cpapi-v1/#authentication)
<!--ktf-->
## Check status
<!-- ktf -->
```bash <!-- markdownlint-disable-line code-block-style -->
curl -k -s "https://localhost:4002/v1/api/iserver/auth/status" \
-H "accept: application/json" \
-G 
```
<!-- ktf -->
## Step One: Instantiate the Option Chain [![alt text][1]](https://www.interactivebrokers.com/campus/ibkr-api-page/cpapi-v1/#option-chain)
<!-- ktf -->
- change to port 4002
- change sysmbol to TREX
<!-- ktf -->
### bash
<!-- ktf -->
```bash <!-- markdownlint-disable-line code-block-style -->
curl -k -s "https://localhost:4002/v1/api/iserver/secdef/search?symbol=TREX" \
-H "accept: application/json" \
-G 
```
<!-- ktf -->
## Step Two: Find potential Strikes [![alt text][1]](https://www.interactivebrokers.com/campus/ibkr-api-page/cpapi-v1/#oc-step-two)
<!-- ktf -->
we change for Symbol TREX the  "conid":"6608603"
we change to akt option chain date
> [!NOTE] Add current option chain date
<!-- ktf -->
```bash <!-- markdownlint-disable-line code-block-style -->
curl -k -s "https://localhost:4002/v1/api/iserver/secdef/strikes?conid=6608603&secType=OPT&month=MAY26" \
-H "accept: application/json" \
-G

#with variable/placehoder for url
baseUrl=https://localhost:4002/v1/api
echo "$baseUrl"
curl -k -s "$baseUrl/iserver/secdef/strikes?conid=6608603&secType=OPT&month=MAY26" -H "accept: application/json" -G

```
<!-- ktf -->
## Step Three: Validate The Contract [![alt text][1]](https://www.interactivebrokers.com/campus/ibkr-api-page/cpapi-v1/#oc-step-three)
<!-- ktf -->
```bash <!-- markdownlint-disable-line code-block-style -->
curl \
--url {{baseUrl}}/iserver/secdef/info?conid=416904&secType=OPT&month=JAN25&strike=3975&right=P \
--request GET

############
baseUrl=https://localhost:4002/v1/api
echo "$baseUrl"
curl -k -s "$baseUrl/iserver/secdef/info?conid=6608603&secType=OPT&month=MAY265&strike=40&right=P" -G

```
<!-- ktf -->
## Live Market Data Snapshot [![alt text][1]](https://www.interactivebrokers.com/campus/ibkr-api-page/cpapi-v1/#md-snapshot)
<!-- ktf -->
```bash <!-- markdownlint-disable-line code-block-style -->
curl \
--url {{baseUrl}}/iserver/marketdata/snapshot?conids=865445386,8314&fields=31,84,86 \ 
--request GET
##########
baseUrl=https://localhost:4002/v1/api
echo "$baseUrl"
curl -k -s "$baseUrl/iserver/marketdata/snapshot?conids=865445386,8314&fields=31,84,86" -G
echo $?

```
<!-- ktf -->
## Addinal Market Data Fields [![alt text][1]](https://www.interactivebrokers.com/campus/ibkr-api-page/cpapi-v1/#market-data-fields)
<!-- ktf -->
- example filed 70 and 71 , High , Low
<!-- ktf -->
```bash <!-- markdownlint-disable-line code-block-style -->
baseUrl=https://localhost:4002/v1/api
echo "$baseUrl"
curl -k -s "$baseUrl/iserver/marketdata/snapshot?conids=865445386,8314&fields=31,84,86,7308,7309,7310,7311,7633" -G
echo $?
```
<!-- ktf -->
## Pritty print /w pathon json.tool [![alt text][1]](https://stackoverflow.com/questions/352098/how-can-i-pretty-print-json-in-a-shell-script)- Addinal Market Data Fields [![alt text][1]](https://www.interactivebrokers.com/campus/ibkr-api-page/cpapi-v1/#market-data-fields)
<!-- ktf -->
- example filed 70 and 71 , High , Low
<!-- ktf -->
7633	string	Implied Vol. %	The implied volatility for the specific strike of the option in percentage. To query the Option Implied Vol. % from the underlying refer to field 7283.
<!-- ktf -->
| Column 1      | Column 2      |
| ------------- | ------------- |
| Cell 1, Row 1 | Cell 2, Row 1 |
| Cell 1, Row 2 | Cell 1, Row 2 |
<!-- ktf -->
```bash <!-- markdownlint-disable-line code-block-style -->
baseUrl=https://localhost:4002/v1/api
echo "$baseUrl"
curl -k -s "$baseUrl/iserver/marketdata/snapshot?conids=865445386,8314&fields=31,84,86,7308,7309,7310,7311,7633" -G | python -m json.tool
echo $?
```
<!-- ktf -->
<!-- To comply with the format -->
<!-- Link sign - Don't Found a better way :-( - You know a better method? - send me a email -->
>[!NOTE]
>Symbol to mark web external links [![alt text][1]](./README.md)
<!-- spell-checker: disable  -->
<!-- keep the format -->
<!-- make folder and download the link sign vai curl -->
<!-- mkdir -p img && curl --create-dirs --output-dir img -O  "https://raw.githubusercontent.com/MathiasStadler/link_symbol_svg/refs/heads/main/link_symbol.svg"-->
<!-- Link sign - Don't Found a better way :-( - You know a better method? - **send me a email** -->
[1]: ./img/link_symbol.svg
<!-- keep the format -->