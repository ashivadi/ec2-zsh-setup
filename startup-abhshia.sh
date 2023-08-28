#!/bin/sh

#most of this is from https://gist.github.com/aaabramov/0f1d963d788bf411c0629a6bcf20114d

cd ec2-zsh-setup/


sudo yum update -y 

#sudo passwd ssm-user < this does not work, so change shell in /etc/passwd


# Installing ZSH
sudo yum -y install zsh

# Check ZSH has been installed
zsh --version

# Install "util-linux-user" because "chsh" is not available by default
# See https://superuser.com/a/1389273/599050
sudo yum install util-linux-user -y

# Change default shell for current user, most of the times it would be "ec2-user"
# Or use "sudo chsh -s $(which zsh) $(whoami)" to be sure
# change in shell in /etc/passwd
#chsh -s "$(which zsh)"

# Install oh-my-zsh from https://github.com/ohmyzsh/ohmyzsh#basic-installation

sudo yum install git -y
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

cp vimrc ~/.vimrc
cp zshrc_ec2 ~/.zshrc

# OPTIONAL

# I recommend you to install the following plugins which make your life easier and more colorful

# Assuming you have git installed
# If not, simply do "sudo yum install git -y"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# And then add them to "~/.zshrc" file
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
