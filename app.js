const path = require("path");
const express = require("express");
const bodyParser = require("body-parser");
const sql = require("mssql");
const { DefaultAzureCredential } = require("@azure/identity");
const { SecretClient } = require("@azure/keyvault-secrets");

const app = express();
app.use(bodyParser.urlencoded({ extended: true }));

// Azure Key Vault settings
const keyVaultName = "userapp-keyvault-dev"; // <-- Replace with your Key Vault name
const vaultUrl = `https://${keyVaultName}.vault.azure.net`;
const credential = new DefaultAzureCredential();
const secretClient = new SecretClient(vaultUrl, credential);

// Fetch secrets from Key Vault
async function getDbConfigFromKeyVault() {
    try {
        const user = await secretClient.getSecret("sql-username");
        const password = await secretClient.getSecret("sql-password");
        const server = await secretClient.getSecret("sql-server");
        const database = await secretClient.getSecret("sql-database");

        return {
            user: user.value,
            password: password.value,
            server: server.value,
            database: database.value,
            options: {
                encrypt: true,
                trustServerCertificate: true
            }
        };
    } catch (err) {
        console.error("Failed to fetch secrets from Key Vault:", err.message);
        throw err;
    }
}

// SQL Server connection pool
async function connectToDb() {
    const dbConfig = await getDbConfigFromKeyVault();

    try {
        const pool = await sql.connect(dbConfig);
        return pool;
    } catch (err) {
        console.error("Database connection error:", err.message);
        throw err;
    }
}

// Handle form submission
app.post("/submit", async (req, res) => {
    const { name, email, contact } = req.body;

    try {
        const pool = await connectToDb();

        const query = `INSERT INTO Users (Name, Email, Contact) VALUES (@name, @email, @contact)`;

        const request = pool.request();
        request.input("name", sql.NVarChar, name);
        request.input("email", sql.NVarChar, email);
        request.input("contact", sql.NVarChar, contact);

        await request.query(query);

        res.send("Data saved successfully!");
    } catch (err) {
        console.error("Error inserting data:", err.message);
        res.status(500).send("Internal Server Error");
    }
});

// Serve static files
app.use(express.static(path.join(__dirname, "public")));

app.get("/", (req, res) => {
    res.sendFile(path.join(__dirname, "public", "index.html"));
});

// Start server
app.listen(3030, "0.0.0.0", () => {
    console.log("Server is running on port 3030");
});
