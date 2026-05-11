#!/bin/bash

# sample call => bash +x get_chains_data.sh CROX

# Prüfen, ob ein Symbol als Parameter übergeben wurde
if [ -z "$1" ]; then
  echo "Bitte geben Sie ein Symbol als ersten Parameter an."
  echo "Beispiel: $0 CROX"
  exit 1
fi

symbol="$1"

# Monatsstring aus der JSON-Antwort extrahieren
months_string=$(curl -k -s "https://localhost:4002/v1/api/iserver/secdef/search?symbol=$symbol" \
  -H "accept: application/json" -G | \
  jq -r '.[] | .sections[] | select(.secType == "OPT") | .months')

# Prüfen, ob etwas gefunden wurde
if [ -z "$months_string" ]; then
  echo "Kein OPT-Abschnitt oder keine Monate gefunden für Symbol $symbol"
  exit 1
fi

# IFS auf Semikolon setzen und in Array einlesen
IFS=';' read -r -a months_array <<< "$months_string"

# Über die Monate iterieren
for month in "${months_array[@]}"; do
  echo "Verarbeite Monat: $month"
  # Hier können Sie weitere Aktionen für jeden Monat durchführen
done