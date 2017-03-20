# TransPack
B00merang TransPack Script, for easy theme installation and application

**Maintainer:** [Elbullazul](https://github.com/Elbullazul)

**Distributor:** [B00merang Project](https://github.com/B00merang-Project)

**License:** GPL v3

Latest Version: 2.0.1-release

![transpack-terminal](http://b00merang.weebly.com/uploads/1/6/8/1/16813022/screenshot-2016-10-26-14-57-33_orig.png)

## This script now accepts the following flags:
- -h : get help and available flags for the script
- --set-de : force-install a DE, should anything go wrong and the script not recognize your WM
- -v : get script version and some info about the software
- -l : install theme locally instead of copying files to /usr/share
- -u : uninstall themes. Use with -l BEFORE -u to remove from ~/.themes

### How to install

Run the following commands in terminal:
```shell
cd Downloads
wget https://github.com/B00merang-Project/TransPack/archive/master.zip
unzip master.zip
cd transpack-master
chmod +x transpack.sh
./transpack.sh

# To uninstall (beta)
./transpack.sh -u
```

## Extra scripts
- To unity: simple script to make uniti theme from compatible metacity theme
- gtk-compile: make gtk gresource with your themes to improve speed and stability (gtk 3.10 and up only)

**Webpage :** http://b00merang.weebly.com/transpack.html
