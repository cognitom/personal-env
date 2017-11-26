# Remote

## 1. Create VM instance on GCP

For example, to create an instance named "hello", run the command below: 

```bash
$ curl https://raw.githubusercontent.com/cognitom/personal-env/master/remote/create-instance.sh | sh -s hello
```

## 2. Setup Linux environment

Run [init.sh](init.sh) script at inside the VM:

```bash
$ curl https://raw.githubusercontent.com/cognitom/personal-env/master/remote/init.sh | sh
```

Do some tasks which need interaction.

```bash
$ kr pair
```

If you have not set a public key on GitHub yet, run this command, too:

```bash
$ kr github
```

That's it!
