There adopted `gorush`, to establish a (web) server that can push notification to mobile app. The original page can be found [here](https://github.com/appleboy/gorush).

# Installation

First pull the package and install by:

    git clone https://github.com/appleboy/gorush.git
    cd gorush
    go install

# Running

    gorush -c config.yml

The default setting of `config.yml` can be found [here](https://github.com/appleboy/gorush/blob/master/config/testdata/config.yml).

To allow pushing notification to IOS, the following has to be changed:

    ios:
        enabled: true
        key_base64: "<keybase>" # load iOS key from base64 input
        key_type: "p8" # could be pem, p12 or p8 type
        password: "" # certificate password, default as empty string.
        production: false
        max_concurrent_pushes: 100 # just for push ios notification
        max_retry: 0 # resend fail notification, default value zero is disabled
        key_id: "<KeyID>" # KeyID from developer account (Certificates, Identifiers & Profiles -> Keys)
        team_id: "<teamID>" # TeamID from developer account (View Account -> Membership)

The `<keybase>`, `<keyID>`, and `<teamID>` has to be replaced by actual IDs.

Alternatively, notifications can be pushed by the following command:

    gorush -ios -m "<your_message>" -i "<path of key>" -t "<device_token>" --topic "<your_topic>"