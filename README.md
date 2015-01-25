# hubot-piptools

Ask your bot if library updates are needed.

## What it can do

- reply which library needs update
- (todo) reply updated list of libraries in requirements.txt ready format
- (todo) major/minor update aware


## Installation

1. add `achiku/hubot-piptools` to package.json
2. add "hubot-piptools" to external-scripts.json
3. pip install libraries
4. Reboot Hubot

## Configuration:

create proper GitHub API token and set to the following environmental variable.

```
HUBOT_GITHUB_API_TOKEN
```

## Commands

```
hubot pip-check [github_user_name] [repositoryName] [relative path to requirements.txt]
```
