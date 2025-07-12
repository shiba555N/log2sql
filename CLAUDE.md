# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a log2sql utility project that contains two HTML-based tools for extracting SQL statements from log files:

1. **createsql.html** - Advanced SQL extraction tool with parameter substitution
   - Parses log files to extract SQL statements and their associated parameters
   - Replaces placeholder parameters ($1, $2, etc.) with actual values
   - Handles proper SQL escaping for strings, null values, and booleans

2. **mok.html** - Basic SQL extraction tool
   - Uses regex patterns to extract standard SQL statements (SELECT, INSERT, UPDATE, DELETE, etc.)
   - Simpler approach without parameter substitution

## File Structure

```
log2sql/
├── createsql.html          # Parameter-aware SQL extraction tool
├── mok.html               # Basic regex-based SQL extraction tool
└── samples/
    └── sample01.log       # Sample log file with PostgreSQL query logs
```

## Development Approach

- This is a client-side only project using vanilla HTML, CSS, and JavaScript
- No build process or package management required
- Files can be opened directly in a browser for testing
- Sample log format shows PostgreSQL query logs with Vite/Hono application context

## Log Format Support

The tools are designed to work with PostgreSQL application logs that contain:
- Query lines with format: `Query: <SQL statement>`
- Parameter lines with format: `-- params: [value1, value2, ...]`
- The advanced tool (createsql.html) processes these together to create executable SQL

## Testing

To test the tools:
1. Open either HTML file directly in a web browser
2. Use the provided sample log file in `samples/sample01.log`
3. Drag and drop the log file into the tool interface
4. Verify SQL extraction results