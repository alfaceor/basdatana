
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
