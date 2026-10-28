#!/usr/bin/env bash
set -eu
cd "$(dirname "$0")/.."
echo "===== OpenAPI JSON validation ====="
python3 -c "import json; from pathlib import Path; files=sorted(Path(\"apis\").rglob(\"*.json\")); assert files, \"No OpenAPI JSON files found\"; [json.loads(p.read_text()) for p in files]; [print(\"VALID JSON:\", p) for p in files]"
echo
echo "===== APIM policy XML validation ====="
python3 -c "import xml.etree.ElementTree as ET; from pathlib import Path; files=sorted(Path(\"policies\").glob(\"*.xml\")); assert files, \"No policy XML files found\"; [ET.parse(p) for p in files]; [print(\"VALID XML:\", p) for p in files]"
echo
echo "===== API tests ====="
.venv/bin/python -m pytest -q
echo "LOCAL VALIDATION PASSED"
