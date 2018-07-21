# Remote

## 1. Create VM instance on GCP

Login to GCP, and open Google Cloud Shell.

For example, to create an instance named "hello", run the command below: 

```bash
$ curl https://raw.githubusercontent.com/cognitom/personal-env/master/remote/create.sh | sh -s hello
```


## 2. Connect to VM

Now, you can connect to your VM via `hello.example.com`. Open Codeanywhere and choose `File > New Connection > SFTP - SSH` from the menu.

- Hostname: `public.hello.example.com`
- Username: `cognitom`
- Public Key

We have two sub-domain names:

- `public.hello.example.com` - for access from public
- `hello.example.com` - for access from local or VPN


## 3. Setup Linux environment

Do some tasks which need interaction.

```bash
$ kr pair
```

If you have not set a public key on GitHub yet, run this command, too:

```bash
$ kr github
```

Do what you want. For example:

```bash
$ git clone git@github.com:cognitom/some-private-repo.git
```

That's it!
