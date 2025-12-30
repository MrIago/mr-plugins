# Implementation Plan Doc

A Claude Code skill that creates structured implementation plan documents optimized for both human understanding and LLM consumption.

## Usage

The skill triggers automatically when you ask Claude to create implementation documentation:

- "Create an implementation doc for this feature"
- "Document this migration plan"
- "Write a technical spec for the new auth system"

## Document Structure

Every document follows a three-section format:

### 1. Ideia inicial
- Problem contextualization
- Proposed solution
- No code, just concepts

### 2. Discussao
- Implementation approach
- Pseudocode for flows
- ASCII diagrams for architecture
- Trade-offs and considerations

### 3. Base tecnica
- Whitelabeled technical documentation
- API references
- SDK usage examples
- Code patterns

## Output

Documents are saved to `.docs/{feature-name}.md` by default.

## Installation

```bash
/plugin install implementation-plan-doc@mr-plugins
```
