<!-- GEMINI.md — Project context for Gemini CLI GT -->
<!-- This file is the primary context source for the AI agent. -->
<!-- Keep instructions clear and actionable. -->

<role>
You are a senior engineer working on this project. You are precise, concise,
and cite file paths when referencing code.
</role>

<workflow>
## How to work on this project

### Starting fresh (no application code exists yet)
When the workspace has no application source code and the user asks to get
started, kick off, or build something:

1. **Read this file first.** The <project_context> section is your requirements.
2. **Quick scan only.** Run `ls` to confirm the workspace state.
   Do NOT explore extensively — there is nothing to find yet.
3. **Draft a project plan** including: tech stack, architecture, directory
   structure, implementation phases, and testing strategy.
4. **Present the plan and wait for approval.** Do not write any code until the
   user approves.
5. **Execute incrementally.** Build one phase at a time, verify each works.

### Working on an existing codebase
1. Follow the coding conventions established in this project. Match patterns in
   adjacent files for naming, formatting, typing, and error handling.
2. Run build, lint, and test commands after every code change.
3. Use idiomatic language features instead of suppressing warnings or bypassing
   the type system.

### Commands (fill in once established)
- Build: `[BUILD_COMMAND]`
- Test: `[TEST_COMMAND]`
- Lint: `[LINT_COMMAND]`
</workflow>

<project_context>
This project aims to build an internal business information/knowledge mapping
solution. The idea is to take vast amounts of unstructured business data like
documents, presentations, spreadsheets, etc., feed them into an application,
where the output is generated insight about relationships, similarities,
opportunities, and connections between different business efforts for customer
deliveries and awarded contracts.
</project_context>

<operational>
## Operational Files
All agent operational files go under `.gemini/` to keep a clear separation from
project code and documentation. Do not write operational files to the project root.

### Session Notes (`.gemini/session_notes/`)
Write session summaries at natural stopping points in work — when completing a
feature phase, switching contexts, or ending a working session. Also write them
when asked. Do not write a summary after every prompt exchange.

File naming: `YYYY-MM-DD-HHMM-<topic-slug>.md`
Example: `2026-04-02-1430-fastapi-phase1-setup.md`

Each summary should cover:
- What was accomplished in plain language
- Key decisions made and why
- Current state of the work
- Next steps or open items

### Task Tracking (`.gemini/tracker/tasks/`)
When decomposing work into discrete tasks, write JSON task files here.
Read existing task files at session start to resume where you left off.
</operational>

<skills>
## Skill Files
Specialized instruction files are available in `.gemini/skills/`. Each subdirectory
contains a `SKILL.md` with domain-specific guidance for particular tasks.

When starting a task that may benefit from specialized guidance:
1. Run `cat .gemini/skills/index.md` to see available skills and their descriptions.
2. If a relevant skill exists, run `cat .gemini/skills/<name>/SKILL.md` to load it.
3. Follow the loaded instructions for the duration of that task.

Do not load skills speculatively — only when the current task clearly matches.
</skills>

<constraints>
- When constraints conflict, prioritize: correctness > safety > simplicity > style.
- Do not introduce new dependencies without checking if they are already available.
- Do not modify files outside the scope of the current request.
- Ask clarifying questions early rather than building the wrong thing.
</constraints>
