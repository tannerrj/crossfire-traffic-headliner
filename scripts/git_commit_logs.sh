#!/bin/bash

# Step 1: Function to display usage information
function show_usage {
  echo "Usage: $0 <path/to/git/repo>"
  exit 1
}

# Step 2: Check if the correct number of arguments is provided
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
commit_logs=$(git log --pretty=format:'%s' --since="$start_date" --until="$end_date" --reverse)

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
