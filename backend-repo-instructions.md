# How to run Stake locally

## Prerequisites

1.  Ensure docker is running with kubernetes enabled

2.  Clone primeslice/backend

3.  Have NVM installed

4.  Set up your aws access via SSO, as well as your local kubernetes config by following these instructions:

        https://stakedotcom.atlassian.net/wiki/spaces/DEV/pages/588775563/AWS+CLI+and+EKS+setup+-+Granted

5.  Create a `.env.local` file and populate it with the following. Reach out to the other devs if this doesn't work for any reason

    ```ini
    PORT=80

    VITE_ALLOW_INDEXING=false
    VITE_HIDE_SEAL="false"
    VITE_MOONPAY_SECRET="sk_live_HMZuJzsw5VQxNMVytzRwPurkQPVJ67K"
    VITE_IN_TERRAFORM="false"
    VITE_SITE_MODE="local"
    VITE_SANITY_DATASET="production"
    VITE_THIRD_PARTY=true
    VITE_X_FIREWALL_BYPASS='OtNR4VZDpFYQ5RZYitOO43Gf3Ah90Cb3rH1qlTqm'

    # comment or uncomment the environment that you want to use as your backend
    VITE_PRODUCT="stake"
    SERVICE_ADDRESS="friedbrais.club"
    VITE_SERVER_ADDRESS_OVERRIDE="friedbrais.club"

    # VITE_PRODUCT="stake"
    # SERVICE_ADDRESS="easygo-lucky-volunteer.com"
    # VITE_SERVER_ADDRESS_OVERRIDE="easygo-lucky-volunteer.com"

    # VITE_PRODUCT='sweeps'
    # SERVICE_ADDRESS="primebrais.com"
    # VITE_SERVER_ADDRESS_OVERRIDE="primebrais.com"

    #staging
    VITE_HCAPTCHA_KEY="10000000-ffff-ffff-ffff-000000000001"
    VITE_TURNSTILE_KEY='1x00000000000000000000AA'
    SANITY_DEV_TOKEN="sk0L3iwaxPKygWag4kaWPNV8uCiToE9LkCtj4kG1adidTfvoh9NRwIWk1BpMLWy43yiEzjTs0XrEE3NqdVxNBJsiQJADsZeWfaYNEB8oMxwDYSTjsahwLAPjNNs9t5vz5UJSRLskI9F63w0jU0j10kV0l6fbkdjaJH8gBN18hnUwNsPF7LpK"
    ```

## Backend

1. `cd <git_dir>/backend/backend/`

2. Ensure you're using the correct node version defined in `.nvmrc`

3. Install node dependencies

   `pnpm install`

4. Set up local kubernetes stack

   `pnpm run start`

5. If successful, you should see output similar to the following:

   ```shell
   [terraform]:  2024-07-12T12:45:48.272+1000 [INFO]  provider: plugin process exited: plugin=.terraform/providers/registry.terraform.io/hashicorp/kubernetes/2.13.1/darwin_arm64/terraform-provider-kubernetes_v2.13.1_x5 id=37738

   [terraform]:
       Warning: "default_secret_name" is no longer applicable for Kubernetes v1.24.0 and above

         with module.elasticsearch.kubernetes_service_account_v1.kibana,
         on ../modules/elasticsearch-local/kibana.tf line 1, in resource "kubernetes_service_account_v1" "kibana":
          1: resource "kubernetes_service_account_v1" "kibana" {

       Starting from version 1.24.0 Kubernetes does not automatically generate a
       token for service accounts, in this case, "default_secret_name" will be
       empty

       (and 13 more similar warnings elsewhere)

   [terraform]:
   Apply complete! Resources: 63 added, 0 changed, 0 destroyed.

   ✨  Done in 45.27s.
   ```

6. Run `pnpm run watch`

# Frontend

1. Open up the stake-kit (front end) folder in the backend repo

   `cd <git_dir>/backend/stake-kit`

2. Build & run the front end

   ```shell
   pnpm install

   pnpm run stake-no-ssl
   ```

3. Wait for the terminal to show the following, then visit the shown URL in your browser

NOTE: If you see strange errors, check your node version! Make sure nvm/node are _not_ installed via homebrew and ensure that you're using the `.nvmrc` file in the `stake-kit` folder (run `nvm use`).

6. Log in using `root`/`password` or using an account for the

# ACP

You can run the ACP (admin control panel) locally by running `pnpm run acp` in the `stake-kit` directory; **HOWEVER**, when running the ACP at the same time as the front-end, you'll only be able to render one of the two in your browser. This is because of [weird vite funk](https://github.com/primeslice/backend/pull/8016/files).

# Authenticating / Executing GraphQL commands via API

**_NOTE_**: There are a couple of handy tools that you can use for GraphQL development:

- Altair (Off-cloud: `brew install --cask altair-graphql-client`)
- Apollo Studio ([Cloud-based](https://studio.apollographql.com/sandbox/explorer))

1. Go to the live stake environment that corresponds to the API you want to access, and log in (ie. [lucky-volunteer](https://easygo-lucky-volunteer.com/))
2. Pull up the "Network" tab in the developer console
3. Find a request for `/graphql` and copy the **request** header value of `x-access-token`

   **\*NOTE**: This is your auth token that is required for some services in the graphql API. This may rotate over time, so if you receive `error.not_authenticated` / `notAuthenticated`, it's likely you'll need to grab this token again.\*

# Running the ACP locally / giving your root user some $money$

**_NOTE_**: Currently, as the same Vite instance is used across the ACP and the Stake site, only one can be active at a time (one will overwrite the other when run). This [could (have) be fixed](https://github.com/primeslice/backend/pull/8016) but the change was bounced due to a potential upgrade to NX [?]
