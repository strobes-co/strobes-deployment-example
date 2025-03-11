db.createUser(
    {
        user: "strobes",
        pwd: "<replace-me>",
        roles: [
            {
                role: "readWrite",
                db: "threat_intel"
            }
        ]
    }
)