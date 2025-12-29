#!/bin/bash
# Stop hook: Continue to next round or finish

cd "$CLAUDE_PROJECT_DIR"

STATE_FILE="$CLAUDE_PROJECT_DIR/.claude/state/check-rules.json"

[[ ! -f "$STATE_FILE" ]] && exit 0

INPUT=$(cat)
STOP_HOOK_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // false')
[[ "$STOP_HOOK_ACTIVE" == "true" ]] && exit 0

CURRENT_ROUND=$(jq -r '.current_round' "$STATE_FILE")
TOTAL_ROUNDS=$(jq -r '.total_rounds' "$STATE_FILE")
TOTAL_BATCHES=$(jq -r '.total_batches' "$STATE_FILE")
BATCH_SIZE=$(jq -r '.batch_size' "$STATE_FILE")
MAX_PARALLEL=$(jq -r '.max_parallel' "$STATE_FILE")
TOTAL_FILES=$(jq -r '.total_files' "$STATE_FILE")

if [[ $CURRENT_ROUND -lt $TOTAL_ROUNDS ]]; then
    # More rounds to go
    NEXT_ROUND=$((CURRENT_ROUND + 1))

    # Calculate batch range for this round
    START_BATCH=$((CURRENT_ROUND * MAX_PARALLEL))
    END_BATCH=$((START_BATCH + MAX_PARALLEL))
    [[ $END_BATCH -gt $TOTAL_BATCHES ]] && END_BATCH=$TOTAL_BATCHES
    BATCH_COUNT=$((END_BATCH - START_BATCH))

    # Update state
    jq ".current_round = $NEXT_ROUND" "$STATE_FILE" > "${STATE_FILE}.tmp" && mv "${STATE_FILE}.tmp" "$STATE_FILE"

    REASON="### Round $NEXT_ROUND/$TOTAL_ROUNDS (batches $((START_BATCH+1))-$END_BATCH)\\n\\n"
    REASON="${REASON}Launch ALL in SINGLE message (run_in_background: true):\\n\\n"

    for ((batch=START_BATCH; batch<END_BATCH; batch++)); do
        FILE_START=$((batch * BATCH_SIZE))
        FILE_END=$((FILE_START + BATCH_SIZE))

        BATCH_FILES=$(jq -r ".files[$FILE_START:$FILE_END] | join(\", \")" "$STATE_FILE")

        REASON="${REASON}Task $((batch - START_BATCH + 1)): rules-auditor\\n"
        REASON="${REASON}  prompt: \\\"Audit: $BATCH_FILES\\\"\\n\\n"
    done

    REASON="${REASON}After ALL TaskOutput, STOP."

    echo "{\"decision\": \"block\", \"reason\": \"$REASON\"}"
    exit 0
else
    # All rounds done - allow to finish naturally
    rm -f "$STATE_FILE"
    echo '{"decision": "approve"}'
    exit 0
fi
