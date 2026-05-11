#!/bin/bash

# Hilfe anzeigen, falls nicht genug Parameter
if [ $# -lt 1 ]; then
  echo "Verwendung: $0 SYMBOL [MAX_STRIKES]"
  echo "Beispiel: $0 CROX 10"
  exit 1
fi

symbol="$1"
max_strikes="${2:-5}"  # Default: 5 Strikes pro Seite (Calls/Puts)

echo "==> Optiere für $symbol, max. $max_strikes Strikes pro Seite"

# 1. Monatsliste aus dem secdef/search holen
months_string=$(curl -k -s "https://localhost:4002/v1/api/iserver/secdef/search?symbol=$symbol" \
  -H "accept: application/json" -G | \
  jq -r '.[] | .sections[] | select(.secType == "OPT") | .months')

if [ -z "$months_string" ]; then
  echo "Kein OPT-Abschnitt oder keine Monate für $symbol gefunden."
  exit 1
fi

# 2. Monate/Weeks am Semikolon splitten
IFS=';' read -r -a months_array <<< "$months_string"

# Hilfsfunktion: Prüfen ob Eintrag ein Weekly ist (beginnt mit W)
is_weekly() {
  [[ "$1" =~ ^W[0-9] ]] && echo "ja" || echo "nein"
}

# 3. Für jeden Monats-/Weeklyeintrag die Strikes abrufen
for month in "${months_array[@]}"; do
  weekly_flag=$(is_weekly "$month")
  echo ""
  echo "=== Verfallszyklus: $month (Weekly: $weekly_flag) ==="

  # Strikes für diesen Zyklus abrufen
  strikes_json=$(curl -k -s "https://localhost:4002/v1/api/iserver/secdef/strikes?symbol=$symbol&month=$month" \
    -H "accept: application/json" -G)

  # Prüfen ob Antwort gültig ist (entweder calls oder puts)
  if echo "$strikes_json" | jq -e '.calls.strikes' >/dev/null 2>&1; then
    # Calls extrahieren
    calls=$(echo "$strikes_json" | jq -r ".calls.strikes | .[:$max_strikes][]")
    puts=$(echo "$strikes_json" | jq -r ".puts.strikes | .[:$max_strikes][]")

    echo "CALL Strikes (max $max_strikes):"
    for strike in $calls; do
      echo "  - $strike"
    done

    echo "PUT Strikes (max $max_strikes):"
    for strike in $puts; do
      echo "  - $strike"
    done
  else
    echo "Keine Strikes für $month gefunden (Antwort: $strikes_json)"
  fi
done