#!/bin/bash
# UserPromptSubmit hook: Collect files, create state, launch round 1

cd "$CLAUDE_PROJECT_DIR"

INPUT=$(cat)
PROMPT=$(echo "$INPUT" | jq -r '.prompt // ""')

[[ "$PROMPT" != "/check-rules:audit"* ]] && exit 0

STATE_DIR="$CLAUDE_PROJECT_DIR/.claude/state"
STATE_FILE="$STATE_DIR/check-rules.json"
BATCH_SIZE=10
MAX_PARALLEL=10

mkdir -p "$STATE_DIR"
rm -f "$STATE_FILE"

TRACKED=$(git diff --name-only HEAD 2>/dev/null | grep -v '^$')
UNTRACKED=$(git ls-files --others --exclude-standard 2>/dev/null | grep -v '^$')

FILES=()
for f in $TRACKED $UNTRACKED; do
    [[ ! -f "$f" ]] && continue
    case "$f" in
        *.lock|*.png|*.jpg|*.gif|*.ico|*.woff*|*.ttf|*.eot|*.pdf) continue ;;
    esac
    FILES+=("$f")
done

COUNT=${#FILES[@]}

if [[ $COUNT -eq 0 ]]; then
    echo "No files to audit."
    exit 0
fi

TOTAL_BATCHES=$(( (COUNT + BATCH_SIZE - 1) / BATCH_SIZE ))
TOTAL_ROUNDS=$(( (TOTAL_BATCHES + MAX_PARALLEL - 1) / MAX_PARALLEL ))
LAUNCH_COUNT=$((TOTAL_BATCHES < MAX_PARALLEL ? TOTAL_BATCHES : MAX_PARALLEL))

FILES_JSON=$(printf '%s\n' "${FILES[@]}" | jq -R . | jq -s .)

cat > "$STATE_FILE" << EOF
{
  "plugin_version": "1.0.6",
  "project_dir": "$CLAUDE_PROJECT_DIR",
  "files": $FILES_JSON,
  "total_files": $COUNT,
  "batch_size": $BATCH_SIZE,
  "max_parallel": $MAX_PARALLEL,
  "total_batches": $TOTAL_BATCHES,
  "total_rounds": $TOTAL_ROUNDS,
  "current_round": 1
}
EOF

# Build compact launch instructions
INSTRUCTIONS="AUDIT: $COUNT files, $TOTAL_BATCHES batches, $TOTAL_ROUNDS rounds.\n\n"
INSTRUCTIONS+="Round 1: Launch $LAUNCH_COUNT agents in SINGLE message (run_in_background=true):\n"

for ((i=0; i<LAUNCH_COUNT; i++)); do
    INSTRUCTIONS+="- Task: rules-auditor, haiku, prompt=\"Batch $i\"\n"
done

INSTRUCTIONS+="\nAfter launching, STOP. Hook handles next round."

cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "$INSTRUCTIONS"
  }
}
EOF

exit 0
