//! A custom linter and formating to enforce the rules of the psql dialect in the sql language 
//! Added a custom npm package please see the package.json file for all npm's
//! no import and export statement using the older style with variable declarations

const fs = require('fs');
const path = require('path');
const sqlFormatter = require('sql-formatter');

// File path to your SQL file relative path based on the current script's location
const filePath = path.resolve(__dirname, '../intro-psql.sql');

// Custom linting rules for this psql project
const lintRules = {
    indentSize: 2, // Expected indentation size (2 spaces)
};

// SQL keywords to enforce as uppercase should also apply to PSQL
const sqlKeywords = [
    'SELECT', 'FROM', 'WHERE', 'JOIN', 'LEFT JOIN', 'RIGHT JOIN', 'INNER JOIN', 'ON',
    'INSERT', 'UPDATE', 'DELETE', 'GROUP BY', 'ORDER BY', 'HAVING', 'LIMIT', 'DATE',
    'AGE', 'EXTRACT', 'CURRENT_DATE', 'NOW', 'INTERVAL'
];

// Function to lint formatted SQL (PSQL dialect)
function lintSQL(sqlContent) {
    const lines = sqlContent.split('\n');
    const issues = [];

    lines.forEach((line, index) => {
        const lineNumber = index + 1;

        // Check for indentation size (correct indent size is 2 spaces)
        const leadingSpaces = line.match(/^\s+/);
        if (leadingSpaces && leadingSpaces[0].length % lintRules.indentSize !== 0) {
            issues.push(`Line ${lineNumber}: Incorrect indentation. Expected multiples of ${lintRules.indentSize} spaces.`);
        }

        // Check for INNER JOIN alignment
        if (line.includes('INNER JOIN') && !line.startsWith('  INNER JOIN')) {
            issues.push(`Line ${lineNumber}: INNER JOIN should be indented by ${lintRules.indentSize * 2} spaces.`);
        }

        // Check SELECT, FROM, WHERE alignment (should not have excessive spaces)
        if ((/^\s*SELECT/.test(line) && line.match(/\s{2,}/g)) ||
            (/^\s*FROM/.test(line) && line.match(/\s{2,}/g)) ||
            (/^\s*WHERE/.test(line) && line.match(/\s{2,}/g))) {
            issues.push(`Line ${lineNumber}: SELECT, FROM, or WHERE clause should not have excessive spaces.`);
        }

        // Ensure SQL keywords like SELECT, FROM, WHERE and date-related functions are uppercase
        sqlKeywords.forEach(keyword => {
            const regex = new RegExp(`\\b${keyword.toLowerCase()}\\b`, 'g');
            if (line.match(regex)) {
                issues.push(`Line ${lineNumber}: SQL keyword "${keyword}" should be uppercase.`);
            }
        });

        // Check for date literals in the correct format (YYYY-MM-DD)
        const dateRegex = /\b\d{4}-\d{2}-\d{2}\b/;
        if (line.match(/'(.*?)'/g)) {
            const dateMatches = line.match(/'(.*?)'/g);
            dateMatches.forEach(match => {
                if (!dateRegex.test(match)) {
                    issues.push(`Line ${lineNumber}: Date literal "${match}" should be in YYYY-MM-DD format.`);
                }
            });
        }
    });

    return issues;
}

// Function to enforce uppercase keywords in SQL
function enforceUppercaseKeywords(sqlContent) {
    sqlKeywords.forEach(keyword => {
        const regex = new RegExp(`\\b${keyword.toLowerCase()}\\b`, 'g');
        sqlContent = sqlContent.replace(regex, keyword);
    });
    return sqlContent;
}

// Read the SQL file
fs.readFile(filePath, 'utf8', (err, data) => {
    if (err) {
        console.error('Error reading the file:', err);
        return;
    }

    // Format the SQL content, enforcing PostgreSQL dialect
    let formattedSql = sqlFormatter.format(data, {
        language: 'postgresql', // Set the SQL dialect to PostgreSQL
        indent: '  ', // Two spaces for indentation
    });

    // Apply custom formatting logic to ensure the formatting meets specific requirements
    formattedSql = formattedSql
        .replace(/\n\s+ON/g, ' ON')  // Ensures 'ON' stays on the same line as 'JOIN'
        .replace(/SELECT\n\s+/g, 'SELECT ') // Ensures SELECT is followed by columns on the same line
        .replace(/FROM\n\s+/g, 'FROM ') // Ensures FROM is followed by the table name on the same line
        .replace(/WHERE\n\s+/g, 'WHERE '); // Ensures WHERE stays on the same line as the condition

    // Enforce uppercase SQL keywords
    formattedSql = enforceUppercaseKeywords(formattedSql);

    // Lint the formatted SQL
    const lintIssues = lintSQL(formattedSql);

    // Output the linting issues if any
    if (lintIssues.length > 0) {
        console.log('Linting issues found:');
        lintIssues.forEach(issue => console.log(issue));
    } else {
        console.log('No linting issues found.');
    }

    // Output the formatted SQL to the console
    console.log('Formatted SQL:\n', formattedSql);

    // Optionally, write the formatted SQL back to the file 
    fs.writeFile(filePath, formattedSql, 'utf8', (writeErr) => {
        if (writeErr) {
            console.error('Error writing the file:', writeErr);
            return;
        }

        console.log('SQL file formatted and saved successfully.');
    });
});

/*
This code performs custom linting and formatting for SQL files that follow the PostgreSQL (psql) dialect. The process involves:

  1. **Reading the SQL File**: It reads the content of an SQL file (`intro-psql.sql`) using a relative path.

  2. **Formatting the SQL Content**:
    - It applies formatting rules using the `sql-formatter` package, specifically tailored for PostgreSQL (`postgresql` dialect).
    - It ensures that specific SQL keywords (like `SELECT`, `FROM`, `WHERE`, etc.) are followed by columns or conditions on the same line, improving readability.

  3. **Linting the SQL Content**:
    - The code checks if SQL keywords such as `SELECT`, `FROM`, `WHERE`, etc., are written in uppercase.
    - It checks for correct indentation, enforcing 2-space indentation.
    - It validates date literals to ensure they follow the `YYYY-MM-DD` format.
    - It ensures that certain clauses like `INNER JOIN` are properly aligned.

  4. **Enforcing Uppercase Keywords**: 
    - The code scans the SQL file to enforce that specific SQL keywords (like `SELECT`, `FROM`, `WHERE`, etc.) are uppercase. 

  5. **Reporting Issues**:
    - If any linting issues are detected (e.g., incorrect indentation or lowercase SQL keywords), the issues are printed in the console.
    - If no issues are found, it prints a message indicating that no linting issues were found.

  6. **Writing the Formatted SQL Back to the File**:
    - After formatting and linting, the code writes the corrected SQL content back to the original file, replacing the previous content with the formatted SQL.
*/