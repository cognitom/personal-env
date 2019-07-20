# App

## 1. Create VM instance on GCP

Login to GCP, and open Google Cloud Shell.

```bash
$ curl https://raw.githubusercontent.com/cognitom/personal-env/master/workspace/create.sh | sh
```

## 2. Add a DNS record

Add a new DNS record for the private IP address in Cloud DNS.

## 3. Connect to VM

Now, you can access your docker dashboard via the url like `http://workspace.example.com`.


That's it!
