#!/bin/bash




# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token
USERNAME=$username
TOKEN=$token

# User and Repository information
REPO_OWNER=$1

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
       # Send a GET request to the GitHub API with authentication and print the raw response
    response=$(curl -s -u "${USERNAME}:${TOKEN}" "$url")

    # Print the raw response for debugging
    echo "Raw response: $response"

    # Return the response for further processing
    echo "$response"

  
     
}

# Function to list users with read access to the repository
function list_no_of_repos {
    local endpoint="users/${REPO_OWNER}/repos"

    # Fetch the list of collaborators on the repository
    repositories="$(github_api_get "$endpoint" | sed 's/^Raw response://' | jq -r '.[].name')"


    # Display the list of collaborators with read access
    if [[ -z "$repositories" ]]; then
        echo "No repository found for owner ${REPO_OWNER}"
    else
        echo "Repo's for owner ${REPO_OWNER}"
        echo "$repositories"

	while read -r repo; do
            echo "Fetching pull requests for repository: $repo"
            local pull_request_count
            pull_request_count="$(github_api_get "repos/${REPO_OWNER}/${repo}/pulls" | sed 's/^Raw response://' | jq '. | length')"
            echo "Number of pull requests in $repo: $pull_request_count"
        done <<< "$repositories"
    fi
}
# Main script

echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_no_of_repos

