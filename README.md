# OA77 - Optimisation Algorithms course at IST
**Overleaf LaTeX project**
> https://www.overleaf.com/8625457224vdbtpxrfhgbq

**Part 1 of the project**
>[projectpart1.pdf](projectpart1.pdf)

**Part 2 of the project**
>[projectpart2.pdf](projectpart2.pdf)

**Part 3 of the project**
> TODO


 # How to use OverLeaf with git
 1. Make sure that you have cloned the git repository. If you have, you can skip this.

``` bash
git clone https://github.com/mskl/OA77
```

2. Make sure that you are inside the repository and add a new remote.

``` bash
git remote add overleaf https://git.overleaf.com/5db8a22a0b5b18000153e512
```

You can make sure that you have added the remote by typing

``` bash
git remote
# > origin
# > overleaf
```

3. Pull the overleaf remote. You will be prompted for your overleaf credentials.

``` bash
git pull overleaf master
```

All three of the repositories are in sync with your local copy now. When you come to your computer before starting to work on anything you should do
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

If you make any changes on Overleaf, they are not instantly commited. The commit is (automatically) created whenever you pull the changes from Overleaf.

<!---
 - [x] Task 1 - Different Lambdas
 - [x] Task 2 - Without the L2 regularizer
 - [x] Task 3 - L1 regularizer
 - [ ] Task 4 - Comment on what you have observed from Tasks 1 to 3 (for example, compare the impact of the three regularizers on the optimal control signal that they each induce).
 - [x] Task 5 - Using simple geometric arguments, give a closed-form expression for d (p, D(c, r)).
 - [ ] Task 6 - Use the software CVX to solve problem (8)
 - [ ] Task 7 - Task 7. Use the software CVX to solve problem (10).
 - [x] Task 8 - show that φ is non-convex
 - [ ] Task 9 - 
 - [ ] Task 10 - 
 - [ ] Task 11 - reweighting techniques
 - [ ] Task 12 - explain the role of weights
 --->