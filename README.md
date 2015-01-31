# hubot-piptools

Ask your bot if library updates are needed.

![sample](https://github.com/achiku/hubot-piptools/raw/master/hipchat-sample.png "hipchat sample image")


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

Create proper GitHub API token and set to the following environmental variable.

```
HUBOT_GITHUB_API_TOKEN
```

Set emoticons for your chattool.

```
HUBOT_EMOTICON_SUCCESS
HUBOT_EMOTICON_FAIL
```

## Commands

```
hubot pip-check [githubUserName] [repositoryName] [relative path to requirements.txt]
```
