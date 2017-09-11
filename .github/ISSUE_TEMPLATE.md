# Please fill out the issue checklist below, and provide all of the requested information.

# Please always follow these steps:
- [ ] Confirmed this is a problem with `brew install`ing one, specific formula and not every time you run `brew`? If it's a general `brew` problem please file this issue at https://github.com/Linuxbrew/brew/issues/new.
- [ ] If you have a macOS system and can replicate the problem on macOS with Homebrew, please report the issue to [Homebrew/core](https://github.com/Homebrew/homebrew-core) and follow their issue template from your macOS system. If you are unsure, please report the issue to Linuxbrew.
- [ ] Ran `brew update` and retried your prior step?
- [ ] Ran `brew doctor`, fixed all issues and retried your prior step?
- [ ] Ran `brew gist-logs <formula>` (where `<formula>` is the name of the formula that failed) and included the output link?
- [ ] If `brew gist-logs` didn't work: ran `brew config` and `brew doctor` and included their output with your issue?

To help us debug your issue please explain:
- What you were trying to do (and why)
- What happened (include command output)
- What you expected to happen
- Step-by-step reproduction instructions (by running `brew install` commands)

# Formula additions or changes
To get formulae added or changed in Linuxbrew please file a [Pull Request](https://github.com/Linuxbrew/homebrew-core/blob/master/CONTRIBUTING.md).
To get formulae added or changed that is a dependency of a formula in Linuxbrew/homebrew-core submit a Pull Request to https://github.com/Linuxbrew/homebrew-core/compare
To get formulae added or changed that is not a dependency of a formula in Linuxbrew/homebrew-core submit a Pull Request to https://github.com/Linuxbrew/homebrew-extra/compare
We will close issues requesting formulae changes.
