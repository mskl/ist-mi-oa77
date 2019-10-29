1. Make sure that you have cloned the git repository. If you have, you can skip this.

``` bash
git clone https://github.com/mskl/OA77
```

2. Make sure that you are inside the repository and add a new remote.

``` bash
git remote add overleaf https://git.overleaf.com/5db8a22a0b5b18000153e512
```

3. Pull the overleaf remote. You will be prompted for your overleaf credentials.

``` bash
git pull overleaf master
```

All three of the repositories are in sync with your local copy. When you come to your computer before starting to work on anything you should do
``` bash
git pull origin master      # pull the repo from git
git pull overleaf master    # pull the repo from overleaf
```

If you want to propagate some of the changes into the overleaf (you have added some images, and want to include them into the LaTeX) you will do 
``` bash
git add <files>
git commit -m "your commit message"
git push overleaf master
```

After you have done any work on any of the other files, you should commit them and push them into the GitHub like this
``` bash
git add <files>
git commit -m "your commit message"
git push origin master

# In case you need some of the files also on overleaf
git push overleaf master
```