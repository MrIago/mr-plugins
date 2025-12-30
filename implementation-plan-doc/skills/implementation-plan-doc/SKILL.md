---
name: implementation-plan-doc
description: Creates structured implementation plan documents. Use when the user wants to document a feature idea, migration plan, architectural change, or any technical implementation proposal. Triggers on phrases like "create implementation doc", "document this plan", "write implementation plan", "create technical spec".
---

# Implementation Plan Document Generator

Creates structured markdown documents for implementation plans following a three-section format optimized for human understanding and LLM consumption.

## Document Structure

Every implementation plan document MUST have exactly three sections:

### 1. Ideia inicial (Initial Idea)

Purpose: Contextualize the problem and propose a solution WITHOUT any code.

Content guidelines:
- Describe the current problem or pain point
- Explain the proposed solution at a high level
- Focus on the "why" and "what", not "how"
- Use plain language, no technical jargon unless necessary
- NO code blocks, NO technical implementation details

### 2. Discussao (Discussion)

Purpose: Explore the implementation approach using simple text and visual aids.

Content guidelines:
- Use only: paragraphs, bullet points, and indentation for nested ideas
- For anything that would need code, use pseudocode showing the flow:
  ```
  SE condicao:
    fazer algo
    SE outra condicao:
      fazer outra coisa
  SENAO:
    alternativa
  ```
- Use ASCII diagrams for flows and architecture:
  ```
  Usuario → Backend → API Externa
     ↓         ↓           ↓
   Input    Processa    Retorna
  ```
- Discuss trade-offs and considerations
- Address edge cases and error handling conceptually
- NO actual code syntax (TypeScript, Python, etc.)

### 3. Base tecnica (Technical Base)

Purpose: Provide whitelabeled technical documentation for LLMs to implement.

Content guidelines:
- Include ONLY documentation needed for implementation
- Remove project-specific context (whitelabel)
- Include:
  - API documentation snippets
  - SDK usage examples
  - Configuration references
  - Code patterns to follow
- This section IS allowed to have real code examples
- Format as reference material, not tutorial

## Output Format

```markdown
# Ideia inicial

## Problema atual

{Describe the current problem without code}

## Proposta de solucao

{Describe the proposed solution without code}

# Discussao

## {Topic 1}

{Discussion with pseudocode and ASCII diagrams}

## {Topic 2}

{More discussion}

## O que e eliminado

{List what gets removed/simplified}

## O que e adicionado

{List what gets added}

## Consideracoes

{Edge cases, trade-offs, risks}

# Base tecnica

## {API/SDK Name} - {Topic}

{Technical documentation snippet}

## {Another Technical Reference}

{More technical docs}
```

## Language

- Write in Portuguese (Brazil) by default
- Use English for technical terms that are commonly used in English
- Section headers are always in Portuguese: "Ideia inicial", "Discussao", "Base tecnica"

## File Location

Save the document to `.docs/{feature-name}.md` in the project root, unless the user specifies a different location.

## Workflow

1. Gather context about the feature/change from the user
2. Research relevant documentation and existing code
3. Draft the three sections following the structure above
4. Present to user for review before saving
5. Save to the specified location
