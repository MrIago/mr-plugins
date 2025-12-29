#!/bin/bash
# UserPromptSubmit hook: Launch first round of audit batches

cd "$CLAUDE_PROJECT_DIR"

INPUT=$(cat)
PROMPT=$(echo "$INPUT" | jq -r '.prompt // ""')

# Match namespaced command: /check-rules:audit
[[ "$PROMPT" != "/check-rules:audit"* ]] && exit 0

STATE_DIR="$CLAUDE_PROJECT_DIR/.claude/state"
STATE_FILE="$STATE_DIR/check-rules.json"
BATCH_SIZE=10
MAX_PARALLEL=10

# Ensure state directory exists
mkdir -p "$STATE_DIR"

# Clean up stale state from interrupted runs
rm -f "$STATE_FILE"

# Collect files
TRACKED=$(git diff --name-only HEAD 2>/dev/null | grep -v '^$')
UNTRACKED=$(git ls-files --others --exclude-standard 2>/dev/null | grep -v '^$')

FILES=()
for f in $TRACKED $UNTRACKED; do
    [[ ! -f "$f" ]] && continue
    case "$f" in
        *.lock|*.png|*.jpg|*.gif|*.ico|*.woff*|*.ttf|*.eot|*.pdf) continue ;;
    esac
    FILES+=("$CLAUDE_PROJECT_DIR/$f")
done

COUNT=${#FILES[@]}

if [[ $COUNT -eq 0 ]]; then
    echo "No files to audit. Working tree is clean."
    exit 0
fi

TOTAL_BATCHES=$(( (COUNT + BATCH_SIZE - 1) / BATCH_SIZE ))
TOTAL_ROUNDS=$(( (TOTAL_BATCHES + MAX_PARALLEL - 1) / MAX_PARALLEL ))
LAUNCH_COUNT=$((TOTAL_BATCHES < MAX_PARALLEL ? TOTAL_BATCHES : MAX_PARALLEL))

# Create state as JSON array
FILES_JSON=$(printf '%s\n' "${FILES[@]}" | jq -R . | jq -s .)

cat > "$STATE_FILE" << EOF
{
  "files": $FILES_JSON,
  "total_files": $COUNT,
  "batch_size": $BATCH_SIZE,
  "max_parallel": $MAX_PARALLEL,
  "total_batches": $TOTAL_BATCHES,
  "total_rounds": $TOTAL_ROUNDS,
  "current_round": 1
}
EOF

echo "## CHECK-RULES AUDIT"
echo ""
echo "**$COUNT files | $TOTAL_BATCHES batches | $TOTAL_ROUNDS rounds**"
echo ""
echo "### Round 1/$TOTAL_ROUNDS (batches 1-$LAUNCH_COUNT)"
echo ""
echo "Launch ALL in SINGLE message (run_in_background: true):"
echo ""

for ((batch=0; batch<LAUNCH_COUNT; batch++)); do
    START=$((batch * BATCH_SIZE))

    BATCH_FILES=""
    for ((i=START; i<START+BATCH_SIZE && i<COUNT; i++)); do
        [[ -n "$BATCH_FILES" ]] && BATCH_FILES="$BATCH_FILES, "
        BATCH_FILES="$BATCH_FILES${FILES[$i]}"
    done

    echo "Task $((batch+1)): rules-auditor"
    echo "  prompt: \"Audit: $BATCH_FILES\""
    echo ""
done

echo "After ALL TaskOutput collected, STOP."
if [[ $TOTAL_ROUNDS -gt 1 ]]; then
    echo "Stop hook will continue with round 2."
else
    echo "Then show summary and ask about fixes."
fi

exit 0
