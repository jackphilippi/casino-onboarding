# Setting up developer environment for casino devs

## Install shell and other tools

@jackphilippi wrote a setup script to install fish shell, starship and most of the required casino dependencies. Not everything here may be relevant, so read the script and install things selectively as you need. The script may not run for you in its current state :):

[Jack's setup script](https://github.com/jackphilippi/osx-config-setup)

## Install docker for mac (and make sure it's running)

https://docs.docker.com/desktop/install/mac-install/

### Enable Kubernetes for Docker

This is required in order to run the codebases in your local environment

Go to `Settings -> Kubernetes -> Enable -> Apply & Restart`

## Install other tools

NOTE: Some of these are covered in jack's setup script above. Try not to install the same thing twice!

- brew
- node
- nvm
- pyenv
- awscli
- fish
- kubectl
- minikube
- k9s
- terraform
  ```shell
  # NOTE: terraform can be installed via homebrew, but the default formula is deprecated (@v1.5.7), so make sure you tab the newest one
  brew tap hashicorp/tap
  brew install hashicorp/tap/terraform
  # Ensure that your installed version is >1.9.1
  ```

## Set up AWS

Follow [the AWS CLI / EKS setup doc](https://stakedotcom.atlassian.net/wiki/spaces/DEV/pages/588775563/AWS+CLI+and+EKS+setup+-+Granted)

## Configure an SSH key to use in github

### Generate your key

Generate the key using `ssh-keygen`. Follow the prompts and leave the passphrase empty if you prefer.

```shell
ssh-keygen -t ed25519 -C "f.mertens@easygo.io" -f ~/.ssh/id_easygo_git
```

### Add it to your github account

Copy the new public key to your clipboard

```shell
cat ~/.ssh/id_easygo_git.pub | pbcopy
```

Visit the [Add new SSH Key](https://github.com/settings/ssh/new) page on Github. Add a title (ie. "Easygo Macbook") and paste your public key into the "Key" section.
