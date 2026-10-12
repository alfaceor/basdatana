
# Create mamba environment

```{bash}
$ mamba create -n basdatana_env python=3.12 r-base=4.4
```


# Installing Packages

We will use mamba (or conda) to install packages or dependencies for both python and R.

```{bash}
$ mamba env export --no-builds > environment.yml
```

To froze the environment we could use

```{bash}
$ mamba env export --explicit > conda-lock.yml
```

Usually is better to install the package and later add it manually to environment.yml
to allow mamba (or conda) choose the best dependencies, then check which version has 
been installed when is decided to add it our environment.

```{bash}
mamba list r-tidyverse
```


# Git suggestions

## Worktrees

Please consider to use git worktrees

```{bash}
mkdir -p basdatana
cd basdatana
git clone --bare git@github.com:alfaceor/basdatana.git .bare
echo "gitdir: ./.bare" > .git
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git config push.autoSetupRemote true # To submit branch automatically to origin after push

# 4. Fetch all remote branches into proper remote refs
git fetch origin

git worktree add main

```

This tells Git that whenever you push a branch that doesn't have an upstream set yet, it should automatically create and track origin/<branch-name>.

```{bash}
git config push.autoSetupRemote true
```

Or when a new worktree (branch) is created then specify the origin

```{bash}
# Syntax: git worktree add <folder-name> -b <branch-name> origin/<branch-name>
git worktree add Correlations -b Correlations origin/Correlations
```

Once a feature is finish the worktree (branch) could be remove it

```{bash}
git worktree remove <path>
git branch -D <branch>
```


## Git squash (with rebase)

New features should be implemented in new branches from dev or main branches.

- main: For production
- dev : To merge implemented features and test compatibilities

1. In the branch (worktree) branch we start the squash by making a rebase

```{bash}
git rebase -i HEAD~5
```
where 5 are the last 5 commits

2. In the text editor that opens:
    - Keep pick on the top (oldest) commit.
    - Change pick to squash (or just s) for all the WIP: commits below it.

3. Save and close the file.
4. In the second editor window that pops up, write your final clean commit message, then save and close.

# Sync Bibliography

To sync papers or books across different devices I will use rclone in ubuntu

To configure for the **first time**:

```{bash}
rclone bisync Papers/ gdrive:GitData/basdatana_Bibliography/Papers --resync -v
rclone bisync Books/ gdrive:GitData/basdatana_Bibliography/Books --resync -v
```

then for the subsequent synchronizations, just remove --resync

```{bash}
rclone bisync Papers/ gdrive:GitData/basdatana_Bibliography/Papers -v
rclone bisync Books/ gdrive:GitData/basdatana_Bibliography/Books -v
```

Now add soft links to keep an easy access to the bibliography

```{bash}
ln -s ~/GDrive/GitData/basdatana_Bibliography/Books/
ln -s ~/GDrive/GitData/basdatana_Bibliography/Papers/
```

