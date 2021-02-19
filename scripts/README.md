This folder contain a set of scripts to manage the repository.
They are described in the following points:

 - `commit_release.sh <release version>`  
    It creates a commit, with the current submodules versions, and a tag for the defined release version.
    It requires that Changelog.md has been updated to explain the release changes.

 - `do_pull.sh`  
    It updates the repository to the latest commit in the master branch.
    Then, it updates all submodules to the pointed versions.

 - `do_release.sh <release version>`  
    It updates all sub-modules to their latest commit in the master branch.
    Then, it creates a commit, with the new submodules versions, and a tag for the defined release version.
    It requires that Changelog.md has been updated to explain the release changes.

 - `do_update.sh`  
    It updates the repository to the latest commit in the master branch.
    Then, it updates all sub-modules to latest upstream commit of master branch.
