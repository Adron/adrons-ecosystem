# Hasure CLI Installation

This post just elaborates on the existing documentation here with a few extra notes and details about installation. This can be helpful when determining how to install, deploy, or use the Hasura CLI for development, continuous integration, or continuous deployment purposes.

## Installation

There are three primary operating system binary installations: Windows, MacOS, and Linux.

### Linux

In the shell run the following curl command to download and install the binary.

```shell
curl -L https://github.com/hasura/graphql-engine/raw/stable/cli/get.sh | bash
```

This command installs the command to `/usr/local/bin`, but if you'd like to install it to another location you can add the follow variable `INSTALL_PATH` and set it to the path that you want.

```shell
curl -L https://github.com/hasura/graphql-engine/raw/stable/cli/get.sh | INSTALL_PATH=$HOME/bin bash
```

What this script does, in short, follows these steps. The latest version is determined, then downloaded with curl. Once that is done, it then assigns permissions to the binary for execution. It also does some checks to determine OS version, type, distro, if the CLI exists or not, and other validations. To download the binary, and source if you'd want for a particular version of the binary, check out the manual steps listed later in this post.

### MacOS

For MacOS the same steps are followed as Linux, as the installation script steps through the same procedures.

```shell
curl -L https://github.com/hasura/graphql-engine/raw/stable/cli/get.sh | bash
```

As with the previous Linux installation, the `INSTALL_PATH` variable can also be set if you'd want the installation of the binary to another path.

### Windows

Windows is a different installation, as one might imagine. The executable ([cli-hasura-windows-amd64.exe](https://github.com/hasura/graphql-engine/releases/download/v1.3.2/cli-hasura-windows-amd64.exe)) is available on the [releases page](https://github.com/hasura/graphql-engine/releases). This leaves it up to you to determine how exactly you want this executable to be called. It's ideal, in my opinion, to download this and then put it into a directory where you'll map the path. You'll also want to rename the executable itself from `cli-hasura-windows-amd64.exe` to `hasura.exe` if for any reason because it's easier to type and then it'll match the general examples provided in the docs.

To setup a path on Windows to point to the directory where you have the executable, you'll want to open up ht environment variables dialog. That would be following *Start > System > System Settings > Environment Variables*. Scroll down until the `PATH` is viewable. Click the edit button to edit that path. Set it, and be sure to set it up like `c:\pathWhatevsAlreadyHere;c:\newPath\directory\where\hasura\executable\is\`. Save that, launch a new console and that new console should have the executable available now.

### Manual Download & Installation

You can also navigate directly to the releases page and get the CLI at [https://github.com/hasura/graphql-engine/releases](https://github.com/hasura/graphql-engine/releases). All of the binaries are compiled and ready for download along with source code zip file of the particular builds for those binaries.

### Installation via npm

The CLI is avialable via an npm package also. It is independently maintained (the package that wraps the executable) by members in the community. If you want to provide a set Hasura CLI version to a project, using npm is a great way to do so.

For example, if you want to install the Hasura CLI, version  in your project as a development dependency, use the following command to get version 1.3.0 for example.

```shell
npm install --save-dev hasura-cli@1.3.0
```

For version 1.3.1 it would be `npm install --save-dev hasura-cli@1.3.1` for example.

The dev dependencies in the package.json file of your project would then look like the following.

```javascript
"devDependencies": {
"hasura-cli": "^1.3.0"
}
```

### Other Notes

Using the npm option is great, if you're installing, using, writing, or otherwise working with JavaScript, have Node.js installed on the dev and other machines, and need to have the CLI availabe on those particular machine instances. If not, I'd suggest installing via one of the binary options, especially if you're creating something like a slimmed down Alpine Linux container to automate some Hasura CLI executions during a build process or something. There are a lot of variance to how you'd want to install and use the CLI, beyond just installing it to run the commands manually. If you're curious about any particular scenarios, ask me [@Adron](https://twittter.com/Adron) and I'll answer there and I'll elaborate here on this post!

Happy Hasura CLI Hacking! 🤘