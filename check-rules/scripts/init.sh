#!/bin/bash
# UserPromptSubmit hook: Collect files and build launch command

cd "$CLAUDE_PROJECT_DIR"

INPUT=$(cat)
PROMPT=$(echo "$INPUT" | jq -r '.prompt // ""')

# Match /check-rules:audit or /check-rules:audit N
if [[ "$PROMPT" =~ ^/check-rules:audit[[:space:]]*([0-9]*)$ ]]; then
    PART="${BASH_REMATCH[1]:-1}"
else
    exit 0
fi

BATCH_SIZE=10
MAX_AGENTS=10
MAX_FILES=$((BATCH_SIZE * MAX_AGENTS))  # 100 files per part

# Collect all files
TRACKED=$(git diff --name-only HEAD 2>/dev/null | grep -v '^$')
UNTRACKED=$(git ls-files --others --exclude-standard 2>/dev/null | grep -v '^$')

ALL_FILES=()
for f in $TRACKED $UNTRACKED; do
    [[ ! -f "$f" ]] && continue
    case "$f" in
        *.lock|*.png|*.jpg|*.gif|*.ico|*.woff*|*.ttf|*.eot|*.pdf) continue ;;
    esac
    ALL_FILES+=("$f")
done

TOTAL_COUNT=${#ALL_FILES[@]}

if [[ $TOTAL_COUNT -eq 0 ]]; then
    echo "No files to audit."
    exit 0
fi

# Calculate part range
START_INDEX=$(( (PART - 1) * MAX_FILES ))
END_INDEX=$((START_INDEX + MAX_FILES))

if [[ $START_INDEX -ge $TOTAL_COUNT ]]; then
    echo "Part $PART does not exist. Total files: $TOTAL_COUNT"
    exit 0
fi

# Get files for this part
FILES=("${ALL_FILES[@]:$START_INDEX:$MAX_FILES}")
COUNT=${#FILES[@]}

TOTAL_PARTS=$(( (TOTAL_COUNT + MAX_FILES - 1) / MAX_FILES ))
TOTAL_BATCHES=$(( (COUNT + BATCH_SIZE - 1) / BATCH_SIZE ))

# Build launch instructions
INSTRUCTIONS="## CHECK-RULES AUDIT - Part $PART/$TOTAL_PARTS\n\n"
INSTRUCTIONS+="**$COUNT files in $TOTAL_BATCHES batches**\n\n"
INSTRUCTIONS+="**CRITICAL: Send ONE message with $TOTAL_BATCHES Task tool calls in PARALLEL (run_in_background: true for each):**\n\n"

for ((batch=0; batch<TOTAL_BATCHES; batch++)); do
    START=$((batch * BATCH_SIZE))

    BATCH_FILES=""
    for ((i=START; i<START+BATCH_SIZE && i<COUNT; i++)); do
        [[ -n "$BATCH_FILES" ]] && BATCH_FILES="$BATCH_FILES, "
        BATCH_FILES="$BATCH_FILES${FILES[$i]}"
    done

    INSTRUCTIONS+="- Task $((batch+1)): subagent_type=rules-auditor, model=haiku, prompt=\"Audit: $BATCH_FILES\"\n"
done

INSTRUCTIONS+="\nWait ALL TaskOutput. Show summary table.\n"

if [[ $TOTAL_PARTS -gt 1 && $PART -lt $TOTAL_PARTS ]]; then
    INSTRUCTIONS+="\n**More files remaining.** After this part, run: /check-rules:audit $((PART + 1))"
fi

cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "$INSTRUCTIONS"
  }
}
EOF

exit 0
