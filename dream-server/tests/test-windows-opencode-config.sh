#!/bin/bash
# ============================================================================
# Dream Server Windows OpenCode config tests
# ============================================================================
# Static checks for the Windows OpenCode config migration/update path.
# ============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
DEVTOOLS_PS1="$ROOT_DIR/installers/windows/phases/07-devtools.ps1"

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
PASS=0
FAIL=0

pass() { echo -e "  ${GREEN}PASS${NC} $1"; PASS=$((PASS + 1)); }
fail() { echo -e "  ${RED}FAIL${NC} $1"; FAIL=$((FAIL + 1)); }

echo ""
echo "=== Windows OpenCode config tests ==="
echo ""

[[ -f "$DEVTOOLS_PS1" ]] && pass "07-devtools.ps1 exists" || fail "07-devtools.ps1 missing"
grep -q "function Sync-WindowsOpenCodeConfig" "$DEVTOOLS_PS1" && pass "sync helper exists" || fail "sync helper missing"
grep -q 'config.json' "$DEVTOOLS_PS1" && pass "config.json sync exists" || fail "config.json sync missing"
grep -q 'Get-WindowsDreamEnvMap' "$DEVTOOLS_PS1" && pass "OpenCode config reads shared env helper" || fail "shared env helper missing from OpenCode config path"
grep -q 'OpenCode config updated' "$DEVTOOLS_PS1" && pass "existing config update message exists" || fail "existing config update message missing"

if grep -q 'preserving existing configuration' "$DEVTOOLS_PS1"; then
    fail "existing configs are still preserved without migration"
else
    pass "existing configs are no longer preserved without migration"
fi

echo ""
echo "Result: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
