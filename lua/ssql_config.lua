SSQL = SSQL or {}
SSQL.config = SSQL.config or {}

/*---------------------------------------------------------------------------
SerieSQL Configuration
---------------------------------------------------------------------------*/

// The backend which should provide data persistence to SerieSQL:
SSQL.config.dataProvider = "mysql"

// The configuration for the chosen provider:
SSQL.config.providerConfig = {
    hostname = "localhost",
    username = "gmod",
    password = "1234",
    database = "gmod",
    port = 3307
}

/*---------------------------------------------------------------------------
End of configuration.
---------------------------------------------------------------------------*/