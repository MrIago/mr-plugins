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
MAX_PARALLEL=$(jq -r '.max_parallel' "$STATE_FILE")

if [[ $CURRENT_ROUND -lt $TOTAL_ROUNDS ]]; then
    NEXT_ROUND=$((CURRENT_ROUND + 1))

    START_BATCH=$((CURRENT_ROUND * MAX_PARALLEL))
    END_BATCH=$((START_BATCH + MAX_PARALLEL))
    [[ $END_BATCH -gt $TOTAL_BATCHES ]] && END_BATCH=$TOTAL_BATCHES
    BATCH_COUNT=$((END_BATCH - START_BATCH))

    jq ".current_round = $NEXT_ROUND" "$STATE_FILE" > "${STATE_FILE}.tmp" && mv "${STATE_FILE}.tmp" "$STATE_FILE"

    REASON="Round $NEXT_ROUND/$TOTAL_ROUNDS: Launch $BATCH_COUNT agents (batches $START_BATCH-$((END_BATCH-1))). "
    for ((i=START_BATCH; i<END_BATCH; i++)); do
        REASON+="Task: rules-auditor, haiku, prompt=Batch $i. "
    done
    REASON+="After launching, STOP."

    echo "{\"decision\": \"block\", \"reason\": \"$REASON\"}"
    exit 0
else
    rm -f "$STATE_FILE"
    echo "{\"decision\": \"block\", \"reason\": \"All agents launched. Wait ALL TaskOutput, show summary, ask to fix if failures.\"}"
    exit 0
fi
