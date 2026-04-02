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
2. **Quick scan only.** Run `ls` (no flags) to confirm the workspace state.
   Do NOT explore extensively — there is nothing to find yet.
   Do NOT read devcontainer configs, Dockerfiles, or example files.
   Move directly to drafting the plan.
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

<constraints>
- When constraints conflict, prioritize: correctness > safety > simplicity > style.
- Do not introduce new dependencies without checking if they are already available.
- Do not modify files outside the scope of the current request.
- Ask clarifying questions early rather than building the wrong thing.
- If a shell command fails, try a simpler alternative immediately. Do not spend
  time analyzing the error — just use a basic version of the command and move on.
</constraints>
