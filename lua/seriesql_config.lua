SSQL = SSQL or {};
SSQL.config = SSQL.config or {};

/*---------------------------------------------------------------------------
SerieSQL Configuration
---------------------------------------------------------------------------*/

// The connection information for the MySQL server:
SSQL.config.hostname = "192.168.0.33"
SSQL.config.port = "3306"
SSQL.config.username = "fillipuster"
SSQL.config.password = "7163"
SSQL.config.database = "savory"

// Whether or not SSQL should save data to the database whenever data changes:
SSQL.config.continuousSaving = true
// Default: true
// NOTE: true = safer, less risk of data loss, more demanding.
// NOTE: false = riskier, higher risk of data loss, higher risk of exploits, less demanding.

/*---------------------------------------------------------------------------
End of configuration.
---------------------------------------------------------------------------*/