# Introduction

Show me a bash script, with error checking, that collects the commit logs from a git repository for the previous calendar month only and output the commit logs as an unordered list in chronological order in dokuwiki compatible formatting

## Script Output

Below is a Bash script that you can use to achieve this. The script assumes that you want to collect commit logs for the previous calendar month from the current date.

```bash
#!/bin/bash

# Function to display usage information
function show_usage {
  echo "Usage: $0 <path/to/git/repo>"
  exit 1
}

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
  show_usage
fi

repo_path="$1"

# Check if the provided path is a valid directory
if [ ! -d "$repo_path" ]; then
  echo "Error: The provided path is not a valid directory."
  show_usage
fi

# Navigate to the git repository
cd "$repo_path" || exit

# Get the start and end dates for the previous month
start_date=$(date -d "$(date +%Y-%m-01) -1 month" +%Y-%m-%d)
end_date=$(date -d "$(date +%Y-%m-01)" +%Y-%m-%d)

# Collect commit logs for the previous month
commit_logs=$(git log --pretty=format:'%h %s (%an)' --since="$start_date" --until="$end_date")

# Check if there are any commits for the previous month
if [ -z "$commit_logs" ]; then
  echo "No commits found for the previous month."
  exit 0
fi

# Format commit logs as DokuWiki unordered list
echo "==== Commit Logs for $start_date to $end_date ===="
echo "{{{"
echo "$commit_logs" | awk '{print "* " $0}'
echo "}}}"

exit 0
```

Save this script to a file (e.g., git_commit_logs.sh), make it executable (chmod +x git_commit_logs.sh), and then run it with the path to your Git repository as an argument:

```bash
./git_commit_logs.sh /path/to/your/git/repo

```
This script uses git log to retrieve commit logs within the specified date range, formats them as an unordered list in DokuWiki-compatible syntax, and prints the result to the console. If there are no commits for the previous month, it will notify you.
